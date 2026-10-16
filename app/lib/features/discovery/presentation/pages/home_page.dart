import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../../../core/widgets/section_header.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/event_filter.dart';
import '../../domain/entities/provinces.dart';
import '../blocs/home/home_cubit.dart';
import '../blocs/home/home_state.dart';
import '../routing/event_filter_query.dart';
import '../widgets/event_row.dart';
import '../widgets/hero_carousel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  /// How many featured events rotate in the banner.
  static const int _bannerCount = 5;

  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;
    void seeAll() => context.go(RouteNames.events);

    return WebPage(
      title: 'Trang chủ',
      actions: [
        if (kDebugMode)
          IconButton(
            tooltip: 'Debug',
            onPressed: () => context.push(RouteNames.debug),
            icon: const Icon(Icons.bug_report_outlined),
          ),
      ],
      sections: switch (state) {
        HomeState(:final failure?) => [
          PageSection(
            child: ErrorRetryView(
              failure: failure,
              onRetry: () => context.read<HomeCubit>().load(),
            ),
          ),
        ],
        // Loading keeps the final layout (skeletons), so nothing jumps when
        // the data arrives.
        HomeState(isLoading: true) => const [
          _TopSection(child: HeroCarousel.skeleton()),
          PageSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeader(title: 'Sự kiện phổ biến'),
                EventRow.skeleton(),
                AppSpacing.vXl,
                SectionHeader(title: 'Sự kiện sắp tới'),
                EventRow.skeleton(),
              ],
            ),
          ),
        ],
        _ => [
          _TopSection(
            child: HeroCarousel(
              events: state.featured.take(_bannerCount).toList(),
            ),
          ),
          PageSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.categories.isNotEmpty) ...[
                  _CategoryChips(categories: state.categories),
                  AppSpacing.vXl,
                ],
                if (state.featured.isNotEmpty) ...[
                  SectionHeader(title: 'Sự kiện phổ biến', onSeeAll: seeAll),
                  EventRow(events: state.featured),
                  AppSpacing.vXl,
                ],
                if (state.upcoming.isNotEmpty) ...[
                  SectionHeader(title: 'Sự kiện sắp tới', onSeeAll: seeAll),
                  EventRow(events: state.upcoming),
                  AppSpacing.vXl,
                ],
                const SectionHeader(title: 'Khám phá theo địa phương'),
                const _ProvinceTiles(),
                if (state.featured.isEmpty && state.upcoming.isEmpty) ...[
                  AppSpacing.vXl,
                  const _EmptyHome(),
                ],
              ],
            ),
          ),
        ],
      },
    );
  }
}

/// First section: a bit more top room, no bottom padding (the next section
/// brings its own).
class _TopSection extends StatelessWidget {
  final Widget child;
  const _TopSection({required this.child});

  @override
  Widget build(BuildContext context) {
    return PageSection(
      padding: EdgeInsets.fromLTRB(
        context.gutter,
        AppSpacing.lg,
        context.gutter,
        0,
      ),
      child: child,
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<EventCategory> categories;
  const _CategoryChips({required this.categories});

  @override
  Widget build(BuildContext context) {
    final chips = [
      for (final c in categories)
        ActionChip(
          label: Text(c.name),
          onPressed: () =>
              context.go(eventsLocationFor(EventFilter(categoryId: c.id))),
        ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: 'Thể loại'),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: chips,
        ),
      ],
    );
  }
}

class _ProvinceTiles extends StatelessWidget {
  const _ProvinceTiles();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.smd,
      runSpacing: AppSpacing.smd,
      children: [
        for (final p in kProvinces)
          OutlinedButton.icon(
            onPressed: () => context.go(
              eventsLocationFor(EventFilter(provinceCode: p.code)),
            ),
            icon: Icon(
              Icons.location_on_outlined,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            label: Text(p.name),
            style: OutlinedButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(
          Icons.event_busy_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        AppSpacing.vSm,
        Text(
          'Chưa có sự kiện nào đang mở bán.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
