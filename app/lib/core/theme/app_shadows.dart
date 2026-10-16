import 'package:flutter/painting.dart';

/// Elevation tokens from the design file ("Effect styles / Shadow").
abstract final class AppShadows {
  /// Resting cards.
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 1)),
  ];

  /// Hovered cards, sticky bars.
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
  ];

  /// Menus, dropdowns, floating panels.
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 4)),
  ];
}
