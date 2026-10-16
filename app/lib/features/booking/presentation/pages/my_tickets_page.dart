import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_radius.dart';
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
  /// A ticket list reads better as one centred column than stretched wide.
  static const double _listMaxWidth = 860;

  final MyTicketsTab tab;
  const _MyTicketsView({required this.tab});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MyTicketsCubit>().state;
    return WebPage(
      title: 'Vé của tôi',
      actions: const [],
      sections: [
        PageSection(
          maxContentWidth: _listMaxWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _TabPills(current: tab)),
              AppSpacing.vLg,
              _TabBody(tab: tab, state: state),
            ],
          ),
        ),
      ],
    );
  }
}

/// Segmented pill bar; each tab is a URL (`?tab=past`), so F5 and the back
/// button keep the tab.
class _TabPills extends StatelessWidget {
  final MyTicketsTab current;
  const _TabPills({required this.current});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final tab in MyTicketsTab.values)
            Material(
              color: tab == current
                  ? scheme.primaryContainer
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.full),
                onTap: tab == current
                    ? null
                    : () => context.go(myTicketsLocationFor(tab)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    tabLabel(tab),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: tab == current
                          ? scheme.onPrimaryContainer
                          : scheme.onSurfaceVariant,
                      fontWeight: tab == current
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
      return const Column(
        children: [
          BookingCardSkeleton(),
          AppSpacing.vMd,
          BookingCardSkeleton(),
          AppSpacing.vMd,
          BookingCardSkeleton(),
        ],
      );
    }
    if (state.errorMessage case final message?) {
      return _Empty(icon: Icons.error_outline, text: message);
    }

    final bookings = bookingsForTab(state.bookings, tab, DateTime.now());
    if (bookings.isEmpty) {
      return _Empty(
        icon: Icons.confirmation_num_outlined,
        text: emptyLabelFor(tab),
        showExplore: tab == MyTicketsTab.upcoming,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final booking in bookings)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: BookingCard(booking: booking, tabQuery: tabQueryValue(tab)),
          ),
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool showExplore;
  const _Empty({
    required this.icon,
    required this.text,
    this.showExplore = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
          AppSpacing.vSm,
          Text(
            text,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (showExplore) ...[
            AppSpacing.vMd,
            FilledButton(
              onPressed: () => context.go(RouteNames.events),
              child: const Text('Khám phá sự kiện'),
            ),
          ],
        ],
      ),
    );
  }
}
