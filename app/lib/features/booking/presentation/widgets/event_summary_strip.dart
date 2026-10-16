import 'package:flutter/material.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';

/// Thumbnail + title + "date • time | venue": reminds the buyer which event
/// they are buying for, on every step of the purchase.
class EventSummaryStrip extends StatelessWidget {
  static const double _thumbWidth = 120;
  static const double _thumbHeight = 68;

  final String title;
  final String coverImageUrl;
  final DateTime startAt;
  final String venue;

  const EventSummaryStrip({
    super.key,
    required this.title,
    required this.coverImageUrl,
    required this.startAt,
    required this.venue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final place = venue.trim();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.smd),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: SizedBox(
                width: _thumbWidth,
                height: _thumbHeight,
                child: AppNetworkImage(url: coverImageUrl),
              ),
            ),
            AppSpacing.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.vXs,
                  Text(
                    '${formatEventDate(startAt)} • ${formatTimeOfDay(startAt)}'
                    '${place.isEmpty ? '' : '  |  $place'}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
