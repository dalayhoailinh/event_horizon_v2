import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/booking.dart';
import '../blocs/ticket_detail/ticket_detail_cubit.dart';
import '../blocs/ticket_detail/ticket_detail_state.dart';
import '../widgets/booking_status_chip.dart';
import '../widgets/ticket_qr_view.dart';

class TicketDetailPage extends StatelessWidget {
  final String bookingId;
  const TicketDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TicketDetailCubit>()..start(bookingId),
      child: _TicketDetailView(bookingId: bookingId),
    );
  }
}

class _TicketDetailView extends StatelessWidget {
  final String bookingId;
  const _TicketDetailView({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TicketDetailCubit>().state;
    final booking = state.booking;

    return WebPage(
      title: booking == null ? 'Vé' : 'Vé — ${booking.eventTitle}',
      actions: const [],
      sections: [
        if (state.isLoading)
          const PageSection(child: Center(child: CircularProgressIndicator()))
        else if (booking == null)
          const PageSection(
            child: Center(child: Text('Không tìm thấy vé này.')),
          )
        else ...[
          PageSection(child: _Breadcrumb(booking: booking)),
          PageSection(
            child: _TicketBody(
              bookingId: bookingId,
              booking: booking,
              state: state,
            ),
          ),
        ],
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final Booking booking;
  const _Breadcrumb({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TextButton(
          onPressed: () => context.go(RouteNames.myTickets),
          child: const Text('Vé của tôi'),
        ),
        const Text('/'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            booking.eventTitle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}

class _TicketBody extends StatelessWidget {
  final String bookingId;
  final Booking booking;
  final TicketDetailState state;
  const _TicketBody({
    required this.bookingId,
    required this.booking,
    required this.state,
  });

  static const int _qrFlex = 2;
  static const int _infoFlex = 3;

  @override
  Widget build(BuildContext context) {
    final qr = TicketQrView(booking: booking);
    final info = _TicketInfo(
      bookingId: bookingId,
      booking: booking,
      state: state,
    );

    if (!context.windowSize.isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [qr, AppSpacing.vLg, info],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: _qrFlex, child: qr),
        AppSpacing.hLg,
        Expanded(flex: _infoFlex, child: info),
      ],
    );
  }
}

class _TicketInfo extends StatelessWidget {
  final String bookingId;
  final Booking booking;
  final TicketDetailState state;
  const _TicketInfo({
    required this.bookingId,
    required this.booking,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canCancel = booking.canCancel(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                booking.eventTitle,
                style: theme.textTheme.headlineSmall,
              ),
            ),
            BookingStatusChip(status: booking.status),
          ],
        ),
        AppSpacing.vSm,
        Text(formatEventTime(booking.eventStartAt)),
        Text('${booking.venueName} · ${booking.venueAddress}'),
        AppSpacing.vMd,
        for (final item in booking.lineItems)
          Text('${item.name} × ${item.quantity} · ${formatVnd(item.price)}'),
        const Divider(),
        Text(
          'Tổng: ${formatVnd(booking.totalAmount)}',
          style: theme.textTheme.titleSmall,
        ),
        AppSpacing.vLg,
        if (state.errorMessage case final message?) ...[
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          AppSpacing.vSm,
        ],
        if (canCancel)
          OutlinedButton(
            onPressed: state.cancelling
                ? null
                : () => _confirmCancel(context, bookingId),
            child: Text(state.cancelling ? 'Đang hủy…' : 'Hủy vé'),
          ),
      ],
    );
  }

  Future<void> _confirmCancel(BuildContext context, String bookingId) async {
    final cubit = context.read<TicketDetailCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hủy vé này?'),
        content: const Text(
          'Vé sẽ được trả lại kho và bạn không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Giữ vé'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hủy vé'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await cubit.cancel(bookingId);
    }
  }
}
