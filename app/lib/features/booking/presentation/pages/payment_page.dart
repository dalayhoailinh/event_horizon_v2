import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../domain/entities/booking.dart';
import '../blocs/payment/payment_cubit.dart';
import '../blocs/payment/payment_state.dart';
import '../widgets/booking_status_chip.dart';
import '../widgets/event_summary_strip.dart';
import '../widgets/payment_countdown.dart';

class PaymentPage extends StatelessWidget {
  final String bookingId;

  const PaymentPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentCubit>()..start(bookingId),
      child: const _PaymentView(),
    );
  }
}

class _PaymentView extends StatelessWidget {
  const _PaymentView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PaymentCubit>().state;
    final eventTitle = state.booking?.eventTitle;

    return BlocListener<PaymentCubit, PaymentState>(
      // Money arrived (webhook flipped the booking): go to the ticket.
      listenWhen: (previous, current) =>
          previous.booking?.status != BookingStatus.confirmed &&
          current.booking?.status == BookingStatus.confirmed,
      listener: (context, state) {
        final booking = state.booking;
        if (booking != null) {
          context.go(RouteNames.ticketDetailPath(booking.id));
        }
      },
      child: WebPage(
        title: eventTitle == null ? 'Thanh toán' : 'Thanh toán - $eventTitle',
        actions: const [],
        sections: [
          PageSection(
            child: switch (state) {
              PaymentState(loading: true) => const _PaymentSkeleton(),
              PaymentState(booking: final booking?) when !booking.isActive =>
                _PaymentClosed(booking: booking),
              PaymentState(:final booking?) => _PaymentBody(
                booking: booking,
                state: state,
              ),
              _ => _Message(
                icon: Icons.receipt_long_outlined,
                text: state.errorMessage ?? 'Không tìm thấy đơn này.',
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentBody extends StatelessWidget {
  static const double _sideWidth = 380;

  final Booking booking;
  final PaymentState state;

  const _PaymentBody({required this.booking, required this.state});

  @override
  Widget build(BuildContext context) {
    final qr = _QrCard(booking: booking, state: state);
    final order = _OrderCard(booking: booking, state: state);
    if (!context.windowSize.isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [qr, AppSpacing.vMd, order],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: qr),
        AppSpacing.hLg,
        SizedBox(width: _sideWidth, child: order),
      ],
    );
  }
}

/// Left: the QR to scan, the countdown and how-to steps.
class _QrCard extends StatelessWidget {
  static const double _qrSize = 240;

  final Booking booking;
  final PaymentState state;
  const _QrCard({required this.booking, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final qrCode = state.qrCode;

    final Widget qrArea;
    if (state.errorMessage case final message?) {
      qrArea = _Message(icon: Icons.qr_code_2, text: message, error: true);
    } else if (qrCode == null) {
      qrArea = const SkeletonBox(
        width: _qrSize + AppSpacing.xl,
        height: _qrSize + AppSpacing.xl,
        radius: AppRadius.md,
      );
    } else {
      qrArea = Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: QrImageView(
          data: qrCode,
          version: QrVersions.auto,
          size: _qrSize,
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              'Quét mã để thanh toán',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.vXs,
            Text(
              'Cần chuyển ${formatVnd(booking.totalAmount)}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: scheme.primary,
              ),
            ),
            AppSpacing.vLg,
            qrArea,
            if (booking.expiresAt case final deadline?) ...[
              AppSpacing.vMd,
              PaymentCountdown(deadline: deadline),
            ],
            AppSpacing.vLg,
            const _Steps(),
          ],
        ),
      ),
    );
  }
}

class _Steps extends StatelessWidget {
  static const _steps = [
    'Mở app ngân hàng, chọn quét mã QR.',
    'Quét mã ở trên — số tiền và nội dung đã điền sẵn.',
    'Xác nhận chuyển khoản. Trang này tự chuyển sang vé khi tiền về.',
  ];

  const _Steps();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: scheme.primaryContainer,
                  child: Text(
                    '${i + 1}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppSpacing.hSm,
                Expanded(
                  child: Text(_steps[i], style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Right: what is being paid for + the cancel escape hatch.
class _OrderCard extends StatelessWidget {
  final Booking booking;
  final PaymentState state;
  const _OrderCard({required this.booking, required this.state});

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = context.read<PaymentCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hủy đơn này?'),
        content: const Text(
          'Vé và ghế đang giữ sẽ được trả lại cho sự kiện. '
          'Bạn không thể khôi phục đơn sau khi hủy.',
        ),
        actions: [
          // true = "yes, cancel it". The safe choice (keep) is the filled,
          // default-looking button.
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hủy đơn'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Giữ đơn'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await cubit.cancel(booking.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EventSummaryStrip(
          title: booking.eventTitle,
          coverImageUrl: booking.eventCoverUrl,
          startAt: booking.eventStartAt,
          venue: booking.venueName,
        ),
        AppSpacing.vMd,
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Thông tin đơn hàng',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    BookingStatusChip(status: booking.status),
                  ],
                ),
                AppSpacing.vMd,
                for (final item in booking.lineItems)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}× ${item.name}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        Text(formatVnd(item.price * item.quantity)),
                      ],
                    ),
                  ),
                const Divider(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tổng số tiền',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      formatVnd(booking.totalAmount),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                AppSpacing.vSm,
                SelectableText(
                  'Mã đơn: ${booking.id}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (state.cancelError case final message?) ...[
                  AppSpacing.vMd,
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.error,
                    ),
                  ),
                ],
                AppSpacing.vMd,
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                  ),
                  onPressed: state.cancelling
                      ? null
                      : () => _confirmCancel(context),
                  child: Text(state.cancelling ? 'Đang hủy…' : 'Hủy đơn'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentClosed extends StatelessWidget {
  final Booking booking;

  const _PaymentClosed({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expired = booking.status == BookingStatus.expired;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Icon(
                  expired ? Icons.timer_off_outlined : Icons.cancel_outlined,
                  size: 56,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.vMd,
                Text(
                  expired ? 'Đơn đã hết hạn' : 'Đơn đã bị hủy',
                  style: theme.textTheme.titleLarge,
                ),
                AppSpacing.vSm,
                Text(
                  'Vé và ghế của đơn "${booking.eventTitle}" đã được trả '
                  'lại cho sự kiện. Bạn có thể đặt lại nếu còn vé.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.vLg,
                FilledButton(
                  onPressed: () =>
                      context.go(RouteNames.eventDetailPath(booking.eventId)),
                  child: const Text('Về trang sự kiện'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool error;
  const _Message({required this.icon, required this.text, this.error = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = error
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: color),
          AppSpacing.vSm,
          Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _PaymentSkeleton extends StatelessWidget {
  const _PaymentSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(height: 480, radius: AppRadius.lg);
  }
}
