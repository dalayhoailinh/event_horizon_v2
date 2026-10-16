import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// "Còn lại 4:59" pill that ticks every second and turns red near the end.
class PaymentCountdown extends StatefulWidget {
  final DateTime deadline;

  const PaymentCountdown({super.key, required this.deadline});

  @override
  State<PaymentCountdown> createState() => _PaymentCountdownState();
}

class _PaymentCountdownState extends State<PaymentCountdown> {
  static const Duration _tick = Duration(seconds: 1);
  static const Duration _warnBelow = Duration(minutes: 3);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_tick, (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final remaining = widget.deadline.difference(DateTime.now());
    final urgent = remaining < _warnBelow;
    final fg = urgent ? scheme.error : scheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: urgent ? scheme.errorContainer : scheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 18, color: fg),
          AppSpacing.hSm,
          Text(
            remaining.isNegative
                ? formatCountdown(remaining)
                : 'Còn lại ${formatCountdown(remaining)}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: fg,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
