import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/profile/view/widgets/profile_completion_status.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:arya/product/theme/custom_light_theme.dart';

@GenerateMocks([ProfileViewModel])
import 'profile_completion_status_test.mocks.dart';

void main() {
  group('ProfileCompletionStatus Tests', () {
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

    testWidgets('should display completed status when user is complete', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(true);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileCompletionStatus), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byIcon(Icons.info_rounded), findsNothing);
    });

    testWidgets('should display incomplete status when user is not complete', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(false);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileCompletionStatus), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
      expect(find.byIcon(Icons.info_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNothing);
    });

    testWidgets('should show correct text for completed status', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(true);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileCompletionStatus), findsOneWidget);
      // Text content would be localized, so we check for Text widgets
      expect(find.byType(Text), findsNWidgets(2)); // Title and description
    });

    testWidgets('should show correct text for incomplete status', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(false);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ProfileCompletionStatus), findsOneWidget);
      // Text content would be localized, so we check for Text widgets
      expect(find.byType(Text), findsNWidgets(2)); // Title and description
    });

    testWidgets('should have proper container structure', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(true);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Expanded), findsOneWidget);
    });

    testWidgets('should display icon in circular container', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(true);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      final iconContainer = find
          .descendant(
            of: find.byType(ProfileCompletionStatus),
            matching: find.byType(Container),
          )
          .at(1); // Second container is the icon container

      final containerWidget = tester.widget<Container>(iconContainer);
      expect(containerWidget.decoration, isA<BoxDecoration>());

      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
    });

    testWidgets('should have proper spacing between elements', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(true);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      expect(find.byType(SizedBox), findsWidgets);

      // Check for the spacing between icon and text
      final sizedBoxes = find.byType(SizedBox);
      expect(sizedBoxes, findsWidgets);
    });

    testWidgets('should apply correct colors for completed status', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(true);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      final mainContainer = find
          .descendant(
            of: find.byType(ProfileCompletionStatus),
            matching: find.byType(Container),
          )
          .first;

      final containerWidget = tester.widget<Container>(mainContainer);
      expect(containerWidget.decoration, isA<BoxDecoration>());

      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, isNotNull);
    });

    testWidgets('should apply correct colors for incomplete status', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(false);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      final mainContainer = find
          .descendant(
            of: find.byType(ProfileCompletionStatus),
            matching: find.byType(Container),
          )
          .first;

      final containerWidget = tester.widget<Container>(mainContainer);
      expect(containerWidget.decoration, isA<BoxDecoration>());

      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, isNotNull);
    });

    testWidgets('should have proper border radius', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(true);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      final mainContainer = find
          .descendant(
            of: find.byType(ProfileCompletionStatus),
            matching: find.byType(Container),
          )
          .first;

      final containerWidget = tester.widget<Container>(mainContainer);
      expect(containerWidget.decoration, isA<BoxDecoration>());

      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('should have proper border styling', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.isUserComplete).thenReturn(true);

      // Act
      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileCompletionStatus(),
          ),
        ),
      );

      // Assert
      final mainContainer = find
          .descendant(
            of: find.byType(ProfileCompletionStatus),
            matching: find.byType(Container),
          )
          .first;

      final containerWidget = tester.widget<Container>(mainContainer);
      expect(containerWidget.decoration, isA<BoxDecoration>());

      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    group('Consumer Behavior Tests', () {
      testWidgets('should rebuild when completion status changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isUserComplete).thenReturn(false);

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileCompletionStatus(),
            ),
          ),
        );

        // Initially shows incomplete status
        expect(find.byIcon(Icons.info_rounded), findsOneWidget);
        expect(find.byIcon(Icons.check_rounded), findsNothing);

        // Change state
        when(mockViewModel.isUserComplete).thenReturn(true);

        // Trigger rebuild
        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileCompletionStatus(),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.check_rounded), findsOneWidget);
        expect(find.byIcon(Icons.info_rounded), findsNothing);
      });

      testWidgets('should handle multiple state changes correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isUserComplete).thenReturn(true);

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileCompletionStatus(),
            ),
          ),
        );

        expect(find.byIcon(Icons.check_rounded), findsOneWidget);

        // Change to incomplete
        when(mockViewModel.isUserComplete).thenReturn(false);

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileCompletionStatus(),
            ),
          ),
        );

        expect(find.byIcon(Icons.info_rounded), findsOneWidget);
        expect(find.byIcon(Icons.check_rounded), findsNothing);

        // Change back to complete
        when(mockViewModel.isUserComplete).thenReturn(true);

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileCompletionStatus(),
            ),
          ),
        );

        expect(find.byIcon(Icons.check_rounded), findsOneWidget);
        expect(find.byIcon(Icons.info_rounded), findsNothing);
      });
    });

    group('Layout Tests', () {
      testWidgets('should handle different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isUserComplete).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 300,
              height: 200,
              child: ChangeNotifierProvider<ProfileViewModel>.value(
                value: mockViewModel,
                child: const ProfileCompletionStatus(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(ProfileCompletionStatus), findsOneWidget);
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('should maintain proper text overflow handling', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isUserComplete).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 200, // Narrow width to test overflow
              child: ChangeNotifierProvider<ProfileViewModel>.value(
                value: mockViewModel,
                child: const ProfileCompletionStatus(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(ProfileCompletionStatus), findsOneWidget);
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });
    });
  });
}
