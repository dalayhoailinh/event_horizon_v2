import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/breadcrumbs.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../domain/entities/event_detail.dart';
import '../blocs/event_detail/event_detail_cubit.dart';
import '../blocs/event_detail/event_detail_state.dart';
import '../blocs/favorite/favorite_cubit.dart';
import '../widgets/detail_sections.dart';
import '../widgets/favorite_button.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<EventDetailCubit>()..load(eventId),
        ),
        BlocProvider(
          create: (context) => getIt<FavoriteCubit>()..start(eventId),
        ),
      ],
      child: _EventDetailView(eventId: eventId),
    );
  }
}

class _EventDetailView extends StatelessWidget {
  final String eventId;
  const _EventDetailView({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventDetailCubit>().state;
    final title = state.detail?.summary.title ?? 'Sự kiện';
    return WebPage(
      title: title,
      actions: const [],
      sections: [
        PageSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The app shell has its own back arrow; breadcrumbs are the web
              // way of saying "you are here".
              if (!useAppShell()) ...[
                Breadcrumbs(
                  items: [
                    const Crumb('Khám phá', RouteNames.events),
                    Crumb(title),
                  ],
                ),
                AppSpacing.vMd,
              ],
              switch (state) {
                EventDetailState(:final failure?) => ErrorRetryView(
                  failure: failure,
                  onRetry: () => context.read<EventDetailCubit>().load(eventId),
                ),
                EventDetailState(:final detail?) => _DetailBody(detail: detail),
                // The cubit's "loading" is simply: no detail and no failure yet.
                _ => const EventDetailSkeleton(),
              },
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailBody extends StatelessWidget {
  static const double _sideWidth = 360;

  final EventDetail detail;
  const _DetailBody({required this.detail});

  @override
  Widget build(BuildContext context) {
    final hero = EventHero(
      detail: detail,
      trailing: const FavoriteButton(onImage: true),
    );
    final pricing = EventPricingCard(detail: detail);
    final meta = EventMetaCard(detail: detail);
    final about = AboutEventCard(detail: detail);

    if (!context.windowSize.isExpanded) {
      // Phone: price + button right under the photo — the main action must
      // not hide below a long description.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          hero,
          AppSpacing.vMd,
          pricing,
          AppSpacing.vMd,
          meta,
          AppSpacing.vMd,
          about,
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        hero,
        AppSpacing.vLg,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [meta, AppSpacing.vLg, about],
              ),
            ),
            AppSpacing.hLg,
            SizedBox(width: _sideWidth, child: pricing),
          ],
        ),
      ],
    );
  }
}
