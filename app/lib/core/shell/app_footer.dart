import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../responsive/breakpoints.dart';
import '../responsive/page_section.dart';
import '../theme/app_spacing.dart';
import 'site_nav.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PageSection(
      background: theme.colorScheme.surfaceContainerHighest,
      maxContentWidth: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.shellGutter,
        vertical: AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            children: [
              _FooterColumn(
                title: 'Khám phá',
                children: [
                  for (final link in kSiteNav)
                    _FooterLink(label: link.label, route: link.route),
                ],
              ),
              const _FooterColumn(
                title: 'Về EventHorizon',
                children: [
                  Text('Đồ án tốt nghiệp'),
                  Text('support@eventhorizon.test'),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.sm),
          Text('© 2026 EventHorizon', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

const double _footerColumnWidth = 220;

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _FooterColumn({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _footerColumnWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final String route;
  const _FooterLink({required this.label, required this.route});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(onPressed: () => context.go(route), child: Text(label)),
    );
  }
}
