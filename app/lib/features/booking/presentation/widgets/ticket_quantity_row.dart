import 'package:flutter/material.dart';

import '../../../../core/format/formatters.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../discovery/domain/entities/event_detail.dart';

/// One ticket type inside the "Chọn loại vé" card: name, stock, price and a
/// − n + stepper. Stacks on narrow widths instead of squeezing.
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
    final scheme = theme.colorScheme;
    final soldOut = ticketType.remaining <= 0;
    final limit = ticketType.remaining > _maxPerBooking
        ? _maxPerBooking
        : ticketType.remaining;

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ticketType.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (ticketType.description.isNotEmpty)
          Text(
            ticketType.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        AppSpacing.vXs,
        Text(
          soldOut ? 'Hết vé' : 'Còn ${ticketType.remaining} vé',
          style: theme.textTheme.labelMedium?.copyWith(
            color: soldOut ? scheme.error : scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
    final price = Text(
      formatVnd(ticketType.price),
      style: theme.textTheme.titleMedium?.copyWith(
        color: scheme.primary,
        fontWeight: FontWeight.w700,
      ),
    );
    final stepper = _Stepper(
      quantity: quantity,
      max: limit,
      onChanged: soldOut ? null : onChanged,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.smd),
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
              AppSpacing.hLg,
              stepper,
            ],
          );
        },
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

  static const double _countWidth = 36;

  @override
  Widget build(BuildContext context) {
    final change = onChanged;
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          // The tooltip says what the click DOES, not what the button is.
          tooltip: 'Bớt một vé',
          onPressed: change == null || quantity <= 0
              ? null
              : () => change(quantity - 1),
          icon: const Icon(Icons.remove, size: 18),
        ),
        SizedBox(
          width: _countWidth,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
        ),
        IconButton.outlined(
          tooltip: 'Thêm một vé',
          onPressed: change == null || quantity >= max
              ? null
              : () => change(quantity + 1),
          icon: const Icon(Icons.add, size: 18),
        ),
      ],
    );
  }
}
