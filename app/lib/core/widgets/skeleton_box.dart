import 'package:flutter/material.dart';

import '../theme/app_radius.dart';

/// Grey placeholder that gently pulses while content loads. Use it in the
/// exact shape of the content it stands for, so the page does not jump when
/// the data arrives (a spinner keeps no shape).
class SkeletonBox extends StatefulWidget {
  final double? width;
  final double? height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadius.sm,
  });

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  static const _period = Duration(milliseconds: 900);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _period,
    lowerBound: 0.45,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
