import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../discovery/domain/entities/event_detail.dart';
import '../../domain/entities/seat_map.dart';
import '../blocs/seat_selection/seat_selection_cubit.dart';
import '../blocs/seat_selection/seat_selection_state.dart';
import '../widgets/seat_map_view.dart';
import '../widgets/seat_visual.dart';

class SeatSelectionPage extends StatefulWidget {
  final String eventId;

  const SeatSelectionPage({super.key, required this.eventId});

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SeatSelectionCubit>()..start(widget.eventId),
      child: const _SeatSelectionView(),
    );
  }
}

class _SeatSelectionView extends StatelessWidget {
  const _SeatSelectionView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SeatSelectionCubit>().state;
    final title = state.detail?.summary.title;

    return WebPage(
      title: title == null ? 'Chọn ghế' : 'Chọn ghế - $title',
      actions: const [],
      sections: [
        PageSection(
          child: switch (state) {
            SeatSelectionState(loading: true) => const Center(
              child: CircularProgressIndicator(),
            ),
            SeatSelectionState(:final loadError?) => Text(loadError),
            _ => _SeatMapList(state: state),
          },
        ),
      ],
    );
  }
}

class _SeatMapList extends StatelessWidget {
  final SeatSelectionState state;

  const _SeatMapList({required this.state});

  Color _tierColor(ColorScheme scheme, SeatCell cell) {
    final types = [
      for (final type in state.detail?.ticketTypes ?? const <TicketTypeInfo>[])
        type.id,
    ];
    return types.indexOf(cell.ticketTypeId ?? '') <= 0
        ? scheme.surfaceContainerHighest
        : scheme.tertiaryContainer;
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
      SeatVisual.sold => scheme.outlineVariant,
      SeatVisual.mine => scheme.primary,
      SeatVisual.heldByOther => scheme.secondaryContainer,
      SeatVisual.free => _tierColor(scheme, cell),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.message case final message?) ...[
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          AppSpacing.vSm,
        ],
        for (final floor in state.floors) ...[
          Text(floor.name, style: theme.textTheme.titleMedium),
          AppSpacing.vSm,
          SeatMapView(
            floor: floor,
            colorOf: _colorOf,
            onTap: (cell) => switch (_visualOf(cell)) {
              SeatVisual.aisle ||
              SeatVisual.sold ||
              SeatVisual.heldByOther => null,
              _ => () => context.read<SeatSelectionCubit>().toggle(cell),
            },
          ),
          AppSpacing.vMd,
          if (state.floors.isNotEmpty) _SeatOrderSummary(state: state),
        ],
      ],
    );
  }
}

class _SeatOrderSummary extends StatelessWidget {
  final SeatSelectionState state;

  const _SeatOrderSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final seats = state.selected.toList()..sort();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ghế đã chọn', style: theme.textTheme.titleMedium),
            AppSpacing.vSm,
            Text(
              seats.isEmpty ? 'Chưa chọn ghế nào' : seats.join(', '),
              style: theme.textTheme.bodyMedium,
            ),
            AppSpacing.vSm,
            Text(
              '${seats.length} ghế, ${formatVnd(state.totalAmount)}',
              style: theme.textTheme.titleSmall,
            ),
            AppSpacing.vMd,
            const FilledButton(onPressed: null, child: Text('Tiếp tục')),
          ],
        ),
      ),
    );
  }
}
