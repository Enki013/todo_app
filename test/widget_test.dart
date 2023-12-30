import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/main.dart';

// SharedPreferences'ın sahte sürümünü oluşturmak için bir Mock sınıfı
class MockSharedPreferences extends Mock implements SharedPreferences {}

// SharedPreferences'ın sahte sürümü
class FakeSharedPreferences {
  late MockSharedPreferences sharedPreferences;

  FakeSharedPreferences() {
    sharedPreferences = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
    SharedPreferences.setMockInstance(sharedPreferences);
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Sahte SharedPreferences'ı oluştur
    final fakeSharedPreferences = FakeSharedPreferences();

    // Uygulamanın ana widget'ını başlat
    await tester.pumpWidget(MyApp());

    // Butonun var olduğunu doğrulayın
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Butona tıklayarak işlevselliği test edin
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Counter'ın artıp artmadığını kontrol edin
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Adding todo item test', (WidgetTester tester) async {
    final fakeSharedPreferences = FakeSharedPreferences();
    
    await tester.pumpWidget(MyApp());

    // Ekleme butonunun var olduğunu doğrula
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Yeni bir görev eklemek için TextField'a değer gir
    await tester.enterText(find.byType(TextField), 'Test Todo');
    await tester.pump();

    // Ekleme butonuna tıkla
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Yeni görevin listeye eklendiğini doğrula
    expect(find.text('Test Todo'), findsOneWidget);
  });
}
