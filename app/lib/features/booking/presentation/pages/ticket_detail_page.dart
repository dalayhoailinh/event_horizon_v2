import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/format/formatters.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/breadcrumbs.dart';
import '../../../../core/widgets/skeleton_box.dart';
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
        PageSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!useAppShell()) ...[
                Row(
                  children: [
                    Expanded(
                      child: Breadcrumbs(
                        items: [
                          const Crumb('Vé của tôi', RouteNames.myTickets),
                          Crumb(booking?.eventTitle ?? 'Vé'),
                        ],
                      ),
                    ),
                    if (booking != null)
                      BookingStatusChip(status: booking.status),
                  ],
                ),
                AppSpacing.vMd,
              ],
              if (state.isLoading)
                const SkeletonBox(height: 360, radius: AppRadius.lg)
              else if (booking == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                  child: Center(child: Text('Không tìm thấy vé này.')),
                )
              else
                _TicketBody(
                  bookingId: bookingId,
                  booking: booking,
                  state: state,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TicketBody extends StatelessWidget {
  static const double _qrColumnWidth = 340;

  final String bookingId;
  final Booking booking;
  final TicketDetailState state;
  const _TicketBody({
    required this.bookingId,
    required this.booking,
    required this.state,
  });

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
        children: [qr, AppSpacing.vMd, info],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: _qrColumnWidth, child: qr),
        AppSpacing.hLg,
        Expanded(child: info),
      ],
    );
  }
}

/// "Thông tin vé": label/value rows, the copyable ticket id, cancel button.
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
    final scheme = theme.colorScheme;
    final canCancel = booking.canCancel(DateTime.now());
    final venue = [
      booking.venueName.trim(),
      booking.venueAddress.trim(),
    ].where((s) => s.isNotEmpty).join(', ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Thông tin vé',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.vMd,
            _Row(label: 'Mã vé', value: booking.id, copyable: true),
            _Row(label: 'Sự kiện', value: booking.eventTitle),
            _Row(
              label: 'Thời gian',
              value:
                  '${formatEventDate(booking.eventStartAt)} • '
                  '${formatTimeOfDay(booking.eventStartAt)}',
            ),
            if (venue.isNotEmpty) _Row(label: 'Địa điểm', value: venue),
            _Row(
              label: 'Vé',
              value: booking.lineItems
                  .map((item) => '${item.quantity}× ${item.name}')
                  .join('\n'),
            ),
            _Row(
              label: 'Tổng số tiền',
              value: formatVnd(booking.totalAmount),
              emphasize: true,
            ),
            _Row(
              label: 'Ngày đặt',
              value:
                  '${formatEventDate(booking.createdAt)} • '
                  '${formatTimeOfDay(booking.createdAt)}',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Trạng thái',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  BookingStatusChip(status: booking.status),
                ],
              ),
            ),
            if (state.errorMessage case final message?) ...[
              AppSpacing.vSm,
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.error,
                ),
              ),
            ],
            if (canCancel) ...[
              AppSpacing.vMd,
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                    side: BorderSide(color: scheme.error),
                  ),
                  onPressed: state.cancelling
                      ? null
                      : () => _confirmCancel(context, bookingId),
                  child: Text(state.cancelling ? 'Đang hủy…' : 'Hủy đặt vé'),
                ),
              ),
            ],
          ],
        ),
      ),
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
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hủy vé'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Giữ vé'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await cubit.cancel(bookingId);
    }
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;
  final bool emphasize;
  const _Row({
    required this.label,
    required this.value,
    this.copyable = false,
    this.emphasize = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              textAlign: TextAlign.right,
              style: emphasize
                  ? theme.textTheme.titleMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    )
                  : theme.textTheme.bodyMedium,
            ),
          ),
          if (copyable)
            IconButton(
              tooltip: 'Sao chép mã vé',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: value));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã sao chép mã vé')),
                );
              },
            ),
        ],
      ),
    );
  }
}
