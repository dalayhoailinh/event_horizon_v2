import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/provinces.dart';
import '../blocs/home/home_cubit.dart';
import '../blocs/home/home_state.dart';
import '../widgets/event_card.dart';

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
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('EventHorizon'),
        actions: [
          if (kDebugMode)
            IconButton(
              tooltip: 'Debug',
              onPressed: () => context.push(RouteNames.debug),
              icon: const Icon(Icons.bug_report_outlined),
            ),
          IconButton(
            tooltip: 'Đăng xuất',
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthLogoutRequested()),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: switch (state) {
        HomeState(isLoading: true) => const Center(
          child: CircularProgressIndicator(),
        ),
        HomeState(:final failure?) => ErrorRetryView(
          failure: failure,
          onRetry: () => context.read<HomeCubit>().load(),
        ),
        _ => RefreshIndicator(
          onRefresh: () => context.read<HomeCubit>().load(),
          child: ListView(
            children: [
              PageSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _FakeSearchBar(),
                    const SizedBox(height: AppSpacing.md),
                    _CategoryChips(categories: state.categories),
                    const SizedBox(height: AppSpacing.md),
                    _SectionHeader(
                      title: 'Nổi bật',
                      onSeeAll: () => context.push(RouteNames.events),
                    ),
                    SizedBox(
                      height: 270,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.featured.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (context, index) =>
                            EventCard(event: state.featured[index], width: 280),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _ProvinceChips(),
                    const SizedBox(height: AppSpacing.md),
                    _SectionHeader(
                      title: 'Sắp diễn ra',
                      onSeeAll: () => context.push(RouteNames.events),
                    ),
                    for (final event in state.upcoming) EventCard(event: event),
                  ],
                ),
              ),
            ],
          ),
        ),
      },
    );
  }
}

/// Looks like a search field; actually a shortcut into the list page.
class _FakeSearchBar extends StatelessWidget {
  const _FakeSearchBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () => context.push(RouteNames.events),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Tìm sự kiện...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final List<EventCategory> categories;
  const _CategoryChips({required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final c = categories[index];
          return ActionChip(
            label: Text(c.name),
            // Deep-link filter via URL -> shareable on web
            onPressed: () =>
                context.push('${RouteNames.events}?category=${c.id}'),
          );
        },
      ),
    );
  }
}

class _ProvinceChips extends StatelessWidget {
  const _ProvinceChips();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Theo địa phương', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kProvinces.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final p = kProvinces[index];
              return ActionChip(
                label: Text(p.name),
                onPressed: () =>
                    context.push('${RouteNames.events}?province=${p.code}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        TextButton(onPressed: onSeeAll, child: const Text('Xem tất cả')),
      ],
    );
  }
}
