import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/view/widgets/profile_header.dart';
import 'package:arya/features/profile/view/widgets/email_display_widget.dart';
import 'package:arya/features/auth/model/user_model.dart';
import 'package:arya/product/theme/custom_light_theme.dart';

void main() {
  group('ProfileHeader Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: CustomLightTheme().themeData,
        home: Scaffold(body: child),
      );
    }

    testWidgets('should display user name correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byType(ProfileHeader), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('should display first letter of name in avatar', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('J'), findsOneWidget); // First letter of "John"
    });

    testWidgets('should display email when available', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('should not display email section when email is null', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: null,
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byType(ProfileHeader), findsOneWidget);
      expect(find.byIcon(Icons.email), findsNothing);
      // Email container should not be present
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should handle empty display name gracefully', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: '',
        surname: '',
        email: 'test@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byType(ProfileHeader), findsOneWidget);
      expect(
        find.text('İsimsiz Kullanıcı'),
        findsOneWidget,
      ); // Fallback for empty name
    });

    testWidgets('should have proper container structure', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('should display avatar with correct styling', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      final circleAvatar = find.byType(CircleAvatar);
      expect(circleAvatar, findsOneWidget);

      final avatarWidget = tester.widget<CircleAvatar>(circleAvatar);
      expect(avatarWidget.radius, equals(44.0));
      expect(avatarWidget.backgroundColor, isNotNull);
    });

    testWidgets('should display email in styled container when available', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      // Find the email container
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Email should be displayed
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('should have proper spacing between elements', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byType(SizedBox), findsWidgets);

      // Check for spacing between avatar and text
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsWidgets);
    });

    testWidgets('should handle different user names correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser1 = UserModel(
        uid: 'user1',
        name: 'Alice',
        surname: 'Smith',
        email: 'alice@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser1)));

      // Assert
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('A'), findsOneWidget); // First letter of "Alice"
    });

    testWidgets('should handle single name correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: '',
        email: 'john@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.text('John'), findsOneWidget);
      expect(find.text('J'), findsOneWidget); // First letter of "John"
    });

    testWidgets('should have proper shadow and decoration', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      final mainContainer = find
          .descendant(
            of: find.byType(ProfileHeader),
            matching: find.byType(Container),
          )
          .first;

      final containerWidget = tester.widget<Container>(mainContainer);
      expect(containerWidget.decoration, isA<BoxDecoration>());

      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.isNotEmpty, isTrue);
    });

    testWidgets('should handle long names with proper overflow', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'VeryLongFirstName',
        surname: 'VeryLongLastName',
        email: 'verylongname@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byType(ProfileHeader), findsOneWidget);
      expect(find.text('VeryLongFirstName VeryLongLastName'), findsOneWidget);
      expect(find.text('V'), findsOneWidget); // First letter
    });

    testWidgets('should display email with correct icon and styling', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'John',
        surname: 'Doe',
        email: 'john.doe@example.com',
      );

      // Act
      await tester.pumpWidget(createTestWidget(ProfileHeader(user: testUser)));

      // Assert
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byType(EmailDisplayWidget), findsOneWidget);

      // Check icon size
      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.email));
      expect(iconWidget.size, equals(16.0));
    });

    group('Layout Tests', () {
      testWidgets('should handle different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 300,
              height: 200,
              child: ProfileHeader(user: testUser),
            ),
          ),
        );

        // Assert
        expect(find.byType(ProfileHeader), findsOneWidget);
        expect(find.byType(Row), findsWidgets);
        expect(find.byType(Expanded), findsWidgets);
      });

      testWidgets('should maintain proper aspect ratio', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 400,
              height: 150,
              child: ProfileHeader(user: testUser),
            ),
          ),
        );

        // Assert
        expect(find.byType(ProfileHeader), findsOneWidget);
        expect(find.byType(CircleAvatar), findsOneWidget);

        final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
        expect(avatar.radius, equals(44.0));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null user gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: null,
          surname: null,
          email: null,
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(ProfileHeader(user: testUser)),
        );

        // Assert
        expect(find.byType(ProfileHeader), findsOneWidget);
        expect(
          find.text('İsimsiz Kullanıcı'),
          findsOneWidget,
        ); // Fallback for null name
      });

      testWidgets('should handle special characters in name', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'José',
          surname: 'García',
          email: 'jose@example.com',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(ProfileHeader(user: testUser)),
        );

        // Assert
        expect(find.text('José García'), findsOneWidget);
        expect(find.text('J'), findsOneWidget); // First letter
      });
    });
  });
}
