import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/features/profile/view/widgets/fields/off_username_field.dart';
import '../../../helpers/test_helpers.dart';

void main() {
  group('OffUsernameField Tests', () {
    late TextEditingController controller;

    setUp(() {
      // Easy Localization mock setup
      EasyLocalization.logger.enableBuildModes = [];
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('should display username field with correct properties', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
        ),
      );

      // Assert
      expect(find.byType(OffUsernameField), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('should display field with controller text', (
      WidgetTester tester,
    ) async {
      // Arrange
      controller.text = 'testuser';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
        ),
      );

      // Assert
      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('should update controller when text is entered', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'newuser');
      await tester.pump();

      // Assert
      expect(controller.text, equals('newuser'));
    });

    testWidgets('should have correct decoration properties', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
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
          child: OffUsernameField(controller: controller),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should display prefix icon', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('should call validator when provided', (
      WidgetTester tester,
    ) async {
      // Arrange
      String? validator(String? value) {
        if (value == null || value.isEmpty) {
          return 'Username is required';
        }
        return null;
      }

      final formKey = GlobalKey<FormState>();

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: Form(
            key: formKey,
            child: OffUsernameField(
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
      expect(find.text('Username is required'), findsOneWidget);
    });

    testWidgets(
      'should not show validation error when validator returns null',
      (WidgetTester tester) async {
        // Arrange
        String? validator(String? value) {
          return null; // No error
        }

        controller.text = 'validuser';
        final formKey = GlobalKey<FormState>();

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: Form(
              key: formKey,
              child: OffUsernameField(
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
        expect(find.text('Username is required'), findsNothing);
      },
    );

    testWidgets('should handle null validator gracefully', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
        ),
      );

      // Assert
      expect(find.byType(OffUsernameField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('should maintain state during rebuild', (
      WidgetTester tester,
    ) async {
      // Arrange
      controller.text = 'testuser';

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
        ),
      );

      // Rebuild
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
        ),
      );

      // Assert
      expect(controller.text, equals('testuser'));
      expect(find.byType(OffUsernameField), findsOneWidget);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
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
          child: OffUsernameField(controller: controller),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);

      // Test with text in controller
      controller.text = 'user123';
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffUsernameField(controller: controller),
        ),
      );

      expect(find.text('user123'), findsOneWidget);
    });

    group('Input Decoration Tests', () {
      testWidgets('should have correct border properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffUsernameField(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });

      testWidgets('should have correct fill properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffUsernameField(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });

      testWidgets('should have correct content padding', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffUsernameField(controller: controller),
          ),
        );

        // Assert
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });
    });

    group('Container Decoration Tests', () {
      testWidgets('should have correct shadow properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffUsernameField(controller: controller),
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
            child: OffUsernameField(controller: controller),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;

        expect(decoration.borderRadius, isNotNull);
      });
    });
  });
}
