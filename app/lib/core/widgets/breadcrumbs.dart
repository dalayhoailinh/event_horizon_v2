import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../shell/site_nav.dart';
import '../theme/app_spacing.dart';

class Crumb {
  final String label;

  /// Null for the current page (last crumb, not a link).
  final String? route;
  const Crumb(this.label, [this.route]);
}

/// "Khám phá › Tên sự kiện › Chọn ghế". The web way to show where a deep page
/// sits — the browser already has a back button, an app-style back arrow
/// would be a second one.
class Breadcrumbs extends StatelessWidget {
  final List<Crumb> items;
  const Breadcrumbs({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme.bodyMedium;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xs,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0)
            Icon(Icons.chevron_right, size: 16, color: scheme.onSurfaceVariant),
          switch (items[i].route) {
            final route? => TextButton(
              onPressed: () => context.go(route),
              style: linkButtonStyle(scheme, base: style).copyWith(
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                minimumSize: const WidgetStatePropertyAll(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(items[i].label),
            ),
            null => ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                items[i].label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          },
        ],
      ],
    );
  }
}
