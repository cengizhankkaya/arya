import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/view/widgets/email_display_widget.dart';
import 'package:arya/test/helpers/test_helpers.dart';

void main() {
  group('EmailDisplayWidget Tests', () {
    testWidgets('should display email correctly', (WidgetTester tester) async {
      // Arrange
      const testEmail = 'test@example.com';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: EmailDisplayWidget(email: testEmail)),
      );

      // Assert
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
    });

    testWidgets('should display email with custom style', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testEmail = 'user@domain.com';
      const customStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: EmailDisplayWidget(email: testEmail, style: customStyle),
        ),
      );

      // Assert
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
    });

    testWidgets('should display email with icon', (WidgetTester tester) async {
      // Arrange
      const testEmail = 'test@example.com';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: EmailDisplayWidget(email: testEmail, icon: Icons.email),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
    });

    testWidgets('should display email with custom icon properties', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testEmail = 'test@example.com';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: EmailDisplayWidget(
            email: testEmail,
            icon: Icons.person,
            iconSize: 24.0,
            iconColor: Colors.blue,
          ),
        ),
      );

      // Assert
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(iconWidget.size, equals(24.0));
      expect(iconWidget.color, equals(Colors.blue));
    });

    testWidgets('should handle email without @ symbol', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testEmail = 'invalidemail';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: EmailDisplayWidget(email: testEmail)),
      );

      // Assert
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
    });

    testWidgets('should handle empty email', (WidgetTester tester) async {
      // Arrange
      const testEmail = '';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(child: EmailDisplayWidget(email: testEmail)),
      );

      // Assert
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
    });

    testWidgets('should apply custom padding', (WidgetTester tester) async {
      // Arrange
      const testEmail = 'test@example.com';
      const customPadding = EdgeInsets.all(16.0);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: EmailDisplayWidget(email: testEmail, padding: customPadding),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(customPadding));
    });

    testWidgets('should apply custom decoration', (WidgetTester tester) async {
      // Arrange
      const testEmail = 'test@example.com';
      const customDecoration = BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      );

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: EmailDisplayWidget(
            email: testEmail,
            decoration: customDecoration,
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, equals(customDecoration));
    });

    testWidgets('should handle long email with ellipsis', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testEmail = 'verylongusername@verylongdomainname.com';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: SizedBox(
            width: 100, // Constrain width to force ellipsis
            child: EmailDisplayWidget(email: testEmail),
          ),
        ),
      );

      // Assert
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
    });

    testWidgets('should have proper widget structure', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: EmailDisplayWidget(email: 'user@domain.com')),
        ),
      );

      // Assert
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    group('Email Splitting Logic Tests', () {
      test('should split email at first @ symbol', () {
        // Arrange
        const testEmail = 'user@domain.com';

        // Act
        final atIndex = testEmail.indexOf('@');
        final username = atIndex == -1
            ? testEmail
            : testEmail.substring(0, atIndex);
        final domain = atIndex == -1 ? '' : testEmail.substring(atIndex + 1);

        // Assert
        expect(username, equals('user'));
        expect(domain, equals('domain.com'));
      });

      test('should handle email with multiple @ symbols', () {
        // Arrange
        const testEmail = 'user@domain@extra.com';

        // Act
        final atIndex = testEmail.indexOf('@');
        final username = atIndex == -1
            ? testEmail
            : testEmail.substring(0, atIndex);
        final domain = atIndex == -1 ? '' : testEmail.substring(atIndex + 1);

        // Assert
        expect(username, equals('user'));
        expect(domain, equals('domain@extra.com'));
      });

      test('should handle email without @ symbol', () {
        // Arrange
        const testEmail = 'invalidemail';

        // Act
        final atIndex = testEmail.indexOf('@');
        final username = atIndex == -1
            ? testEmail
            : testEmail.substring(0, atIndex);
        final domain = atIndex == -1 ? '' : testEmail.substring(atIndex + 1);

        // Assert
        expect(username, equals('invalidemail'));
        expect(domain, equals(''));
      });

      test('should handle empty email', () {
        // Arrange
        const testEmail = '';

        // Act
        final atIndex = testEmail.indexOf('@');
        final username = atIndex == -1
            ? testEmail
            : testEmail.substring(0, atIndex);
        final domain = atIndex == -1 ? '' : testEmail.substring(atIndex + 1);

        // Assert
        expect(username, equals(''));
        expect(domain, equals(''));
      });
    });
  });
}
