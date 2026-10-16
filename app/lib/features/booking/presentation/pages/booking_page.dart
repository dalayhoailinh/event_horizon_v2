import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/breadcrumbs.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../discovery/domain/entities/event_detail.dart';
import '../../../discovery/presentation/blocs/event_detail/event_detail_cubit.dart';
import '../../../discovery/presentation/blocs/event_detail/event_detail_state.dart';
import '../blocs/booking_create/booking_create_cubit.dart';
import '../blocs/booking_create/booking_create_state.dart';
import '../widgets/event_summary_strip.dart';
import '../widgets/ticket_quantity_row.dart';

class BookingPage extends StatelessWidget {
  final String eventId;
  const BookingPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventDetailCubit>(
          create: (_) => getIt<EventDetailCubit>()..load(eventId),
        ),
        BlocProvider<BookingCreateCubit>(
          create: (_) => getIt<BookingCreateCubit>(),
        ),
      ],
      child: _BookingView(eventId: eventId),
    );
  }
}

class _BookingView extends StatelessWidget {
  final String eventId;

  const _BookingView({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final detailState = context.watch<EventDetailCubit>().state;
    final title = detailState.detail?.summary.title;

    return BlocListener<BookingCreateCubit, BookingCreateState>(
      listenWhen: (previous, current) =>
          previous.bookingId == null && current.bookingId != null,
      listener: (context, state) => context.go(
        state.paymentRequired
            ? RouteNames.paymentPath(state.bookingId!)
            : RouteNames.ticketDetailPath(state.bookingId!),
      ),
      child: WebPage(
        title: title == null ? 'Đặt vé' : 'Đặt vé - $title',
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
                      const Crumb('Đặt vé'),
                    ],
                  ),
                  AppSpacing.vMd,
                ],
                switch (detailState) {
                  EventDetailState(:final failure?) => ErrorRetryView(
                    failure: failure,
                    onRetry: () =>
                        context.read<EventDetailCubit>().load(eventId),
                  ),
                  EventDetailState(:final detail?) => _BookingBody(
                    eventId: eventId,
                    detail: detail,
                  ),
                  // No detail and no failure yet = still loading.
                  _ => const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SkeletonBox(height: 92, radius: AppRadius.lg),
                      AppSpacing.vMd,
                      SkeletonBox(height: 240, radius: AppRadius.lg),
                    ],
                  ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingBody extends StatelessWidget {
  static const double _sideWidth = 360;

  final String eventId;
  final EventDetail detail;
  const _BookingBody({required this.eventId, required this.detail});

  @override
  Widget build(BuildContext context) {
    final summary = detail.summary;
    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EventSummaryStrip(
          title: summary.title,
          coverImageUrl: summary.coverImageUrl,
          startAt: summary.startAt,
          venue: summary.venueName,
        ),
        AppSpacing.vMd,
        _TicketTypeList(detail: detail),
      ],
    );
    final order = _OrderSummary(eventId: eventId, detail: detail);

    if (!context.windowSize.isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [left, AppSpacing.vMd, order],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        AppSpacing.hLg,
        SizedBox(width: _sideWidth, child: order),
      ],
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final String eventId;
  final EventDetail detail;
  const _OrderSummary({required this.eventId, required this.detail});

  int _total(Map<String, int> quantities) {
    var total = 0;
    for (final type in detail.ticketTypes) {
      total += type.price * (quantities[type.id] ?? 0);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<BookingCreateCubit>().state;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Đơn của bạn',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.vMd,
            for (final type in detail.ticketTypes)
              if ((state.quantities[type.id] ?? 0) > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${state.quantities[type.id]}× ${type.name}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(formatVnd(type.price * state.quantities[type.id]!)),
                    ],
                  ),
                ),
            if (state.totalTickets == 0)
              Text(
                'Chọn số lượng vé ở bên cạnh.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const Divider(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tổng số tiền',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  formatVnd(_total(state.quantities)),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            AppSpacing.vMd,
            // Lỗi hiện NGAY CẠNH nút gây ra nó, không phải snackbar trôi ở đáy.
            if (state.errorMessage case final message?) ...[
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              AppSpacing.vSm,
            ],
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(0, 52)),
              onPressed: state.canSubmit
                  ? () => context.read<BookingCreateCubit>().submit(eventId)
                  : null,
              child: Text(
                state.submitting ? 'Đang đặt…' : 'Đặt ${state.totalTickets} vé',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketTypeList extends StatelessWidget {
  final EventDetail detail;
  const _TicketTypeList({required this.detail});

  @override
  Widget build(BuildContext context) {
    final quantities = context.watch<BookingCreateCubit>().state.quantities;
    final sellable = [
      for (final type in detail.ticketTypes)
        if (type.isActive) type,
    ];

    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Chọn loại vé',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.vSm,
            if (sellable.isEmpty)
              const Text('Sự kiện này chưa mở bán vé.')
            else
              for (var i = 0; i < sellable.length; i++) ...[
                if (i > 0) const Divider(),
                TicketQuantityRow(
                  ticketType: sellable[i],
                  quantity: quantities[sellable[i].id] ?? 0,
                  onChanged: (value) => context
                      .read<BookingCreateCubit>()
                      .setQuantity(sellable[i].id, value),
                ),
              ],
          ],
        ),
      ),
    );
  }
}
