import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/shell/web_page.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/booking_repository.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WebPage(
      title: 'Vé của tôi',
      actions: const [],
      sections: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: StreamBuilder(
            stream: getIt<BookingRepository>().watchMyBookings(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Lỗi: ${snapshot.error}');
              }
              final bookings = snapshot.data;
              if (bookings == null) {
                return const Text('Đang tải…');
              }
              return Text('TẠM: ${bookings.length} đơn');
            },
          ),
        ),
      ],
    );
  }
}
