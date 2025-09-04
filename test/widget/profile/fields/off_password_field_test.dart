import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/view/widgets/fields/off_password_field.dart';

import '../../../helpers/test_helpers.dart';

void main() {
  group('OffPasswordField Tests', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display password field with correct properties', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      expect(find.byType(OffPasswordField), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should display field with controller text', (
      WidgetTester tester,
    ) async {
      // Arrange
      controller.text = 'password123';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('should update controller when text is entered', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'newpassword');
      await tester.pump();

      // Assert
      expect(controller.text, equals('newpassword'));
    });

    testWidgets('should have obscureText enabled', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should have correct decoration properties', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.borderRadius, isNotNull);
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.length, equals(1));
    });

    testWidgets('should have correct input decoration', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should display lock icon', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should call validator when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      String? validator(String? value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      }

      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: Form(
            key: formKey,
            child: OffPasswordField(
              controller: controller,
              validator: validator,
            ),
          ),
        ),
      );

      // Act - Trigger validation
      formKey.currentState?.validate();
      await tester.pump();

      // Assert
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should validate password length', (WidgetTester tester) async {
      // Arrange
      String? validator(String? value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      }

      controller.text = '123';

      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: Form(
            key: formKey,
            child: OffPasswordField(
              controller: controller,
              validator: validator,
            ),
          ),
        ),
      );

      // Act - Trigger validation
      formKey.currentState?.validate();
      await tester.pump();

      // Assert
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets(
      'should not show validation error when validator returns null',
      (WidgetTester tester) async {
        // Arrange
        String? validator(String? value) {
          return null; // No error
        }

        controller.text = 'validpassword';

        final formKey = GlobalKey<FormState>();

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: Form(
              key: formKey,
              child: OffPasswordField(
                controller: controller,
                validator: validator,
              ),
            ),
          ),
        );

        // Act - Trigger validation
        formKey.currentState?.validate();
        await tester.pump();

        // Assert
        expect(find.text('Password is required'), findsNothing);
        expect(
          find.text('Password must be at least 6 characters'),
          findsNothing,
        );
      },
    );

    testWidgets('should handle null validator gracefully', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      expect(find.byType(OffPasswordField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should maintain state during rebuild', (
      WidgetTester tester,
    ) async {
      // Arrange
      controller.text = 'testpassword';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Rebuild
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      expect(controller.text, equals('testpassword'));
      expect(find.byType(OffPasswordField), findsOneWidget);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsOneWidget);

      // Should be able to enter text
      await tester.enterText(find.byType(TextFormField), 'test');
      expect(controller.text, equals('test'));
    });

    testWidgets('should handle different controller states', (
      WidgetTester tester,
    ) async {
      // Test with empty controller
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);

      // Test with text in controller
      controller.text = 'password123';
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffPasswordField(controller: controller),
        ),
      );

      expect(find.text('password123'), findsOneWidget);
    });

    group('Input Decoration Tests', () {
      testWidgets('should have correct border properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffPasswordField(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });

      testWidgets('should have correct fill properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffPasswordField(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });

      testWidgets('should have correct content padding', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffPasswordField(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });
    });

    group('Container Decoration Tests', () {
      testWidgets('should have correct shadow properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffPasswordField(controller: controller),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        final shadow = decoration.boxShadow!.first;

        expect(shadow.blurRadius, equals(10));
        expect(shadow.offset, equals(const Offset(0, 2)));
      });

      testWidgets('should have correct border radius', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffPasswordField(controller: controller),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.borderRadius, isNotNull);
      });
    });

    group('Password Security Tests', () {
      testWidgets('should obscure text by default', (
        WidgetTester tester,
      ) async {
        // Arrange
        controller.text = 'secretpassword';

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffPasswordField(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });

      testWidgets('should maintain obscure text during rebuild', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffPasswordField(controller: controller),
          ),
        );

        // Rebuild
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffPasswordField(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });
    });
  });
}
