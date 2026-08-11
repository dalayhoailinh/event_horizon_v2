import 'package:flutter/material.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/event_detail.dart';

class EventHeroSection extends StatelessWidget {
  final EventDetail detail;
  final Widget? trailing;

  const EventHeroSection({super.key, required this.detail, this.trailing});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = detail.summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              summary.coverImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
        ),
        AppSpacing.vMd,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(summary.title, style: theme.textTheme.headlineSmall),
            ),
            ?trailing,
          ],
        ),
        AppSpacing.vSm,
        _IconLine(
          icon: Icons.schedule,
          text:
              '${formatEventTime(summary.startAt)}'
              ' → ${formatEventTime(detail.endAt)}',
        ),
        AppSpacing.vXs,
        _IconLine(
          icon: Icons.place_outlined,
          text: '${summary.venueName} · ${detail.venueAddress}',
        ),
        AppSpacing.vXs,
        _IconLine(icon: Icons.person_outline, text: detail.organizerName),
      ],
    );
  }
}

class _IconLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconLine({required this.icon, required this.text});

  static const double _iconSize = 18;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: _iconSize, color: theme.colorScheme.primary),
        AppSpacing.hSm,
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}

class TicketTypesSection extends StatelessWidget {
  final List<TicketTypeInfo> ticketTypes;
  const TicketTypesSection({super.key, required this.ticketTypes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Các loại vé', style: theme.textTheme.titleMedium),
            AppSpacing.vSm,
            for (final ticketType in ticketTypes)
              _TicketTypeRow(ticketType: ticketType),
            AppSpacing.vSm,
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: null,
                child: const Text('Đặt vé — mở ở GĐ3'),
              ),
            ),
          ],
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(ticketType.name, style: theme.textTheme.bodyLarge),
              ),
              Text(
                formatVnd(ticketType.price),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
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
    );
  }
}

class DescriptionSection extends StatelessWidget {
  final EventDetail detail;
  const DescriptionSection({super.key, required this.detail});

  static const double _galleryHeight = 120;
  static const double _galleryItemWidth = 200;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Giới thiệu', style: theme.textTheme.titleMedium),
        AppSpacing.vSm,
        Text(detail.descriptionPlain, style: theme.textTheme.bodyMedium),
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
                child: Image.network(
                  detail.galleryUrls[index],
                  width: _galleryItemWidth,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => SizedBox(
                    width: _galleryItemWidth,
                    child: ColoredBox(
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
