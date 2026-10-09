import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/page_section.dart';
import '../../../../core/result/result.dart';
import '../../../../core/shell/web_page.dart';
import '../../domain/repositories/booking_repository.dart';

class SeatSelectionPage extends StatelessWidget {
  final String eventId;

  const SeatSelectionPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return WebPage(
      title: 'Chọn ghế',
      actions: const [],
      sections: [
        PageSection(
          child: FutureBuilder(
            future: getIt<BookingRepository>().fetchSeatMap(eventId),
            builder: (context, snapshot) => Text(switch (snapshot.data) {
              null => 'Đang tải...',
              Ok(value: final floors) =>
                'TẠM - ${floors.length} tầng '
                    ' - ${floors.fold<int>(0, (sum, f) => sum + f.seatCount)} ghế',
              Err(:final failure) => failure.message,
            }),
          ),
        ),
      ],
    );
  }
}
