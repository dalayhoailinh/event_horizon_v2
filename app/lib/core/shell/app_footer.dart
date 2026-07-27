import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../responsive/breakpoints.dart';
import '../responsive/page_section.dart';
import '../theme/app_spacing.dart';
import '../widgets/app_logo.dart';
import 'site_nav.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = context.windowSize.isCompact;
    final columns = context.windowSize.atLeast(WindowSize.expanded);

    return PageSection(
      background: theme.colorScheme.surfaceContainerHighest,
      maxContentWidth: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.shellGutter,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (columns) const _FooterColumns() else const _FooterStack(),
          AppSpacing.vXl,
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          AppSpacing.vLg,
          Align(
            alignment: compact ? Alignment.center : Alignment.centerLeft,
            child: Text(
              '© 2026 Event Horizon',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterColumns extends StatelessWidget {
  const _FooterColumns();

  static const int _brandFlex = 3;
  static const int _linkFlex = 2;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: _brandFlex, child: _FooterBrand()),
        for (final group in kFooterNav)
          Expanded(
            flex: _linkFlex,
            child: _FooterLinkGroup(group: group),
          ),
      ],
    );
  }
}

class _FooterStack extends StatelessWidget {
  const _FooterStack();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FooterBrand(),
        for (final group in kFooterNav) ...[
          AppSpacing.vLg,
          _FooterLinkGroup(group: group),
        ],
      ],
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  static const double _taglineMaxWidth = 260;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppLogo(),
        AppSpacing.vMd,
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _taglineMaxWidth),
          child: Text(
            'Khám phá sự kiện, đặt vé và tận hưởng những khoảnh khắc tuyệt vời',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLinkGroup extends StatelessWidget {
  final NavGroup group;
  const _FooterLinkGroup({required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.vSm,
        for (final link in group.links) _FooterLink(link: link),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final NavLink link;
  const _FooterLink({required this.link});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final route = link.route;

    return TextButton(
      onPressed: route == null ? null : () => context.go(route),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        minimumSize: Size.zero,
        alignment: Alignment.centerLeft,
        foregroundColor: theme.colorScheme.onSurfaceVariant,
        disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
      ),
      child: Text(
        link.label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
