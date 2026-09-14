import 'package:flutter/material.dart';

import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebPage(
      title: 'Vé của tôi',
      actions: [],
      sections: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Text('Vé của tôi'),
        ),
      ],
    );
  }
}
