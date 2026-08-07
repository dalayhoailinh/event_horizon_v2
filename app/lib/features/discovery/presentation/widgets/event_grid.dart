import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_grid.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/event_summary.dart';
import 'event_card.dart';

class EventGrid extends StatelessWidget {
  final List<EventSummary> events;
  const EventGrid({super.key, required this.events});

  static const double _gap = AppSpacing.sm;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final colums = responsiveColumns(availableWidth: constraints.maxWidth);
        final cardWidth = (constraints.maxWidth - _gap * (colums - 1)) / colums;
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final event in events)
              EventCard(event: event, width: cardWidth),
          ],
        );
      },
    );
  }
}
