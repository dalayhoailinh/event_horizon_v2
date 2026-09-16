import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/shell/web_page.dart';
import '../../domain/repositories/booking_repository.dart';

class PaymentPage extends StatelessWidget {
  final String bookingId;

  const PaymentPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return WebPage(
      title: 'Thanh toán',
      actions: const [],
      sections: [
        PageSection(
          child: StreamBuilder(
            stream: getIt<BookingRepository>().watchBooking(bookingId),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Lỗi: ${snapshot.error}');
              final booking = snapshot.data;
              if (booking == null) return const Text('Đang tải...');
              return Text(
                'TẠM - ${booking.eventTitle}\n'
                'Trạng thái: ${booking.status.name}\n'
                'Tổng: ${booking.totalAmount}\n'
                'Hạn: ${booking.expiresAt}',
              );
            },
          ),
        ),
      ],
    );
  }
}
