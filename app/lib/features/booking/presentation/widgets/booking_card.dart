import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../discovery/presentation/widgets/event_card.dart';
import '../../domain/entities/booking.dart';
import 'booking_status_chip.dart';

/// One booking in "Vé của tôi": cover, event, what was bought, status, price.
/// A pending booking opens the payment page; anything else the ticket.
class BookingCard extends StatelessWidget {
  final Booking booking;
  final String? tabQuery;

  const BookingCard({super.key, required this.booking, this.tabQuery});

  static const double _thumbWidth = 160;
  static const double _thumbWidthCompact = 96;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final compact = context.windowSize.isCompact;
    final pending = booking.status == BookingStatus.pendingPayment;
    final items = booking.lineItems
        .map((item) => '${item.quantity}× ${item.name}')
        .join(', ');
    final venue = booking.venueName.trim();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go(
          pending
              ? RouteNames.paymentPath(booking.id)
              : RouteNames.ticketDetailPath(booking.id, tab: tabQuery),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.smd),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: SizedBox(
                    width: compact ? _thumbWidthCompact : _thumbWidth,
                    child: AspectRatio(
                      aspectRatio: compact ? 1 : 16 / 11,
                      child: AppNetworkImage(url: booking.eventCoverUrl),
                    ),
                  ),
                ),
                AppSpacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              booking.eventTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!compact && booking.totalAmount > 0) ...[
                            AppSpacing.hMd,
                            Text(
                              formatVnd(booking.totalAmount),
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                      AppSpacing.vXs,
                      InfoLine(
                        icon: Icons.calendar_today_outlined,
                        text:
                            '${formatEventDate(booking.eventStartAt)} • '
                            '${formatTimeOfDay(booking.eventStartAt)}',
                      ),
                      if (venue.isNotEmpty) ...[
                        AppSpacing.vXs,
                        InfoLine(icon: Icons.location_on_outlined, text: venue),
                      ],
                      if (items.isNotEmpty) ...[
                        AppSpacing.vXs,
                        InfoLine(
                          icon: Icons.confirmation_num_outlined,
                          text: items,
                        ),
                      ],
                      const Spacer(),
                      AppSpacing.vSm,
                      Row(
                        children: [
                          BookingStatusChip(status: booking.status),
                          const Spacer(),
                          Text(
                            pending ? 'Thanh toán ›' : 'Xem chi tiết ›',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Same footprint as [BookingCard] while the list loads.
class BookingCardSkeleton extends StatelessWidget {
  const BookingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(height: 136, radius: AppRadius.lg);
  }
}
