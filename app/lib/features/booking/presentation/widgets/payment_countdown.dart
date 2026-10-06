import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/format/formatters.dart';

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
    final remaining = widget.deadline.difference(DateTime.now());

    return Text(
      'Còn lại ${formatCountdown(remaining)}',
      style: theme.textTheme.titleMedium?.copyWith(
        color: remaining < _warnBelow ? theme.colorScheme.error : null,
      ),
    );
  }
}
