import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/booking.dart';

/// The ticket QR, shown only while the ticket is usable. Otherwise a short
/// explanation takes its place — never an empty white square.
class TicketQrView extends StatelessWidget {
  final Booking booking;

  const TicketQrView({super.key, required this.booking});

  static const double _qrSize = 220;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final ticket = booking.ticket;
    final usable =
        ticket != null &&
        (booking.status == BookingStatus.confirmed ||
            booking.status == BookingStatus.checkedIn);

    final String caption;
    if (usable) {
      caption = booking.status == BookingStatus.checkedIn
          ? 'Vé đã được soát lúc vào cửa.'
          : 'Đưa mã này cho nhân viên soát vé ở cửa.';
    } else {
      caption = switch (booking.status) {
        BookingStatus.pendingPayment =>
          'Mã vé sẽ hiện sau khi bạn thanh toán xong.',
        BookingStatus.cancelled => 'Vé đã bị hủy, mã không còn hiệu lực.',
        BookingStatus.expired => 'Đơn đã hết hạn, không có mã vé.',
        _ => 'Mã vé chưa sẵn sàng.',
      };
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              'Mã vé',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.vMd,
            Container(
              width: _qrSize + AppSpacing.md * 2,
              height: _qrSize + AppSpacing.md * 2,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: usable ? Colors.white : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: usable
                  ? QrImageView(
                      data: jsonEncode({
                        'd': ticket.qrData,
                        's': ticket.qrSignature,
                      }),
                      version: QrVersions.auto,
                      size: _qrSize,
                    )
                  : Icon(
                      Icons.qr_code_2,
                      size: 96,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
            ),
            AppSpacing.vMd,
            Text(
              caption,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
