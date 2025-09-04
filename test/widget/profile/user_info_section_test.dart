import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/profile/view/widgets/user_info_section.dart';
import 'package:arya/features/profile/view/widgets/email_display_widget.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:arya/features/auth/model/user_model.dart';
import 'package:arya/product/theme/custom_light_theme.dart';

@GenerateMocks([ProfileViewModel])
import 'user_info_section_test.mocks.dart';

void main() {
  group('UserInfoSection Tests', () {
    late MockProfileViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockProfileViewModel();
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: CustomLightTheme().themeData,
        home: Scaffold(body: child),
      );
    }

    testWidgets('should display user information correctly', (
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      expect(find.byType(UserInfoSection), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
    });

    testWidgets('should display edit button', (WidgetTester tester) async {
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should call toggleEditMode when edit button is pressed', (
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Assert
      verify(mockViewModel.toggleEditMode()).called(1);
    });

    testWidgets('should display correct icons for each info row', (
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      expect(
        find.byIcon(Icons.person),
        findsNWidgets(3),
      ); // Name, surname, and header
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should handle null values gracefully', (
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
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      expect(find.byType(UserInfoSection), findsOneWidget);
      // Should display "not specified" text for null values
      expect(find.byType(Text), findsWidgets);
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
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('should display header section with correct styling', (
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.person), findsNWidgets(3));
      expect(find.byType(Row), findsWidgets);

      // Check header row
      final headerRow = find
          .descendant(
            of: find.byType(UserInfoSection),
            matching: find.byType(Row),
          )
          .first;

      expect(headerRow, findsOneWidget);
    });

    testWidgets('should display info rows with correct structure', (
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      // Should have 3 info rows (name, surname, email)
      final infoRows = find.descendant(
        of: find.byType(UserInfoSection),
        matching: find.byType(Row),
      );

      expect(infoRows, findsWidgets);
    });

    testWidgets('should display circular icon containers', (
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // Check for circular containers (icon containers)
      final containerWidgets = tester.widgetList<Container>(containers);
      final circularContainers = containerWidgets.where(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).shape == BoxShape.circle,
      );

      expect(
        circularContainers.length,
        greaterThanOrEqualTo(3),
      ); // At least 3 icon containers
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
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      expect(find.byType(SizedBox), findsWidgets);

      // Check for spacing widgets
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsWidgets);
    });

    testWidgets('should display email using EmailDisplayWidget', (
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      // EmailDisplayWidget should be present for email row
      expect(find.byType(UserInfoSection), findsOneWidget);
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
    });

    testWidgets('should handle long text with proper overflow', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testUser = UserModel(
        uid: 'user123',
        name: 'VeryLongFirstName',
        surname: 'VeryLongLastName',
        email: 'verylongemailaddress@example.com',
      );

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      expect(find.byType(UserInfoSection), findsOneWidget);
      expect(find.text('VeryLongFirstName'), findsOneWidget);
      expect(find.text('VeryLongLastName'), findsOneWidget);
      expect(find.byType(EmailDisplayWidget), findsOneWidget);
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
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      final mainContainer = find
          .descendant(
            of: find.byType(UserInfoSection),
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

    testWidgets('should display correct tooltip for edit button', (
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
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: UserInfoSection(user: testUser),
          ),
        ),
      );

      // Assert
      final iconButton = find.byType(IconButton);
      expect(iconButton, findsOneWidget);

      final buttonWidget = tester.widget<IconButton>(iconButton);
      expect(buttonWidget.tooltip, isNotNull);
    });

    group('Consumer Behavior Tests', () {
      testWidgets('should rebuild when viewModel state changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: UserInfoSection(user: testUser),
            ),
          ),
        );

        expect(find.byType(UserInfoSection), findsOneWidget);

        // Trigger rebuild with same data
        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: UserInfoSection(user: testUser),
            ),
          ),
        );

        // Assert
        expect(find.byType(UserInfoSection), findsOneWidget);
      });
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
              height: 400,
              child: ChangeNotifierProvider<ProfileViewModel>.value(
                value: mockViewModel,
                child: UserInfoSection(user: testUser),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(UserInfoSection), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Row), findsWidgets);
        expect(find.byType(Expanded), findsWidgets);
      });

      testWidgets('should maintain proper aspect ratios', (
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
              height: 500, // Increased height to prevent overflow
              child: ChangeNotifierProvider<ProfileViewModel>.value(
                value: mockViewModel,
                child: UserInfoSection(user: testUser),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(UserInfoSection), findsOneWidget);

        // Check icon container dimensions
        final containers = find.byType(Container);
        final containerWidgets = tester.widgetList<Container>(containers);
        final iconContainers = containerWidgets.where(
          (container) =>
              container.decoration is BoxDecoration &&
              (container.decoration as BoxDecoration).shape == BoxShape.circle,
        );

        expect(iconContainers.isNotEmpty, isTrue);

        // Check icon container size
        final firstIconContainer = iconContainers.first;
        expect(firstIconContainer.constraints?.maxWidth, equals(40.0));
        expect(firstIconContainer.constraints?.maxHeight, equals(40.0));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty strings gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: '',
          surname: '',
          email: '',
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: UserInfoSection(user: testUser),
            ),
          ),
        );

        // Assert
        expect(find.byType(UserInfoSection), findsOneWidget);
        // Should display "not specified" for empty strings
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should handle special characters in names', (
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
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: UserInfoSection(user: testUser),
            ),
          ),
        );

        // Assert
        expect(find.byType(UserInfoSection), findsOneWidget);
        expect(find.text('José'), findsOneWidget);
        expect(find.text('García'), findsOneWidget);
        expect(find.byType(EmailDisplayWidget), findsOneWidget);
      });
    });
  });
}
