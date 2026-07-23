import 'package:flutter/material.dart';

import 'breakpoints.dart';

class ResponsiveContentBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContentBox({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.contentMax,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
