import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/booking.dart';

class BookingStatusChip extends StatelessWidget {
  final BookingStatus status;
  const BookingStatusChip({super.key, required this.status});

  static const double _tintOpacity = 0.12;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      BookingStatus.confirmed => ('Đã xác nhận', AppColors.green500),
      BookingStatus.checkedIn => ('Đã check-in', AppColors.green500),
      BookingStatus.pendingPayment => ('Chờ thanh toán', AppColors.amber500),
      BookingStatus.refunding => ('Đang hoàn tiền', AppColors.amber500),
      BookingStatus.refunded => ('Đã hoàn tiền', AppColors.amber500),
      BookingStatus.cancelled => ('Đã hủy', AppColors.red500),
      BookingStatus.expired => ('Hết hạn', AppColors.red500),
      BookingStatus.unknown => ('Không rõ', AppColors.amber500),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: _tintOpacity),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
