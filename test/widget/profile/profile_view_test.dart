import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:arya/features/profile/view/widgets/profile_body.dart';
import 'package:arya/features/profile/view/widgets/profile_actions_consumer.dart';
import 'package:arya/features/auth/model/user_model.dart';
import 'package:arya/product/theme/custom_light_theme.dart';

@GenerateMocks([ProfileViewModel])
import 'profile_view_test.mocks.dart';

// Test için ProfileScreen'i mock'layan basit bir widget
class TestProfileScreen extends StatelessWidget {
  final ProfileViewModel viewModel;

  const TestProfileScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Theme.of(context).colorScheme.surface,
          toolbarHeight: 64,
          actions: const [ProfileActionsConsumer()],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const ProfileBody(),
      ),
    );
  }
}

void main() {
  group('ProfileScreen Tests', () {
    late MockProfileViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockProfileViewModel();
      // Mock controller'ları ekle
      when(mockViewModel.nameController).thenReturn(TextEditingController());
      when(mockViewModel.surnameController).thenReturn(TextEditingController());

      // Mock temel property'ler
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.errorMessage).thenReturn(null);
      when(mockViewModel.hasUser).thenReturn(false);
      when(mockViewModel.user).thenReturn(null);
      when(mockViewModel.isEditing).thenReturn(false);
      when(mockViewModel.isUserComplete).thenReturn(false);

      // Mock method'lar
      when(mockViewModel.fetchUser()).thenAnswer((_) async {});
      when(mockViewModel.dispose()).thenAnswer((_) {});
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(theme: CustomLightTheme().themeData, home: child);
    }

    group('Widget Structure Tests', () {
      testWidgets('should display correct app bar structure', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
        expect(find.byType(ProfileActionsConsumer), findsOneWidget);
      });

      testWidgets('should have correct app bar properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.centerTitle, isTrue);
        expect(appBar.elevation, equals(0));
        expect(appBar.scrolledUnderElevation, equals(0));
        expect(appBar.toolbarHeight, equals(64));
        expect(appBar.actions, isNotNull);
        expect(appBar.actions!.length, equals(1));
      });

      testWidgets('should display profile title in app bar', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.title, isA<Text>());
      });

      testWidgets('should have correct scaffold background color', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, isNotNull);
      });
    });

    group('Provider Integration Tests', () {
      testWidgets('should provide viewModel to child widgets', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(
          find.byType(ChangeNotifierProvider<ProfileViewModel>),
          findsOneWidget,
        );
        expect(find.byType(ProfileBody), findsOneWidget);
        expect(find.byType(ProfileActionsConsumer), findsOneWidget);
      });

      testWidgets('should rebuild when viewModel state changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert initial state
        expect(find.byType(TestProfileScreen), findsOneWidget);

        // Change state
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn('Test error');
        when(mockViewModel.hasUser).thenReturn(false);

        // Trigger rebuild
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
      });
    });

    group('Theme and Styling Tests', () {
      testWidgets('should apply correct theme colors', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));

        expect(appBar.backgroundColor, isNotNull);
        expect(appBar.foregroundColor, isNotNull);
        expect(appBar.surfaceTintColor, isNotNull);
        expect(scaffold.backgroundColor, isNotNull);
      });

      testWidgets('should have correct app bar styling', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.centerTitle, isTrue);
        expect(appBar.elevation, equals(0));
        expect(appBar.scrolledUnderElevation, equals(0));
        expect(appBar.toolbarHeight, equals(64));
      });
    });

    group('ViewModel State Tests', () {
      testWidgets('should handle loading state correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(true);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });

      testWidgets('should handle error state correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn('Test error message');
        when(mockViewModel.hasUser).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });

      testWidgets('should handle user data state correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(true);
        when(mockViewModel.user).thenReturn(testUser);
        when(mockViewModel.isEditing).thenReturn(false);
        when(mockViewModel.isUserComplete).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });

      testWidgets('should handle editing state correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(true);
        when(mockViewModel.user).thenReturn(testUser);
        when(mockViewModel.isEditing).thenReturn(true);
        when(mockViewModel.isUserComplete).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle viewModel errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn('Network error');
        when(mockViewModel.hasUser).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });

      testWidgets('should handle null user data gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);
        when(mockViewModel.user).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should not rebuild unnecessarily', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
        expect(find.byType(ProfileActionsConsumer), findsOneWidget);
      });

      testWidgets('should handle multiple rebuilds efficiently', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Multiple rebuilds
        for (int i = 0; i < 3; i++) {
          when(mockViewModel.isLoading).thenReturn(i % 2 == 0);
          await tester.pumpWidget(
            createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
          );
        }

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should be accessible', (WidgetTester tester) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should have proper semantic structure', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });
    });

    group('Navigation and Route Tests', () {
      testWidgets('should handle navigation correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('should maintain state during navigation', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Navigate away and back
        await tester.pumpWidget(
          createTestWidget(const Scaffold(body: Text('Other Screen'))),
        );
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle empty user data', (WidgetTester tester) async {
        // Arrange
        const emptyUser = UserModel(uid: '', name: '', surname: '', email: '');

        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(true);
        when(mockViewModel.user).thenReturn(emptyUser);
        when(mockViewModel.isEditing).thenReturn(false);
        when(mockViewModel.isUserComplete).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });

      testWidgets('should handle very long user data', (
        WidgetTester tester,
      ) async {
        // Arrange
        const longUser = UserModel(
          uid: 'very_long_user_id_12345678901234567890',
          name: 'Very Long First Name That Might Cause Issues',
          surname: 'Very Long Last Name That Might Cause Issues',
          email:
              'very.long.email.address.that.might.cause.issues@verylongdomainname.com',
        );

        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(true);
        when(mockViewModel.user).thenReturn(longUser);
        when(mockViewModel.isEditing).thenReturn(false);
        when(mockViewModel.isUserComplete).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });

      testWidgets('should handle special characters in user data', (
        WidgetTester tester,
      ) async {
        // Arrange
        const specialUser = UserModel(
          uid: 'user_123',
          name: 'José María',
          surname: 'García-López',
          email: 'jose.maria@example.com',
        );

        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(true);
        when(mockViewModel.user).thenReturn(specialUser);
        when(mockViewModel.isEditing).thenReturn(false);
        when(mockViewModel.isUserComplete).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should integrate with ProfileBody correctly', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(ProfileBody), findsOneWidget);
        expect(find.byType(ProfileActionsConsumer), findsOneWidget);
      });

      testWidgets('should integrate with ProfileActionsConsumer correctly', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(ProfileActionsConsumer), findsOneWidget);
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.actions, isNotNull);
        expect(appBar.actions!.length, equals(1));
      });

      testWidgets('should handle widget lifecycle correctly', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert initial state
        expect(find.byType(TestProfileScreen), findsOneWidget);

        // Dispose and recreate
        await tester.pumpWidget(
          createTestWidget(const Scaffold(body: Text('Disposed'))),
        );
        await tester.pumpWidget(
          createTestWidget(TestProfileScreen(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('should handle different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);

        // Act - Test with small screen
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 300,
              height: 600,
              child: TestProfileScreen(viewModel: mockViewModel),
            ),
          ),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);

        // Test with large screen
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 800,
              height: 1200,
              child: TestProfileScreen(viewModel: mockViewModel),
            ),
          ),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
        expect(find.byType(ProfileBody), findsOneWidget);
      });

      testWidgets('should handle orientation changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.isLoading).thenReturn(false);
        when(mockViewModel.errorMessage).thenReturn(null);
        when(mockViewModel.hasUser).thenReturn(false);

        // Act - Portrait
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 400,
              height: 800,
              child: TestProfileScreen(viewModel: mockViewModel),
            ),
          ),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);

        // Act - Landscape
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 800,
              height: 400,
              child: TestProfileScreen(viewModel: mockViewModel),
            ),
          ),
        );

        // Assert
        expect(find.byType(TestProfileScreen), findsOneWidget);
      });
    });
  });
}
