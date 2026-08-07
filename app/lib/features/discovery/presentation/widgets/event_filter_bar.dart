import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/event_filter.dart';
import '../../domain/entities/provinces.dart';
import '../blocs/discovery_list/discovery_list_cubit.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _DropdownChip(
            label: categoryName ?? 'Danh mục',
            selected: filter.categoryId != null,
            onTap: () => _pick<String>(
              context: context,
              title: 'Chọn danh mục',
              options: [
                (null, 'Tất cả'),
                for (final c in state.categories) (c.id, c.name),
              ],
              onSelected: context.read<DiscoveryListCubit>().setCategory,
            ),
          ),
          AppSpacing.vSm,
          _DropdownChip(
            label: provinceName ?? 'Tỉnh/Thành',
            selected: filter.provinceCode != null,
            onTap: () => _pick<String>(
              context: context,
              title: 'Tỉnh/Thành',
              options: [
                (null, 'Tất cả'),
                for (final p in kProvinces) (p.code, p.name),
              ],
              onSelected: context.read<DiscoveryListCubit>().setProvince,
            ),
          ),
          AppSpacing.vSm,
          _DropdownChip(
            label: switch (filter.timeRange) {
              EventTimeRange.all => 'Thời gian',
              EventTimeRange.today => 'Hôm nay',
              EventTimeRange.thisWeek => 'Tuần này',
              EventTimeRange.thisMonth => 'Tháng này',
            },
            selected: filter.timeRange != EventTimeRange.all,
            onTap: () => _pick<EventTimeRange>(
              context: context,
              title: 'Thời gian',
              options: const [
                (EventTimeRange.all, 'Tất cả'),
                (EventTimeRange.today, 'Hôm nay'),
                (EventTimeRange.thisWeek, 'Tuần này'),
                (EventTimeRange.thisMonth, 'Tháng này'),
              ],
              onSelected: (range) => context
                  .read<DiscoveryListCubit>()
                  .setTimeRange(range ?? EventTimeRange.all),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pick<T>({
    required BuildContext context,
    required String title,
    required List<(T?, String)> options,
    required ValueChanged<T?> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            for (final (value, label) in options)
              ListTile(
                title: Text(label),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onSelected(value);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DropdownChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _DropdownChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
