import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/booking.dart';

class TicketQrView extends StatelessWidget {
  final Booking booking;

  const TicketQrView({super.key, required this.booking});

  static const double _qrSize = 220;

  @override
  Widget build(BuildContext context) {
    final ticket = booking.ticket;
    final usable =
        ticket != null &&
        (booking.status == BookingStatus.confirmed ||
            booking.status == BookingStatus.checkedIn);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Container(
            width: _qrSize + AppSpacing.md * 2,
            height: _qrSize + AppSpacing.md * 2,
            color: (!usable) ? Colors.transparent : Colors.white,
            child: (!usable)
                ? null
                : QrImageView(
                    data: jsonEncode({
                      'd': ticket.qrData,
                      's': ticket.qrSignature,
                    }),
                    version: QrVersions.auto,
                    size: _qrSize,
                  ),
          ),
        ),
      ),
    );
  }
}
