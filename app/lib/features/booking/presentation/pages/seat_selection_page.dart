import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/breadcrumbs.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../discovery/domain/entities/event_detail.dart';
import '../../domain/entities/seat_booking.dart';
import '../../domain/entities/seat_map.dart';
import '../blocs/seat_selection/seat_selection_cubit.dart';
import '../blocs/seat_selection/seat_selection_state.dart';
import '../widgets/event_summary_strip.dart';
import '../widgets/seat_map_view.dart';
import '../widgets/seat_visual.dart';

class SeatSelectionPage extends StatelessWidget {
  final String eventId;

  const SeatSelectionPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SeatSelectionCubit>()..start(eventId),
      child: _SeatSelectionView(eventId: eventId),
    );
  }
}

class _SeatSelectionView extends StatelessWidget {
  static const double _sideWidth = 360;

  final String eventId;
  const _SeatSelectionView({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SeatSelectionCubit>().state;
    final title = state.detail?.summary.title;
    final wide = context.windowSize.isExpanded;

    final Widget body = switch (state) {
      SeatSelectionState(loading: true) => const _SeatPageSkeleton(),
      SeatSelectionState(:final loadError?) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(loadError, textAlign: TextAlign.center),
        ),
      ),
      _ when wide => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _MapColumn(state: state)),
          AppSpacing.hLg,
          SizedBox(
            width: _sideWidth,
            child: _SelectedSeatsCard(state: state),
          ),
        ],
      ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MapColumn(state: state),
          AppSpacing.vMd,
          _SelectedSeatsCard(state: state),
        ],
      ),
    };

    return BlocListener<SeatSelectionCubit, SeatSelectionState>(
      listenWhen: (previous, current) =>
          previous.bookingId == null && current.bookingId != null,
      listener: (context, state) => context.go(
        state.paymentRequired
            ? RouteNames.paymentPath(state.bookingId!)
            : RouteNames.ticketDetailPath(state.bookingId!),
      ),
      child: WebPage(
        title: title == null ? 'Chọn ghế' : 'Chọn ghế - $title',
        actions: const [],
        sections: [
          PageSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!useAppShell()) ...[
                  Breadcrumbs(
                    items: [
                      const Crumb('Khám phá', RouteNames.events),
                      Crumb(
                        title ?? 'Sự kiện',
                        RouteNames.eventDetailPath(eventId),
                      ),
                      const Crumb('Chọn ghế'),
                    ],
                  ),
                  AppSpacing.vMd,
                ],
                body,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Event strip + seat map card + legend.
class _MapColumn extends StatefulWidget {
  final SeatSelectionState state;
  const _MapColumn({required this.state});

  @override
  State<_MapColumn> createState() => _MapColumnState();
}

class _MapColumnState extends State<_MapColumn> {
  // A lock expires by the CLOCK, not by data: RTDB sends no event when
  // expiresAt passes. Repaint periodically so expired locks turn free.
  static const _repaintEvery = Duration(seconds: 5);
  Timer? _ticker;

  SeatSelectionState get state => widget.state;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(_repaintEvery, (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  SeatVisual _visualOf(SeatCell cell) => seatVisualFor(
    cell: cell,
    lock: state.locks[cell.code],
    selectedByMe: state.selected.contains(cell.code),
    now: DateTime.now(),
  );

  Color _colorOf(BuildContext context, SeatCell cell) {
    final scheme = Theme.of(context).colorScheme;
    return switch (_visualOf(cell)) {
      SeatVisual.aisle => Colors.transparent,
      SeatVisual.sold => scheme.outline,
      SeatVisual.mine => scheme.primary,
      SeatVisual.heldByOther => AppColors.seatHeld,
      SeatVisual.free => tierColor(state.detail, cell.ticketTypeId),
    };
  }

  @override
  Widget build(BuildContext context) {
    final detail = state.detail;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (detail != null) ...[
          EventSummaryStrip(
            title: detail.summary.title,
            coverImageUrl: detail.summary.coverImageUrl,
            startAt: detail.summary.startAt,
            venue: detail.summary.venueName,
          ),
          AppSpacing.vMd,
        ],
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final floor in state.floors) ...[
                  if (state.floors.length > 1) ...[
                    Text(floor.name, style: theme.textTheme.titleMedium),
                    AppSpacing.vSm,
                  ],
                  SeatMapView(
                    floor: floor,
                    colorOf: _colorOf,
                    onTap: (cell) => switch (_visualOf(cell)) {
                      SeatVisual.aisle ||
                      SeatVisual.sold ||
                      SeatVisual.heldByOther => null,
                      _ => () => context.read<SeatSelectionCubit>().toggle(
                        cell,
                      ),
                    },
                  ),
                  AppSpacing.vMd,
                ],
              ],
            ),
          ),
        ),
        AppSpacing.vMd,
        _Legend(detail: detail),
      ],
    );
  }
}

/// Free-seat colour per ticket type: the first (cheapest, "Thường") green,
/// the next (VIP) yellow — the design file's palette.
Color tierColor(EventDetail? detail, String? ticketTypeId) {
  final ids = [
    for (final t in detail?.ticketTypes ?? const <TicketTypeInfo>[]) t.id,
  ];
  return ids.indexOf(ticketTypeId ?? '') <= 0
      ? AppColors.green500
      : AppColors.seatVip;
}

class _Legend extends StatelessWidget {
  final EventDetail? detail;
  const _Legend({required this.detail});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final types = detail?.ticketTypes ?? const <TicketTypeInfo>[];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        for (final t in types)
          _LegendItem(color: tierColor(detail, t.id), label: t.name),
        _LegendItem(color: scheme.primary, label: 'Đang chọn'),
        _LegendItem(color: AppColors.seatHeld, label: 'Người khác giữ'),
        _LegendItem(color: scheme.outline, label: 'Đã bán'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
        AppSpacing.hSm,
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

/// "Ghế đã chọn": chips (tap ✕ to release), one line per ticket type, total,
/// and the button that turns the seats into a booking.
class _SelectedSeatsCard extends StatelessWidget {
  final SeatSelectionState state;
  const _SelectedSeatsCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final seats = state.selected.toList()..sort();
    final cubit = context.read<SeatSelectionCubit>();
    final typesById = {
      for (final t in state.detail?.ticketTypes ?? const <TicketTypeInfo>[])
        t.id: t,
    };
    final cellsByCode = {
      for (final floor in state.floors)
        for (final cell in floor.cells) cell.code: cell,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ghế đã chọn',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.vMd,
            if (seats.isEmpty)
              Text(
                'Bấm vào ghế trống trên sơ đồ để chọn '
                '(tối đa ${SeatSelectionCubit.maxSeatsPerBooking} ghế).',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else ...[
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final code in seats)
                    InputChip(
                      label: Text(code),
                      selected: true,
                      deleteIcon: const Icon(Icons.close, size: 16),
                      deleteIconColor: scheme.onPrimary,
                      onDeleted: switch (cellsByCode[code]) {
                        final cell? => () => cubit.toggle(cell),
                        null => null,
                      },
                    ),
                ],
              ),
              AppSpacing.vSm,
              Text(
                '${seats.length} ghế đã chọn',
                style: theme.textTheme.labelLarge,
              ),
              const Divider(height: AppSpacing.xl),
              for (final item in groupSeatsIntoItems(
                state.floors,
                state.selected,
              ))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}× '
                          '${typesById[item.ticketTypeId]?.name ?? 'Vé'} '
                          '(${(item.seatCodes.toList()..sort()).join(', ')})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        formatVnd(
                          (typesById[item.ticketTypeId]?.price ?? 0) *
                              item.quantity,
                        ),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              const Divider(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tổng số tiền',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    formatVnd(state.totalAmount),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
            if (state.message case final message?) ...[
              AppSpacing.vMd,
              _InlineError(message: message),
            ],
            AppSpacing.vMd,
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
              onPressed: state.canProceed ? cubit.proceed : null,
              child: Text(state.proceeding ? 'Đang đặt…' : 'Tiếp tục'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error shown right where the user acted (web rule: not a toast at the
/// bottom of the screen).
class _InlineError extends StatelessWidget {
  final String message;
  const _InlineError({required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.smd),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: scheme.error),
          AppSpacing.hSm,
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SeatPageSkeleton extends StatelessWidget {
  const _SeatPageSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SkeletonBox(height: 92, radius: AppRadius.lg),
        AppSpacing.vMd,
        SkeletonBox(height: 360, radius: AppRadius.lg),
      ],
    );
  }
}
