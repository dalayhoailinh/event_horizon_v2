import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../blocs/my_tickets/my_tickets_cubit.dart';
import '../blocs/my_tickets/my_tickets_state.dart';
import '../routing/my_tickets_query.dart';
import '../widgets/booking_card.dart';

class MyTicketsPage extends StatelessWidget {
  final MyTicketsTab tab;
  const MyTicketsPage({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MyTicketsCubit>()..start(),
      child: _MyTicketsView(tab: tab),
    );
  }
}

class _MyTicketsView extends StatelessWidget {
  final MyTicketsTab tab;
  const _MyTicketsView({required this.tab});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyTicketsCubit>().state;
    return WebPage(
      title: 'Vé của tôi',
      actions: const [],
      sections: [
        PageSection(child: _TabBar(current: tab)),
        PageSection(
          child: _TabBody(tab: tab, state: state),
        ),
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  final MyTicketsTab current;
  const _TabBar({required this.current});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        for (final tab in MyTicketsTab.values)
          TextButton(
            onPressed: () => context.go(myTicketsLocationFor(tab)),
            style: TextButton.styleFrom(
              foregroundColor: tab == current
                  ? scheme.primary
                  : scheme.onSurfaceVariant,
            ),
            child: Text(
              tabLabel(tab),
              style: TextStyle(
                fontWeight: tab == current ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}

class _TabBody extends StatelessWidget {
  final MyTicketsTab tab;
  final MyTicketsState state;
  const _TabBody({required this.tab, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage case final message?) {
      return Center(child: Text(message));
    }

    final bookings = bookingsForTab(state.bookings, tab, DateTime.now());
    if (bookings.isEmpty) {
      return Center(child: Text(emptyLabelFor(tab)));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final booking in bookings)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: BookingCard(booking: booking),
          ),
      ],
    );
  }
}
