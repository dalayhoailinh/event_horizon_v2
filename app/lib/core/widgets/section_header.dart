import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// "Sự kiện phổ biến ............ Xem tất cả" row above a content block.
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.smd),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ?trailing,
          if (onSeeAll != null)
            TextButton(onPressed: onSeeAll, child: const Text('Xem tất cả')),
        ],
      ),
    );
  }
}
