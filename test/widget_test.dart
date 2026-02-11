import 'package:flutter_practice/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Routing Tests', () {
    testWidgets('Home page displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('Home Page'), findsOneWidget);
    });
  });
}
