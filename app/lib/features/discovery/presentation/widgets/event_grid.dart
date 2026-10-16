import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/event_summary.dart';
import 'event_card.dart';

/// Responsive grid of [EventCard]s: 2 columns on a phone, up to 4 on desktop.
class EventGrid extends StatelessWidget {
  static const double _gap = AppSpacing.md;
  static const double _targetCardWidth = 260;
  static const int _maxColumns = 4;

  final List<EventSummary> events;

  /// When > 0, draws this many skeleton cards instead of [events].
  final int skeletonCount;

  const EventGrid({super.key, required this.events}) : skeletonCount = 0;

  const EventGrid.skeleton({super.key, this.skeletonCount = 8})
    : events = const [];

  static int columnsFor(double width) =>
      (width / _targetCardWidth).floor().clamp(2, _maxColumns);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = columnsFor(constraints.maxWidth);
        final gap = constraints.maxWidth < 400 ? AppSpacing.sm : _gap;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            if (skeletonCount > 0)
              for (var i = 0; i < skeletonCount; i++)
                EventCardSkeleton(width: cardWidth)
            else
              for (final event in events)
                EventCard(event: event, width: cardWidth),
          ],
        );
      },
    );
  }
}
