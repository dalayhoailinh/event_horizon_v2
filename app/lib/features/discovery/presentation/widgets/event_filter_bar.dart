import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/event_filter.dart';
import '../../domain/entities/provinces.dart';
import '../blocs/discovery_list/discovery_list_cubit.dart';
import '../routing/event_filter_query.dart';

/// Every filter change goes through the URL (`context.go`), so the filtered
/// list survives F5, back/forward and a shared link.
void _goWith(BuildContext context, EventFilter filter) =>
    context.go(eventsLocationFor(filter));

const Map<EventTimeRange, String> _timeLabels = {
  EventTimeRange.all: 'Tất cả',
  EventTimeRange.today: 'Hôm nay',
  EventTimeRange.thisWeek: 'Tuần này',
  EventTimeRange.thisMonth: 'Tháng này',
};

/// Wide windows: filter card in a left column ("Bộ lọc" in the design).
class EventFilterPanel extends StatelessWidget {
  const EventFilterPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<DiscoveryListCubit>().state;
    final filter = state.filter;
    final hasFilter =
        filter.categoryId != null ||
        filter.provinceCode != null ||
        filter.timeRange != EventTimeRange.all;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Bộ lọc',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: hasFilter
                      ? () => _goWith(
                          context,
                          EventFilter(searchQuery: filter.searchQuery),
                        )
                      : null,
                  child: const Text('Thiết lập lại'),
                ),
              ],
            ),
            AppSpacing.vSm,
            _GroupTitle('Thể loại'),
            _ChoiceWrap<String>(
              options: [
                (null, 'Tất cả'),
                for (final EventCategory c in state.categories) (c.id, c.name),
              ],
              selected: filter.categoryId,
              onSelected: (id) =>
                  _goWith(context, filter.copyWith(categoryId: id)),
            ),
            AppSpacing.vMd,
            _GroupTitle('Thời gian'),
            _ChoiceWrap<EventTimeRange>(
              options: [
                for (final entry in _timeLabels.entries)
                  (entry.key, entry.value),
              ],
              selected: filter.timeRange,
              onSelected: (range) => _goWith(
                context,
                filter.copyWith(timeRange: range ?? EventTimeRange.all),
              ),
            ),
            AppSpacing.vMd,
            _GroupTitle('Địa điểm'),
            _ChoiceWrap<String>(
              options: [
                (null, 'Tất cả'),
                for (final p in kProvinces) (p.code, p.name),
              ],
              selected: filter.provinceCode,
              onSelected: (code) =>
                  _goWith(context, filter.copyWith(provinceCode: code)),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  final String text;
  const _GroupTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(text, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

/// Single-choice chips; tapping the selected one again keeps it (use "Tất cả"
/// to clear) so a stray click never silently drops a filter.
class _ChoiceWrap<T> extends StatelessWidget {
  final List<(T?, String)> options;
  final T? selected;
  final ValueChanged<T?> onSelected;
  const _ChoiceWrap({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (value, label) in options)
          ChoiceChip(
            label: Text(label),
            selected: value == selected,
            onSelected: (_) {
              if (value != selected) onSelected(value);
            },
          ),
      ],
    );
  }
}

/// Narrow windows: one scrollable row of dropdown chips above the grid.
class EventFilterBar extends StatelessWidget {
  const EventFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DiscoveryListCubit>().state;
    final filter = state.filter;

    String? categoryName;
    for (final c in state.categories) {
      if (c.id == filter.categoryId) categoryName = c.name;
    }
    String? provinceName;
    for (final p in kProvinces) {
      if (p.code == filter.provinceCode) provinceName = p.name;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _DropdownChip<String>(
            label: categoryName ?? 'Thể loại',
            selected: filter.categoryId != null,
            options: [
              (null, 'Tất cả'),
              for (final c in state.categories) (c.id, c.name),
            ],
            onSelected: (id) =>
                _goWith(context, filter.copyWith(categoryId: id)),
          ),
          AppSpacing.hSm,
          _DropdownChip<String>(
            label: provinceName ?? 'Địa điểm',
            selected: filter.provinceCode != null,
            options: [
              (null, 'Tất cả'),
              for (final p in kProvinces) (p.code, p.name),
            ],
            onSelected: (code) =>
                _goWith(context, filter.copyWith(provinceCode: code)),
          ),
          AppSpacing.hSm,
          _DropdownChip<EventTimeRange>(
            label: filter.timeRange == EventTimeRange.all
                ? 'Thời gian'
                : _timeLabels[filter.timeRange]!,
            selected: filter.timeRange != EventTimeRange.all,
            options: [
              for (final entry in _timeLabels.entries) (entry.key, entry.value),
            ],
            onSelected: (range) => _goWith(
              context,
              filter.copyWith(timeRange: range ?? EventTimeRange.all),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip that opens a dropdown menu under itself (web idiom: dropdown, not a
/// bottom sheet).
class _DropdownChip<T> extends StatelessWidget {
  final String label;
  final bool selected;
  final List<(T?, String)> options;
  final ValueChanged<T?> onSelected;
  const _DropdownChip({
    required this.label,
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MenuAnchor(
      menuChildren: [
        for (final (value, text) in options)
          MenuItemButton(onPressed: () => onSelected(value), child: Text(text)),
      ],
      builder: (context, controller, child) => FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
            ),
          ],
        ),
        selected: selected,
        onSelected: (_) =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
    );
  }
}
