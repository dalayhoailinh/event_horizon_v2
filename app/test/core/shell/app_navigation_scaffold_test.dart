import 'package:event_horizon/core/shell/app_navigation_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const destinations = [
    AppDestination(icon: Icons.home, label: 'Trang chủ', page: Text('home')),
    AppDestination(icon: Icons.person, label: 'Tôi', page: Text('me')),
  ];

  Future<void> pumpAtWidth(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: AppNavigationScaffold(
          destinations: destinations,
          selectedIndex: 0,
          onDestinationSelected: (_) {},
        ),
      ),
    );
  }

  testWidgets('compact -> bottom NavigationBar', (tester) async {
    await pumpAtWidth(tester, 400);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('expanded -> left NavigationRail', (tester) async {
    await pumpAtWidth(tester, 1200);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
