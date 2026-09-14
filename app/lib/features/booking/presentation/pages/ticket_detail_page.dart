import 'package:flutter/material.dart';

import '../../../../core/shell/web_page.dart';

class TicketDetailPage extends StatelessWidget {
  final String bookingId;
  const TicketDetailPage({required this.bookingId, super.key});

  @override
  Widget build(BuildContext context) {
    return WebPage(
      title: 'Chi tiết vé',
      actions: [],
      sections: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Chi tiết vé: $bookingId'),
        ),
      ],
    );
  }
}
