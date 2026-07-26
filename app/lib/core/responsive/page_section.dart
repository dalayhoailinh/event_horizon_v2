import 'package:flutter/widgets.dart';

import '../theme/app_spacing.dart';
import 'breakpoints.dart';

class ContentContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const ContentContainer({
    super.key,
    required this.child,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

class PageSection extends StatelessWidget {
  final Widget child;
  final Color? background;
  final double maxContentWidth;
  final EdgeInsetsGeometry? padding;
  const PageSection({
    super.key,
    required this.child,
    this.background,
    this.maxContentWidth = Breakpoints.contentMax,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: context.gutter,
            vertical: AppSpacing.lg,
          ),
      child: ContentContainer(maxWidth: maxContentWidth, child: child),
    );
  }
}
