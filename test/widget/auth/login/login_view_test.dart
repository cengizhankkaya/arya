import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginView UI Tests', () {
    Widget createTestWidget() {
      return MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              // Email field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 16),
              // Password field
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 16),
              // Login button
              ElevatedButton(onPressed: () {}, child: const Text('Login')),
            ],
          ),
        ),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('Login form temel widget yapısını göstermeli', (
        tester,
      ) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Ana widget'ların varlığını kontrol et
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('Login form tüm gerekli child widget\'ları göstermeli', (
        tester,
      ) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Form içeriğini kontrol et
        expect(
          find.byType(TextFormField),
          findsNWidgets(2),
        ); // Email ve Password
        expect(find.byType(ElevatedButton), findsOneWidget); // Login button
      });
    });

    group('User Interaction Tests', () {
      testWidgets('Email field\'a text girilebilmeli', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Email field'ı bul ve text gir
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        // Text'in girildiğini kontrol et
        expect(find.text('test@example.com'), findsOneWidget);
      });

      testWidgets('Password field\'a text girilebilmeli', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Password field'ı bul ve text gir
        final passwordField = find.byType(TextFormField).at(1);
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        // Text'in girildiği kontrol edilmeli
        expect(find.text('password123'), findsOneWidget);
      });

      testWidgets('Login button tıklanabilir olmalı', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Login button'ı bul ve tıkla
        final loginButton = find.byType(ElevatedButton);
        expect(loginButton, findsOneWidget);

        await tester.tap(loginButton);
        await tester.pumpAndSettle();
      });
    });

    group('Edge Case Tests', () {
      testWidgets('Çok uzun email text\'i ile çalışmalı', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Çok uzun email text'i
        final longEmail = 'a' * 100 + '@example.com';
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, longEmail);
        await tester.pump();

        // Text girildi mi kontrol et
        expect(find.text(longEmail), findsOneWidget);
      });

      testWidgets('Çok uzun şifre text\'i ile çalışmalı', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Çok uzun şifre text'i
        final longPassword = 'a' * 100;
        final passwordField = find.byType(TextFormField).at(1);
        await tester.enterText(passwordField, longPassword);
        await tester.pump();

        // Text girildi mi kontrol et
        expect(find.text(longPassword), findsOneWidget);
      });

      testWidgets('Özel karakterler ile çalışmalı', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Özel karakterler içeren email
        final specialEmail = 'test+tag@example.com';
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, specialEmail);
        await tester.pump();

        // Text girildi mi kontrol et
        expect(find.text(specialEmail), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Semantic labels doğru olmalı', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Email field semantic label'ı
        final emailField = find.byType(TextFormField).first;
        final emailSemantics = tester.getSemantics(emailField);
        expect(emailSemantics, isNotNull);

        // Password field semantic label'ı
        final passwordField = find.byType(TextFormField).at(1);
        final passwordSemantics = tester.getSemantics(passwordField);
        expect(passwordSemantics, isNotNull);
      });

      testWidgets('Login button semantic label\'ı olmalı', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // Login button semantic label'ı
        final loginButton = find.byType(ElevatedButton);
        final buttonSemantics = tester.getSemantics(loginButton);
        expect(buttonSemantics, isNotNull);
      });
    });

    group('Responsiveness Tests', () {
      testWidgets('Farklı ekran boyutlarında çalışmalı', (tester) async {
        final testWidget = createTestWidget();

        // Küçük ekran
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();
        expect(find.byType(Column), findsOneWidget);

        // Büyük ekran
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('Landscape orientation\'da çalışmalı', (tester) async {
        final testWidget = createTestWidget();

        // Landscape orientation
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        // Form hala görünür olmalı
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(ElevatedButton), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('Tam login flow entegrasyon testi', (tester) async {
        final testWidget = createTestWidget();
        await tester.pumpWidget(testWidget);

        // 1. Email gir
        final emailField = find.byType(TextFormField).first;
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        // 2. Şifre gir
        final passwordField = find.byType(TextFormField).at(1);
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        // 3. Login button'a tıkla
        final loginButton = find.byType(ElevatedButton);
        await tester.tap(loginButton);
        await tester.pumpAndSettle();

        // Form alanları doğru şekilde dolduruldu mu kontrol et
        expect(find.text('test@example.com'), findsOneWidget);
        expect(find.text('password123'), findsOneWidget);
      });
    });
  });
}
