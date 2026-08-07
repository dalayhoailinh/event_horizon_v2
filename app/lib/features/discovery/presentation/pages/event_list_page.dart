import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../domain/entities/event_filter.dart';
import '../blocs/discovery_list/discovery_list_cubit.dart';
import '../blocs/discovery_list/discovery_list_state.dart';
import '../widgets/event_filter_bar.dart';
import '../widgets/event_grid.dart';

class EventListPage extends StatelessWidget {
  final EventFilter initialFilter;

  const EventListPage({super.key, required this.initialFilter});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DiscoveryListCubit>()..load(filter: initialFilter),
      child: const _EventListView(),
    );
  }
}

class _EventListView extends StatefulWidget {
  const _EventListView();

  @override
  State<_EventListView> createState() => __EventListViewState();
}

class __EventListViewState extends State<_EventListView> {
  static const _searchDebounce = Duration(milliseconds: 300);
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(_searchDebounce, () {
      if (!mounted) return;
      context.read<DiscoveryListCubit>().search(query);
    });
  }

  void _onSubmitted(String query) {
    _debounce?.cancel();
    context.read<DiscoveryListCubit>().search(query);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DiscoveryListCubit>().state;
    return WebPage(
      title: 'Khám phá',
      actions: const [],
      sections: [
        PageSection(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchField(
                onChanged: _onQueryChanged,
                onSubmitted: _onSubmitted,
              ),
              AppSpacing.vMd,
              const EventFilterBar(),
            ],
          ),
        ),
        PageSection(child: _Result(state: state)),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  const _SearchField({required this.onChanged, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: 'Tìm sự kiện',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class _Result extends StatelessWidget {
  final DiscoveryListState state;

  const _Result({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final failure = state.failure;
    if (failure != null && state.events.isEmpty) {
      return ErrorRetryView(
        failure: failure,
        onRetry: () => context.read<DiscoveryListCubit>().load(),
      );
    }

    if (state.events.isEmpty) {
      return const Center(child: Text('Không có sự kiện nào'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EventGrid(events: state.events),
        if (state.hasMore) ...[
          AppSpacing.vLg,
          Center(
            child: _LoadMoreButton(
              isLoading: state.isLoadingMore,
              onPressed: () => context.read<DiscoveryListCubit>().loadMore(),
            ),
          ),
        ],
      ],
    );
  }
}

class _LoadMoreButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _LoadMoreButton({required this.isLoading, required this.onPressed});

  static const double _spinnerSize = 20;
  static const double _spinnerStroke = 2;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: _spinnerSize,
              height: _spinnerSize,
              child: CircularProgressIndicator(strokeWidth: _spinnerStroke),
            )
          : const Icon(Icons.expand_more),
      label: Text(isLoading ? 'Đang tải…' : 'Tải thêm'),
    );
  }
}
