import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/main.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class FakeSharedPreferences {
  late MockSharedPreferences sharedPreferences;

  FakeSharedPreferences() {
    sharedPreferences = MockSharedPreferences();
    when(sharedPreferences.setStringList(any, any)).thenAnswer((_) => Future.value(true));
    when(sharedPreferences.getStringList(any)).thenReturn(<String>[]);
    when(sharedPreferences.setBool(any, any)).thenAnswer((_) => Future.value(true));
    when(sharedPreferences.getBool(any)).thenReturn(false);
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final fakeSharedPreferences = FakeSharedPreferences();

    await tester.pumpWidget(MyApp());

    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Adding todo item test', (WidgetTester tester) async {
    final fakeSharedPreferences = FakeSharedPreferences();

    await tester.pumpWidget(MyApp());

    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Test Todo');
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Test Todo'), findsOneWidget);
  });
}
