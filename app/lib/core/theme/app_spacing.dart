import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double smd = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Gap
  static const Widget vXs = SizedBox(height: xs);
  static const Widget vSm = SizedBox(height: sm);
  static const Widget vSmd = SizedBox(height: smd);
  static const Widget vMd = SizedBox(height: md);
  static const Widget vLg = SizedBox(height: lg);
  static const Widget vXl = SizedBox(height: xl);
  static const Widget vXxl = SizedBox(height: xxl);

  static const Widget hXs = SizedBox(width: xs);
  static const Widget hSm = SizedBox(width: sm);
  static const Widget hSmd = SizedBox(width: smd);
  static const Widget hMd = SizedBox(width: md);
  static const Widget hLg = SizedBox(width: lg);
  static const Widget hXl = SizedBox(width: xl);
  static const Widget hXxl = SizedBox(width: xxl);
}
