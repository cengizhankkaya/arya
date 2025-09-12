import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/profile/view/widgets/profile_actions_consumer.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:arya/product/utility/theme/theme_view_model.dart';
import '../../helpers/test_helpers.dart';

@GenerateMocks([ProfileViewModel, ThemeViewModel])
import 'profile_actions_consumer_test.mocks.dart';

void main() {
  group('ProfileActionsConsumer Simple Tests', () {
    late MockProfileViewModel mockProfileViewModel;
    late MockThemeViewModel mockThemeViewModel;

    setUp(() {
      mockProfileViewModel = MockProfileViewModel();
      mockThemeViewModel = MockThemeViewModel();
      TestHelpers.setupEasyLocalization();

      // Mock ThemeViewModel properties
      when(mockThemeViewModel.isDarkMode).thenReturn(false);
      when(mockThemeViewModel.toggleTheme()).thenAnswer((_) async {});
    });

    Widget createTestWidget(Widget child) {
      return TestHelpers.createTestApp(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockProfileViewModel,
            ),
            ChangeNotifierProvider<ThemeViewModel>.value(
              value: mockThemeViewModel,
            ),
          ],
          child: child,
        ),
      );
    }

    testWidgets('should hide widget when user is not available', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockProfileViewModel.hasUser).thenReturn(false);

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
      when(mockProfileViewModel.hasUser).thenReturn(true);

      // Act
      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ProfileActionsConsumer), findsOneWidget);
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });

    testWidgets('should display popup menu button with correct properties', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockProfileViewModel.hasUser).thenReturn(true);

      // Act
      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));
      await tester.pumpAndSettle();

      // Assert
      final popupButton = find.byType(PopupMenuButton<String>);
      expect(popupButton, findsOneWidget);

      final popupWidget = tester.widget<PopupMenuButton<String>>(popupButton);
      expect(popupWidget.onSelected, isNotNull);
      expect(popupWidget.itemBuilder, isNotNull);
    });

    testWidgets('should rebuild when viewModel state changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockProfileViewModel.hasUser).thenReturn(false);

      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));
      await tester.pumpAndSettle();

      // Initially no popup menu (widget returns SizedBox.shrink())
      expect(find.byType(PopupMenuButton<String>), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);

      // Change state
      when(mockProfileViewModel.hasUser).thenReturn(true);

      // Trigger rebuild
      await tester.pumpWidget(createTestWidget(const ProfileActionsConsumer()));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    });
  });
}
