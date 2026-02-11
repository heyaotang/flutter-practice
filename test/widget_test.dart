import 'package:flutter/material.dart';
import 'package:flutter_practice/pages/navigations/index.dart';
import 'package:flutter_practice/providers/navigation_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('App Routing Tests', () {
    testWidgets('Home page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => NavigationProvider(),
          child: const MaterialApp(
            home: NavigationsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Home'), findsWidgets);
    });
  });
}
