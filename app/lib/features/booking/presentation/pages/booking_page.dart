import 'package:flutter/material.dart';

import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';

class BookingPage extends StatelessWidget {
  final String eventId;
  const BookingPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return WebPage(
      title: 'Đặt vé',
      actions: const [],
      sections: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text('Đặt vé cho sự kiện: $eventId'),
        ),
      ],
    );
  }
}
