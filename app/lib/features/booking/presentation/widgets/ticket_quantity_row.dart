import 'package:flutter/material.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../discovery/domain/entities/event_detail.dart';

class TicketQuantityRow extends StatelessWidget {
  final TicketTypeInfo ticketType;
  final int quantity;
  final ValueChanged<int> onChanged;

  const TicketQuantityRow({
    super.key,
    required this.ticketType,
    required this.quantity,
    required this.onChanged,
  });

  static const int _maxPerBooking = 10;
  static const double _stackBelowWidth = 420;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soldOut = ticketType.remaining <= 0;
    final limit = ticketType.remaining > _maxPerBooking
        ? _maxPerBooking
        : ticketType.remaining;

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ticketType.name, style: theme.textTheme.titleSmall),
        if (ticketType.description.isNotEmpty)
          Text(ticketType.description, style: theme.textTheme.bodySmall),
        Text(
          soldOut ? 'Hết vé' : 'Còn ${ticketType.remaining} vé',
          style: theme.textTheme.bodySmall?.copyWith(
            color: soldOut ? theme.colorScheme.error : null,
          ),
        ),
      ],
    );
    final price = Text(
      formatVnd(ticketType.price),
      style: theme.textTheme.titleSmall,
    );
    final stepper = _Stepper(
      quantity: quantity,
      max: limit,
      onChanged: soldOut ? null : onChanged,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < _stackBelowWidth) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  info,
                  AppSpacing.vSm,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [price, stepper],
                  ),
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: info),
                AppSpacing.hMd,
                price,
                AppSpacing.hMd,
                stepper,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  final int quantity;
  final int max;
  final ValueChanged<int>? onChanged;

  const _Stepper({
    required this.quantity,
    required this.max,
    required this.onChanged,
  });

  static const double _countWidth = 32;

  @override
  Widget build(BuildContext context) {
    final change = onChanged;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          // Tooltip nói KẾT QUẢ của việc bấm, không phải tên cái nút.
          tooltip: 'Bớt một vé',
          onPressed: change == null || quantity <= 0
              ? null
              : () => change(quantity - 1),
          icon: const Icon(Icons.remove),
        ),
        SizedBox(
          width: _countWidth,
          child: Text('$quantity', textAlign: TextAlign.center),
        ),
        IconButton(
          tooltip: 'Thêm một vé',
          onPressed: change == null || quantity >= max
              ? null
              : () => change(quantity + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
