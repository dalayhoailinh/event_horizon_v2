import 'package:flutter/widgets.dart';

enum WindowSize {
  compact,
  medium,
  expanded;

  bool get isCompact => this == WindowSize.compact;
  bool get isMedium => this == WindowSize.medium;
  bool get isExpanded => this == WindowSize.expanded;

  bool atLeast(WindowSize min) => index >= min.index;
}

abstract final class Breakpoints {
  static const double medium = 600;
  static const double expanded = 840;
  static const double contentMax = 1200;
  static const double shellGutter = 64;
  static const double gutter = 24;
  static const double gutterCompact = 16;

  static WindowSize of(double width) {
    if (width < medium) return WindowSize.compact;
    if (width < expanded) return WindowSize.medium;
    return WindowSize.expanded;
  }
}

extension WindowSizeContext on BuildContext {
  WindowSize get windowSize => Breakpoints.of(MediaQuery.of(this).size.width);
  double get gutter =>
      windowSize.isCompact ? Breakpoints.gutterCompact : Breakpoints.gutter;
  double get shellGutter => windowSize.isCompact
      ? Breakpoints.gutterCompact
      : Breakpoints.shellGutter;
}
