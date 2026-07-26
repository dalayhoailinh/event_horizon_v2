import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/responsive_grid.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/error_retry_view.dart';
import '../../domain/entities/event_filter.dart';
import '../blocs/discovery_list/discovery_list_cubit.dart';
import '../blocs/discovery_list/discovery_list_state.dart';
import '../widgets/event_card.dart';
import '../widgets/event_filter_bar.dart';

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
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<DiscoveryListCubit>().search(query);
    });
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.pixels >= metrics.maxScrollExtent - 400) {
      context.read<DiscoveryListCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DiscoveryListCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _onQueryChanged,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Tìm sự kiện...',
            border: InputBorder.none,
            icon: Icon(Icons.search),
          ),
        ),
      ),
      body: Column(
        children: [
          AppSpacing.vSm,
          const EventFilterBar(),
          AppSpacing.vSm,
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(DiscoveryListState state) {
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
      return const Center(child: Text('Không có sự kiện nào.'));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = responsiveColumns(
            availableWidth: constraints.maxWidth,
          );
          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: 320,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: state.events.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.events.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return EventCard(event: state.events[index]);
            },
          );
        },
      ),
    );
  }
}
