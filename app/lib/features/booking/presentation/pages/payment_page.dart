import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/booking.dart';
import '../blocs/payment/payment_cubit.dart';
import '../blocs/payment/payment_state.dart';
import '../widgets/booking_status_chip.dart';

class PaymentPage extends StatelessWidget {
  final String bookingId;

  const PaymentPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PaymentCubit>()..start(bookingId),
      child: _PaymentView(),
    );
  }
}

class _PaymentView extends StatelessWidget {
  const _PaymentView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PaymentCubit>().state;
    final eventTitle = state.booking?.eventTitle;

    return WebPage(
      title: eventTitle == null ? 'Thanh toán' : 'Thanh toán - $eventTitle',
      actions: const [],
      sections: [
        PageSection(
          child: switch (state) {
            PaymentState(loading: true) => const Center(
              child: CircularProgressIndicator(),
            ),
            PaymentState(:final booking?) => _PaymentBody(
              booking: booking,
              state: state,
            ),
            _ => Text(state.errorMessage ?? 'Không tìm thấy đơn này.'),
          },
        ),
      ],
    );
  }
}

class _PaymentBody extends StatelessWidget {
  final Booking booking;
  final PaymentState state;

  const _PaymentBody({required this.booking, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(booking.eventTitle, style: theme.textTheme.titleLarge),
        AppSpacing.vSm,
        Align(
          alignment: Alignment.centerLeft,
          child: BookingStatusChip(status: booking.status),
        ),
        AppSpacing.vMd,
        Text(
          'Cần chuyển ${formatVnd(booking.totalAmount)}',
          style: theme.textTheme.titleMedium,
        ),
        AppSpacing.vMd,
        _QrArea(state: state),
        AppSpacing.vMd,
        Text(
          'Quét mã bằng app ngân hàng để chuyển khoản.',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _QrArea extends StatelessWidget {
  final PaymentState state;

  const _QrArea({required this.state});

  static const _qrSize = 240.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (state.errorMessage case final message?) {
      return Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }
    final qrCode = state.qrCode;
    if (qrCode == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        color: Colors.white,
        child: QrImageView(
          data: qrCode,
          version: QrVersions.auto,
          size: _qrSize,
        ),
      ),
    );
  }
}
