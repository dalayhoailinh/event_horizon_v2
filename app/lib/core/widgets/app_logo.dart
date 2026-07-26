import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppLogo extends StatelessWidget {
  static const double markSize = 30;
  static const double _wordSize = 24;

  final bool showText;
  final double size;

  const AppLogo({super.key, this.showText = true, this.size = markSize});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mark = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CrescentPainter(start: scheme.primary, end: scheme.secondary),
      ),
    );
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [scheme.primary, scheme.secondary],
    );

    if (!showText) return mark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        AppSpacing.hSm,
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: gradient.createShader,
          child: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Event',
                  style: TextStyle(
                    fontSize: _wordSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: 'Horizon',
                  style: TextStyle(
                    fontSize: _wordSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CrescentPainter extends CustomPainter {
  final Color start;
  final Color end;
  _CrescentPainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final full = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      );
    final bite = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width * 0.75, size.height * 0.25),
          radius: radius,
        ),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, full, bite),
      Paint()
        ..style = PaintingStyle.fill
        ..shader = LinearGradient(
          colors: [start, end],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant _CrescentPainter old) =>
      old.start != start || old.end != end;
}
