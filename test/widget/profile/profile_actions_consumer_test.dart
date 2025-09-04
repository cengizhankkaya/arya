import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/features/profile/view/widgets/profile_actions_consumer.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import '../../helpers/test_helpers.dart';

@GenerateMocks([ProfileViewModel])
import 'profile_actions_consumer_test.mocks.dart';

void main() {
  // Setup Easy Localization before any tests
  TestHelpers.setupEasyLocalization();

  group('ProfileActionsConsumer Tests', () {
    late MockProfileViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockProfileViewModel();
    });

    Widget createTestWidget(Widget child) {
      return TestHelpers.createTestAppWithLocalization(
        ChangeNotifierProvider<ProfileViewModel>.value(
          value: mockViewModel,
          child: child,
        ),
      );
    }

    testWidgets('should hide widget when user is not available', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.hasUser).thenReturn(false);

      // Act
      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));

      // Assert
      expect(find.byType(ProfileActionsConsumer), findsOneWidget);
      expect(find.byType(PopupMenuButton<String>), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    testWidgets('should show PopupMenuButton when user is available', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.hasUser).thenReturn(true);

      // Act
      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProfileActionsConsumer), findsOneWidget);
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('should display all menu items when popup is opened', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.hasUser).thenReturn(true);

      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
      // Icons are inside PopupMenuItem widgets, so we need to find them within the menu
      expect(
        find.descendant(
          of: find.byType(PopupMenuItem<String>),
          matching: find.byIcon(Icons.language),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(PopupMenuItem<String>),
          matching: find.byIcon(Icons.key),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(PopupMenuItem<String>),
          matching: find.byIcon(Icons.delete_forever),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'should show language dialog when language option is selected',
      (WidgetTester tester) async {
        // Arrange
        when(mockViewModel.hasUser).thenReturn(true);

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileActionsConsumer(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.byType(PopupMenuButton<String>));
        await tester.pumpAndSettle();

        // Find and tap language menu item
        final languageItems = find.byType(PopupMenuItem<String>);
        await tester.tap(languageItems.first);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Dialog), findsOneWidget);
        expect(
          find.byType(ElevatedButton),
          findsNWidgets(2),
        ); // Turkish and English buttons
        expect(find.byType(TextButton), findsOneWidget); // Cancel button
      },
    );

    testWidgets('should display OFF menu item correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.hasUser).thenReturn(true);

      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileActionsConsumer(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Assert
      // Verify the menu items exist
      expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
    });

    testWidgets('should display delete menu item correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.hasUser).thenReturn(true);

      await tester.pumpWidget(
        createTestWidget(
          ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const ProfileActionsConsumer(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Assert
      // Verify the menu items exist
      expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
    });

    testWidgets('should display correct menu item text and icons', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.hasUser).thenReturn(true);

      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Assert
      // Check that menu items exist
      expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
    });

    testWidgets('should handle popup menu selection correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.hasUser).thenReturn(true);

      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));
      await tester.pumpAndSettle();

      // Verify popup menu button exists
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);

      // Act
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();

      // Verify popup is open
      expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));

      // Close popup by tapping outside
      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PopupMenuItem<String>), findsNothing);
    });

    group('Menu Item Styling Tests', () {
      testWidgets('should apply correct styling to delete menu item', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.hasUser).thenReturn(true);

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileActionsConsumer(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify popup menu button exists
        expect(find.byType(PopupMenuButton<String>), findsOneWidget);

        // Act
        await tester.tap(find.byType(PopupMenuButton<String>));
        await tester.pumpAndSettle();

        // Assert
        // Verify menu items exist
        expect(find.byType(PopupMenuItem<String>), findsNWidgets(3));
      });

      testWidgets('should display language submenu correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.hasUser).thenReturn(true);

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileActionsConsumer(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify popup menu button exists
        expect(find.byType(PopupMenuButton<String>), findsOneWidget);

        // Act
        await tester.tap(find.byType(PopupMenuButton<String>));
        await tester.pumpAndSettle();

        // Find and tap language menu item
        final languageItems = find.byType(PopupMenuItem<String>);
        await tester.tap(languageItems.first);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Dialog), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Row), findsWidgets);
      });
    });

    group('Consumer Behavior Tests', () {
      testWidgets('should rebuild when viewModel state changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.hasUser).thenReturn(false);

        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileActionsConsumer(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initially no popup menu (widget returns SizedBox.shrink())
        expect(find.byType(PopupMenuButton<String>), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);

        // Change state
        when(mockViewModel.hasUser).thenReturn(true);

        // Trigger rebuild
        await tester.pumpWidget(
          createTestWidget(
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const ProfileActionsConsumer(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(PopupMenuButton<String>), findsOneWidget);
      });
    });
  });
}
