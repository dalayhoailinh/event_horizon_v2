import 'package:flutter/material.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/event_summary.dart';
import 'event_card.dart';

/// One horizontally scrolling row of cards. On wide windows it gets arrow
/// buttons: a mouse has no swipe, and shift+wheel is not something people
/// know (web rule: horizontal carousels need arrows).
class EventRow extends StatefulWidget {
  static const double cardWidth = 260;

  /// Narrower on phones so the next card peeks in — the hint that the row
  /// scrolls sideways.
  static const double cardWidthCompact = 220;
  static const int _skeletonCount = 5;

  final List<EventSummary> events;
  final bool loading;

  const EventRow({super.key, required this.events}) : loading = false;
  const EventRow.skeleton({super.key}) : events = const [], loading = true;

  @override
  State<EventRow> createState() => _EventRowState();
}

class _EventRowState extends State<EventRow> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scrollBy(double direction) {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    final target =
        (position.pixels + direction * position.viewportDimension * 0.8).clamp(
          position.minScrollExtent,
          position.maxScrollExtent,
        );
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = context.windowSize.isCompact
        ? EventRow.cardWidthCompact
        : EventRow.cardWidth;
    final cards = [
      if (widget.loading)
        for (var i = 0; i < EventRow._skeletonCount; i++)
          EventCardSkeleton(width: width)
      else
        for (final event in widget.events)
          EventCard(event: event, width: width),
    ];
    final row = SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      // Room for the card shadow, which would otherwise be clipped.
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) AppSpacing.hMd,
            cards[i],
          ],
        ],
      ),
    );

    if (context.windowSize.isCompact || widget.loading) return row;

    return Stack(
      children: [
        row,
        Positioned.fill(
          child: Row(
            children: [
              _RowArrow(icon: Icons.chevron_left, onTap: () => _scrollBy(-1)),
              const Spacer(),
              _RowArrow(icon: Icons.chevron_right, onTap: () => _scrollBy(1)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RowArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RowArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Material(
        color: scheme.surface,
        shape: CircleBorder(side: BorderSide(color: scheme.outlineVariant)),
        elevation: 2,
        child: IconButton(icon: Icon(icon), onPressed: onTap),
      ),
    );
  }
}
