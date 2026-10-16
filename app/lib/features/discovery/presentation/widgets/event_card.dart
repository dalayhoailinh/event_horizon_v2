import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../domain/entities/event_summary.dart';

/// Vertical event card: cover on top (category badge over it), then title,
/// date, venue and price. Used by the home rows and every grid.
class EventCard extends StatefulWidget {
  /// Cover ratio (width : height). Fixed ratio instead of fixed height keeps
  /// the card proportional in a 2-column phone grid and a 4-column desktop.
  static const double imageAspectRatio = 16 / 10;

  final EventSummary event;
  final double? width;
  const EventCard({super.key, required this.event, this.width});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    return SizedBox(
      width: widget.width,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: _hovered ? AppShadows.md : AppShadows.sm,
          ),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.go(RouteNames.eventDetailPath(event.id)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Cover(event: event),
                  _Info(event: event),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final EventSummary event;
  const _Cover({required this.event});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: EventCard.imageAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(url: event.coverImageUrl),
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CategoryBadge(label: categoryLabel(event.categoryNames)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final EventSummary event;
  const _Info({required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
    );
    // Always reserve TWO title lines so every card in a row is the same
    // height, scaled with the device's text size.
    final twoLines = MediaQuery.textScalerOf(
      context,
    ).scale((titleStyle?.fontSize ?? 14) * (titleStyle?.height ?? 1.43) * 2);
    final venue = event.venueName.trim();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.smd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: twoLines,
            width: double.infinity,
            child: Text(
              event.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
          ),
          AppSpacing.vXs,
          InfoLine(
            icon: Icons.calendar_today_outlined,
            text: formatDayMonthTime(event.startAt),
          ),
          AppSpacing.vXs,
          InfoLine(
            icon: Icons.location_on_outlined,
            text: venue.isEmpty ? 'Đang cập nhật địa điểm' : venue,
          ),
          AppSpacing.vSm,
          Text(
            formatPriceRange(event.minPrice, event.maxPrice),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small icon + one line of secondary text (date, venue).
class InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.onSurfaceVariant;
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        AppSpacing.hXs,
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}

/// Category pill drawn over a cover image: dark translucent background so
/// white text stays readable on any photo.
class CategoryBadge extends StatelessWidget {
  final String label;
  const CategoryBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Same footprint as [EventCard], for loading states.
class EventCardSkeleton extends StatelessWidget {
  final double? width;
  const EventCardSkeleton({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            AspectRatio(
              aspectRatio: EventCard.imageAspectRatio,
              child: SkeletonBox(radius: 0),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.smd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(height: 16, width: double.infinity),
                  AppSpacing.vSm,
                  SkeletonBox(height: 12, width: 120),
                  AppSpacing.vSm,
                  SkeletonBox(height: 12, width: 160),
                  AppSpacing.vSmd,
                  SkeletonBox(height: 18, width: 90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
