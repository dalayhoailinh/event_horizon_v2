import 'package:flutter/material.dart';

void main() {
  runApp(const EventHorizonApp());
}

class EventHorizonApp extends StatelessWidget {
  const EventHorizonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Event Horizon v2',
      home: _PlaceholderPage(),
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Event Horizon v2')));
  }
}
