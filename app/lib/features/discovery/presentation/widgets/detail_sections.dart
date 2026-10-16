import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../domain/entities/event_detail.dart';
import 'event_card.dart';

/// Cover photo with category, title and date written over its darkened
/// lower half; [trailing] (the heart) sits in the top-right corner.
class EventHero extends StatelessWidget {
  final EventDetail detail;
  final Widget? trailing;
  const EventHero({super.key, required this.detail, this.trailing});

  static double heightFor(WindowSize size) => switch (size) {
    WindowSize.compact => 220,
    WindowSize.medium => 300,
    WindowSize.expanded => 360,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = context.windowSize;
    final summary = detail.summary;
    final venue = summary.venueName.trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: heightFor(size),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: summary.coverImageUrl),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x1F000000), Color(0xB3000000)],
                ),
              ),
            ),
            if (trailing != null)
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: trailing!,
              ),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryBadge(label: categoryLabel(summary.categoryNames)),
                  AppSpacing.vSm,
                  Text(
                    summary.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        (size.isCompact
                                ? theme.textTheme.headlineSmall
                                : theme.textTheme.headlineMedium)
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                  AppSpacing.vXs,
                  Text(
                    '${formatEventDate(summary.startAt)} • '
                    '${formatTimeOfDay(summary.startAt)}'
                    '${venue.isEmpty ? '' : '  |  $venue'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// White card with a title, the shared look of every block on the page.
class DetailCard extends StatelessWidget {
  final String? title;
  final Widget child;
  const DetailCard({super.key, this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.vMd,
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// "Thời gian & địa điểm" + organizer.
class EventMetaCard extends StatelessWidget {
  final EventDetail detail;
  const EventMetaCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = detail.summary;
    final venue = summary.venueName.trim();
    final address = detail.venueAddress.trim();
    final organizer = detail.organizerName.trim();

    return DetailCard(
      title: 'Thời gian & địa điểm',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MetaLine(
            icon: Icons.calendar_today_outlined,
            title: 'Thời gian',
            lines: [
              '${formatEventDate(summary.startAt)}, '
                  '${formatTimeOfDay(summary.startAt)} – '
                  '${_endText(summary.startAt, detail.endAt)}',
            ],
          ),
          AppSpacing.vMd,
          _MetaLine(
            icon: Icons.location_on_outlined,
            title: 'Địa điểm',
            lines: [
              if (venue.isNotEmpty) venue,
              if (address.isNotEmpty) address,
              if (venue.isEmpty && address.isEmpty) 'Đang cập nhật địa điểm',
            ],
          ),
          const Divider(height: AppSpacing.xl),
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  organizer.isEmpty
                      ? 'EH'
                      : organizer.characters.first.toUpperCase(),
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              AppSpacing.hSmd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nhà tổ chức',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      organizer.isEmpty ? 'Ban tổ chức' : organizer,
                      style: theme.textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Same day -> just the hour; otherwise the full end date.
  static String _endText(DateTime start, DateTime end) {
    final sameDay =
        start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;
    return sameDay
        ? formatTimeOfDay(end)
        : '${formatEventDate(end)}, ${formatTimeOfDay(end)}';
  }
}

class _MetaLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> lines;
  const _MetaLine({
    required this.icon,
    required this.title,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: 18, color: scheme.primary),
        ),
        AppSpacing.hSmd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              for (final line in lines)
                SelectableText(
                  line,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// "Về sự kiện": description + gallery.
class AboutEventCard extends StatelessWidget {
  static const double _galleryHeight = 120;
  static const double _galleryItemWidth = 200;

  final EventDetail detail;
  const AboutEventCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = detail.descriptionPlain.trim();
    return DetailCard(
      title: 'Về sự kiện',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            description.isEmpty
                ? 'Nội dung sự kiện đang được ban tổ chức cập nhật.'
                : description,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
          ),
          if (detail.galleryUrls.isNotEmpty) ...[
            AppSpacing.vMd,
            SizedBox(
              height: _galleryHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: detail.galleryUrls.length,
                separatorBuilder: (context, index) => AppSpacing.hSm,
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: SizedBox(
                    width: _galleryItemWidth,
                    child: AppNetworkImage(url: detail.galleryUrls[index]),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// "Giá vé — Chỉ từ 100.000đ", ticket types, and the one button that matters
/// on this page.
class EventPricingCard extends StatelessWidget {
  final EventDetail detail;
  const EventPricingCard({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final summary = detail.summary;
    final active = [
      for (final t in detail.ticketTypes)
        if (t.isActive) t,
    ];
    final remaining = active.fold<int>(
      0,
      (sum, t) => sum + (t.remaining > 0 ? t.remaining : 0),
    );
    final hasStarted = !summary.startAt.isAfter(DateTime.now());
    final canBook = active.isNotEmpty && remaining > 0 && !hasStarted;

    final String status;
    if (hasStarted) {
      status = 'Sự kiện đã diễn ra';
    } else if (active.isEmpty) {
      status = 'Chưa mở bán vé';
    } else if (remaining <= 0) {
      status = 'Đã hết vé';
    } else {
      status = 'Còn lại $remaining vé';
    }

    return DetailCard(
      title: 'Giá vé',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chỉ từ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          Text(
            active.isEmpty ? 'Đang cập nhật' : formatVnd(summary.minPrice),
            style: theme.textTheme.displaySmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              status,
              style: theme.textTheme.labelLarge?.copyWith(
                color: canBook
                    ? context.statusColors.success
                    : scheme.onSurfaceVariant,
              ),
            ),
          ),
          if (active.length > 1 || (active.length == 1 && canBook)) ...[
            const Divider(height: AppSpacing.lg),
            for (final t in active) _TicketTypeRow(ticketType: t),
          ],
          AppSpacing.vMd,
          FilledButton(
            onPressed: canBook
                ? () => context.go(
                    summary.hasSeatMap
                        ? RouteNames.seatsPath(summary.id)
                        : RouteNames.bookPath(summary.id),
                  )
                : null,
            child: Text(switch ((hasStarted, summary.hasSeatMap)) {
              (true, _) => 'Sự kiện đã diễn ra',
              (_, true) => 'Chọn ghế',
              (_, false) => 'Đặt vé ngay',
            }),
          ),
        ],
      ),
    );
  }
}

class _TicketTypeRow extends StatelessWidget {
  final TicketTypeInfo ticketType;
  const _TicketTypeRow({required this.ticketType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soldOut = ticketType.remaining <= 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticketType.name, style: theme.textTheme.bodyLarge),
                Text(
                  soldOut ? 'Hết vé' : 'Còn ${ticketType.remaining} vé',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: soldOut
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatVnd(ticketType.price),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton of the whole page body while the event loads.
class EventDetailSkeleton extends StatelessWidget {
  const EventDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.windowSize;
    final side = Column(
      children: const [SkeletonBox(height: 220, radius: AppRadius.lg)],
    );
    final main = Column(
      children: const [
        SkeletonBox(height: 200, radius: AppRadius.lg),
        AppSpacing.vLg,
        SkeletonBox(height: 160, radius: AppRadius.lg),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SkeletonBox(height: EventHero.heightFor(size), radius: AppRadius.lg),
        AppSpacing.vLg,
        if (size.isExpanded)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: main),
              AppSpacing.hLg,
              SizedBox(width: 360, child: side),
            ],
          )
        else ...[
          side,
          AppSpacing.vLg,
          main,
        ],
      ],
    );
  }
}
