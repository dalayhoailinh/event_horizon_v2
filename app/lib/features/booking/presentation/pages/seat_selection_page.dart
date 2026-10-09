import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/page_section.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../discovery/domain/entities/event_detail.dart';
import '../../domain/entities/seat_map.dart';
import '../blocs/seat_selection/seat_selection_cubit.dart';
import '../blocs/seat_selection/seat_selection_state.dart';
import '../widgets/seat_map_view.dart';

class SeatSelectionPage extends StatelessWidget {
  final String eventId;

  const SeatSelectionPage({super.key, required this.eventId});

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

  Color _colorOf(BuildContext context, SeatCell cell) {
    final scheme = Theme.of(context).colorScheme;
    final types = [
      for (final type in state.detail?.ticketTypes ?? const <TicketTypeInfo>[])
        type.id,
    ];
    return types.indexOf(cell.ticketTypeId ?? '') <= 0
        ? scheme.surfaceContainerHighest
        : scheme.tertiaryContainer;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final floor in state.floors) ...[
          Text(floor.name, style: theme.textTheme.titleMedium),
          AppSpacing.vSm,
          SeatMapView(floor: floor, colorOf: _colorOf),
          AppSpacing.vMd,
        ],
      ],
    );
  }
}
