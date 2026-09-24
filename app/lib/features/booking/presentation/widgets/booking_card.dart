import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/booking.dart';
import 'booking_status_chip.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final String? tabQuery;

  const BookingCard({super.key, required this.booking, this.tabQuery});

  static const double _thumbSize = 72;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(
          booking.status == BookingStatus.pendingPayment
              ? RouteNames.paymentPath(booking.id)
              : RouteNames.ticketDetailPath(booking.id, tab: tabQuery),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              SizedBox(
                width: _thumbSize,
                height: _thumbSize,
                child: Image.network(
                  booking.eventCoverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => ColoredBox(
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
              AppSpacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.eventTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    Text(
                      formatEventTime(booking.eventStartAt),
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      '${booking.ticketCount} vé'
                      ' · ${formatVnd(booking.totalAmount)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppSpacing.hSm,
              BookingStatusChip(status: booking.status),
            ],
          ),
        ),
      ),
    );
  }
}
