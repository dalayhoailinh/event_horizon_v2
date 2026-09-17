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
import '../../../../core/widgets/error_retry_view.dart';
import '../../../discovery/domain/entities/event_detail.dart';
import '../../../discovery/presentation/blocs/event_detail/event_detail_cubit.dart';
import '../../../discovery/presentation/blocs/event_detail/event_detail_state.dart';
import '../blocs/booking_create/booking_create_cubit.dart';
import '../blocs/booking_create/booking_create_state.dart';
import '../widgets/ticket_quantity_row.dart';

class BookingPage extends StatelessWidget {
  final String eventId;
  const BookingPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventDetailCubit>(
          create: (_) => getIt<EventDetailCubit>()..load(eventId),
        ),
        BlocProvider<BookingCreateCubit>(
          create: (_) => getIt<BookingCreateCubit>(),
        ),
      ],
      child: _BookingView(eventId: eventId),
    );
  }
}

class _BookingView extends StatelessWidget {
  final String eventId;

  const _BookingView({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final detailState = context.watch<EventDetailCubit>().state;
    final title = detailState.detail?.summary.title;

    return BlocListener<BookingCreateCubit, BookingCreateState>(
      listenWhen: (previous, current) =>
          previous.bookingId == null && current.bookingId != null,
      listener: (context, state) => context.go(
        state.paymentRequired
            ? RouteNames.paymentPath(state.bookingId!)
            : RouteNames.ticketDetailPath(state.bookingId!),
      ),
      child: WebPage(
        title: title == null ? 'Đặt vé' : 'Đặt vé - $title',
        actions: const [],
        sections: switch (detailState) {
          EventDetailState(isLoading: true) => const [
            PageSection(child: Center(child: CircularProgressIndicator())),
          ],
          EventDetailState(:final failure?) => [
            PageSection(
              child: ErrorRetryView(
                failure: failure,
                onRetry: () => context.read<EventDetailCubit>().load(eventId),
              ),
            ),
          ],
          EventDetailState(:final detail?) => [
            PageSection(
              child: _BookingBody(eventId: eventId, detail: detail),
            ),
          ],
          _ => const [SizedBox.shrink()],
        },
      ),
    );
  }
}

class _BookingBody extends StatelessWidget {
  final String eventId;
  final EventDetail detail;
  const _BookingBody({required this.eventId, required this.detail});

  static const int _listFlex = 3;
  static const int _summaryFlex = 2;

  @override
  Widget build(BuildContext context) {
    final list = _TicketTypeList(detail: detail);
    final summary = _OrderSummary(eventId: eventId, detail: detail);

    if (!context.windowSize.isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Breadcrumb(detail: detail),
          list,
          AppSpacing.vLg,
          summary,
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Breadcrumb(detail: detail),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: _listFlex, child: list),
            AppSpacing.hLg,
            Expanded(flex: _summaryFlex, child: summary),
          ],
        ),
      ],
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final String eventId;
  final EventDetail detail;
  const _OrderSummary({required this.eventId, required this.detail});

  int _total(Map<String, int> quantities) {
    var total = 0;
    for (final type in detail.ticketTypes) {
      total += type.price * (quantities[type.id] ?? 0);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<BookingCreateCubit>().state;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Đơn của bạn', style: theme.textTheme.titleMedium),
            AppSpacing.vSm,
            for (final type in detail.ticketTypes)
              if ((state.quantities[type.id] ?? 0) > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${type.name} × ${state.quantities[type.id]}',
                        ),
                      ),
                      Text(formatVnd(type.price * state.quantities[type.id]!)),
                    ],
                  ),
                ),
            if (state.totalTickets == 0)
              Text('Chưa chọn vé nào.', style: theme.textTheme.bodySmall),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text('Tổng', style: theme.textTheme.titleSmall),
                ),
                Text(
                  formatVnd(_total(state.quantities)),
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
            AppSpacing.vMd,
            // Lỗi hiện NGAY CẠNH nút gây ra nó, không phải snackbar trôi ở đáy.
            if (state.errorMessage case final message?) ...[
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              AppSpacing.vSm,
            ],
            FilledButton(
              onPressed: state.canSubmit
                  ? () => context.read<BookingCreateCubit>().submit(eventId)
                  : null,
              child: Text(
                state.submitting ? 'Đang đặt…' : 'Đặt ${state.totalTickets} vé',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketTypeList extends StatelessWidget {
  final EventDetail detail;
  const _TicketTypeList({required this.detail});

  @override
  Widget build(BuildContext context) {
    final quantities = context.watch<BookingCreateCubit>().state.quantities;
    final sellable = [
      for (final type in detail.ticketTypes)
        if (type.isActive) type,
    ];

    if (sellable.isEmpty) {
      return const Text('Sự kiện này chưa mở bán vé.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final type in sellable)
          TicketQuantityRow(
            ticketType: type,
            quantity: quantities[type.id] ?? 0,
            onChanged: (value) =>
                context.read<BookingCreateCubit>().setQuantity(type.id, value),
          ),
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final EventDetail detail;
  const _Breadcrumb({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          TextButton(
            onPressed: () => context.go(RouteNames.events),
            child: const Text('Khám phá'),
          ),
          const Text('/'),
          TextButton(
            onPressed: () =>
                context.go(RouteNames.eventDetailPath(detail.summary.id)),
            child: Text(detail.summary.title),
          ),
          const Text('/'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Text('Đặt vé', style: theme.textTheme.labelLarge),
          ),
        ],
      ),
    );
  }
}
