import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/main.dart'; // Uygulama yolunuza göre güncelleyin

void main() {
  group('TodoListScreen widget test', () {
    late SharedPreferences prefs;

    setUp(() async {
      // Initialize SharedPreferences for tests
      prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('todo_list', []);
    });

    tearDown(() async {
      // Clean up after tests
      await prefs.clear();
    });

    testWidgets('Add and remove todo item', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Your test scenario here
      // ...

      // Example scenario: Tap the 'Add' button and expect to find the added todo item
      await tester.enterText(find.byType(TextField), 'Test Todo');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Test Todo'), findsOneWidget);

      // Example scenario: Dismiss the added todo item and expect it to be removed
      await tester.drag(find.byType(Dismissible), const Offset(500.0, 0.0));
      await tester.pumpAndSettle();

      expect(find.text('Test Todo'), findsNothing);
    });

    // Additional tests can be added here using the same setup/teardown logic
  });
}
