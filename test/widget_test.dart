import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart'; // Uygulama yolunuza göre güncelleyin

void main() {
  testWidgets('TodoListScreen widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Expect to find an AppBar with the title 'Task List'.
    expect(find.text('Task List'), findsOneWidget);

    // Add a test todo item.
    await tester.enterText(find.byType(TextField), 'Test Todo');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Expect to find the added test todo item.
    expect(find.text('Test Todo'), findsOneWidget);

    // Dismiss the added test todo item.
    await tester.drag(find.byType(Dismissible), const Offset(500.0, 0.0));
    await tester.pumpAndSettle();

    // Expect the test todo item to be dismissed.
    expect(find.text('Test Todo'), findsNothing);
  });
}
