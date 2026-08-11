import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../domain/entities/event_detail.dart';
import '../blocs/event_detail/event_detail_cubit.dart';
import '../blocs/event_detail/event_detail_state.dart';
import '../widgets/detail_sections.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EventDetailCubit>()..load(eventId),
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
    return WebPage(
      title: state.detail?.summary.title ?? 'Sự kiện',
      actions: const [],
      sections: switch (state) {
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
          PageSection(child: _DetailBody(detail: detail)),
        ],
        _ => const [SizedBox.shrink()], // unreachable
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  final EventDetail detail;
  const _DetailBody({required this.detail});

  static const int _mainFlex = 3;
  static const int _sideFlex = 2;

  @override
  Widget build(BuildContext context) {
    final wide = context.windowSize.isExpanded;
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventHeroSection(detail: detail),
          AppSpacing.vMd,
          TicketTypesSection(ticketTypes: detail.ticketTypes),
          AppSpacing.vMd,
          DescriptionSection(detail: detail),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: _mainFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventHeroSection(detail: detail),
              AppSpacing.vLg,
              DescriptionSection(detail: detail),
            ],
          ),
        ),
        AppSpacing.hLg,
        Expanded(
          flex: _sideFlex,
          child: TicketTypesSection(ticketTypes: detail.ticketTypes),
        ),
      ],
    );
  }
}
