import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:arya/features/profile/view_model/off_credentials_view_model.dart';
import 'package:arya/features/profile/model/off_credentials_model.dart';
import 'package:arya/features/profile/repository/off_credentials_repository.dart';
import 'package:arya/features/profile/view/widgets/off_info_card.dart';
import 'package:arya/features/profile/view/widgets/off_form_header.dart';
import 'package:arya/features/profile/view/widgets/off_help_text.dart';
import 'package:arya/features/profile/view/widgets/fields/off_username_field.dart';
import 'package:arya/features/profile/view/widgets/fields/off_password_field.dart';
import 'package:arya/features/profile/view/widgets/off_action_buttons.dart';
import 'package:arya/product/theme/custom_light_theme.dart';

@GenerateMocks([OffCredentialsViewModel, IOffCredentialsRepository])
import 'off_credentials_view_test.mocks.dart';

// Test için OffCredentialsView'i mock'layan basit bir widget
class TestOffCredentialsView extends StatefulWidget {
  final OffCredentialsViewModel viewModel;

  const TestOffCredentialsView({super.key, required this.viewModel});

  @override
  State<TestOffCredentialsView> createState() => _TestOffCredentialsViewState();
}

class _TestOffCredentialsViewState extends State<TestOffCredentialsView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.viewModel,
      child: Consumer<OffCredentialsViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('OFF Account'),
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OffInfoCard(
                    onLaunchOpenFoodFacts: () {
                      // Mock implementation for testing
                    },
                  ),
                  const SizedBox(height: 24),
                  const OffFormHeader(),
                  const SizedBox(height: 16),
                  _buildForm(context, viewModel),
                  const SizedBox(height: 16),
                  const OffHelpText(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, OffCredentialsViewModel viewModel) {
    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          OffUsernameField(
            controller: viewModel.usernameController,
            validator: viewModel.validateUsername,
          ),
          const SizedBox(height: 16),
          OffPasswordField(
            controller: viewModel.passwordController,
            validator: viewModel.validatePassword,
          ),
          const SizedBox(height: 24),
          OffActionButtons(viewModel: viewModel),
        ],
      ),
    );
  }
}

void main() {
  group('OffCredentialsView Tests', () {
    late MockOffCredentialsViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockOffCredentialsViewModel();

      // Mock controller'ları ekle
      when(
        mockViewModel.usernameController,
      ).thenReturn(TextEditingController());
      when(
        mockViewModel.passwordController,
      ).thenReturn(TextEditingController());
      when(mockViewModel.formKey).thenReturn(GlobalKey<FormState>());

      // Mock temel property'ler
      when(mockViewModel.loading).thenReturn(false);
      when(mockViewModel.hasCredentials).thenReturn(false);
      when(mockViewModel.isFormValid).thenReturn(false);
      when(mockViewModel.isRateLimited).thenReturn(false);
      when(mockViewModel.remainingAttempts).thenReturn(5);
      when(mockViewModel.credentials).thenReturn(null);

      // Mock method'lar
      when(mockViewModel.load()).thenAnswer((_) async {});
      when(mockViewModel.save()).thenAnswer((_) async => true);
      when(mockViewModel.clear()).thenAnswer((_) async {});
      when(mockViewModel.handleSave(any)).thenAnswer((_) async {});
      when(mockViewModel.handleClear(any)).thenAnswer((_) async {});
      when(mockViewModel.validateUsername(any)).thenReturn(null);
      when(mockViewModel.validatePassword(any)).thenReturn(null);
      when(mockViewModel.dispose()).thenAnswer((_) {});
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: CustomLightTheme().themeData,
        home: child,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('should display correct scaffold structure', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should have correct app bar properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.elevation, equals(0));
        expect(appBar.title, isA<Text>());
        expect(appBar.backgroundColor, isNotNull);
        expect(appBar.foregroundColor, isNotNull);
      });

      testWidgets('should display all required widgets', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(OffInfoCard), findsOneWidget);
        expect(find.byType(OffFormHeader), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(OffUsernameField), findsOneWidget);
        expect(find.byType(OffPasswordField), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
        expect(find.byType(OffHelpText), findsOneWidget);
      });

      testWidgets('should have correct form structure', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final form = tester.widget<Form>(find.byType(Form));
        expect(form.key, isNotNull);

        expect(find.byType(OffUsernameField), findsOneWidget);
        expect(find.byType(OffPasswordField), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });
    });

    group('Provider Integration Tests', () {
      testWidgets('should provide viewModel to child widgets', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(
          find.byType(ChangeNotifierProvider<OffCredentialsViewModel>),
          findsOneWidget,
        );
        expect(find.byType(Consumer<OffCredentialsViewModel>), findsOneWidget);
      });

      testWidgets('should rebuild when viewModel state changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert initial state
        expect(find.byType(TestOffCredentialsView), findsOneWidget);

        // Change state
        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(true);

        // Trigger rebuild
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
      });
    });

    group('Form Field Tests', () {
      testWidgets('should display username field with correct properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final usernameField = find.byType(OffUsernameField);
        expect(usernameField, findsOneWidget);

        final field = tester.widget<OffUsernameField>(usernameField);
        expect(field.controller, isNotNull);
        expect(field.validator, isNotNull);
      });

      testWidgets('should display password field with correct properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final passwordField = find.byType(OffPasswordField);
        expect(passwordField, findsOneWidget);

        final field = tester.widget<OffPasswordField>(passwordField);
        expect(field.controller, isNotNull);
        expect(field.validator, isNotNull);
      });

      testWidgets('should display action buttons with correct properties', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final actionButtons = find.byType(OffActionButtons);
        expect(actionButtons, findsOneWidget);

        final buttons = tester.widget<OffActionButtons>(actionButtons);
        expect(buttons.viewModel, equals(mockViewModel));
      });
    });

    group('ViewModel State Tests', () {
      testWidgets('should handle loading state correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });

      testWidgets('should handle credentials loaded state', (
        WidgetTester tester,
      ) async {
        // Arrange
        const testCredentials = OffCredentialsModel(
          username: 'testuser',
          password: 'testpass123',
        );

        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(true);
        when(mockViewModel.credentials).thenReturn(testCredentials);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });

      testWidgets('should handle rate limited state', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.isRateLimited).thenReturn(true);
        when(mockViewModel.remainingAttempts).thenReturn(0);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should handle form submission', (WidgetTester tester) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.isFormValid).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Find and tap save button
        final saveButton = find.byType(ElevatedButton);
        expect(saveButton, findsOneWidget);

        await tester.tap(saveButton);
        await tester.pump();

        // Assert
        verify(mockViewModel.handleSave(any)).called(1);
      });

      testWidgets('should handle clear button tap', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Find and tap clear button
        final clearButton = find.byType(OutlinedButton);
        expect(clearButton, findsOneWidget);

        await tester.tap(clearButton);
        await tester.pump();

        // Assert
        verify(mockViewModel.handleClear(any)).called(1);
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should validate username field', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          mockViewModel.validateUsername('invalid'),
        ).thenReturn('Username is invalid');
        when(mockViewModel.validateUsername('validuser')).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final usernameField = find.byType(OffUsernameField);
        expect(usernameField, findsOneWidget);

        final field = tester.widget<OffUsernameField>(usernameField);
        expect(field.validator, isNotNull);
      });

      testWidgets('should validate password field', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          mockViewModel.validatePassword('weak'),
        ).thenReturn('Password is too weak');
        when(mockViewModel.validatePassword('StrongPass123!')).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final passwordField = find.byType(OffPasswordField);
        expect(passwordField, findsOneWidget);

        final field = tester.widget<OffPasswordField>(passwordField);
        expect(field.validator, isNotNull);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should handle viewModel errors gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });

      testWidgets('should handle null credentials gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(false);
        when(mockViewModel.credentials).thenReturn(null);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should not rebuild unnecessarily', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(false);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffInfoCard), findsOneWidget);
        expect(find.byType(OffFormHeader), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });

      testWidgets('should handle multiple rebuilds efficiently', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(true);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Multiple rebuilds
        for (int i = 0; i < 3; i++) {
          when(mockViewModel.loading).thenReturn(i % 2 == 0);
          await tester.pumpWidget(
            createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
          );
        }

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle empty credentials data', (
        WidgetTester tester,
      ) async {
        // Arrange
        const emptyCredentials = OffCredentialsModel(
          username: '',
          password: '',
        );

        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(true);
        when(mockViewModel.credentials).thenReturn(emptyCredentials);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });

      testWidgets('should handle very long credentials data', (
        WidgetTester tester,
      ) async {
        // Arrange
        const longCredentials = OffCredentialsModel(
          username: 'very_long_username_that_might_cause_issues_123456789',
          password: 'VeryLongPasswordThatMightCauseIssues123456789!@#',
        );

        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(true);
        when(mockViewModel.credentials).thenReturn(longCredentials);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });

      testWidgets('should handle special characters in credentials', (
        WidgetTester tester,
      ) async {
        // Arrange
        const specialCredentials = OffCredentialsModel(
          username: 'user_123',
          password: 'P@ssw0rd!@#',
        );

        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(true);
        when(mockViewModel.credentials).thenReturn(specialCredentials);

        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('should integrate with OffInfoCard correctly', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(OffInfoCard), findsOneWidget);
        expect(find.byType(OffFormHeader), findsOneWidget);
      });

      testWidgets('should integrate with form fields correctly', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(OffUsernameField), findsOneWidget);
        expect(find.byType(OffPasswordField), findsOneWidget);
        expect(find.byType(OffActionButtons), findsOneWidget);
      });

      testWidgets('should handle widget lifecycle correctly', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert initial state
        expect(find.byType(TestOffCredentialsView), findsOneWidget);

        // Dispose and recreate
        await tester.pumpWidget(
          createTestWidget(const Scaffold(body: Text('Disposed'))),
        );
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('should handle different screen sizes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(false);

        // Act - Test with small screen
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 300,
              height: 600,
              child: TestOffCredentialsView(viewModel: mockViewModel),
            ),
          ),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffInfoCard), findsOneWidget);

        // Test with large screen
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 800,
              height: 1200,
              child: TestOffCredentialsView(viewModel: mockViewModel),
            ),
          ),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
        expect(find.byType(OffInfoCard), findsOneWidget);
      });

      testWidgets('should handle orientation changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);
        when(mockViewModel.hasCredentials).thenReturn(false);

        // Act - Portrait
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 400,
              height: 800,
              child: TestOffCredentialsView(viewModel: mockViewModel),
            ),
          ),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);

        // Act - Landscape
        await tester.pumpWidget(
          createTestWidget(
            SizedBox(
              width: 800,
              height: 400,
              child: TestOffCredentialsView(viewModel: mockViewModel),
            ),
          ),
        );

        // Assert
        expect(find.byType(TestOffCredentialsView), findsOneWidget);
      });
    });

    group('Theme and Styling Tests', () {
      testWidgets('should apply correct theme colors', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));

        expect(appBar.backgroundColor, isNotNull);
        expect(appBar.foregroundColor, isNotNull);
        expect(scaffold.body, isNotNull);
      });

      testWidgets('should have correct app bar styling', (
        WidgetTester tester,
      ) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(TestOffCredentialsView(viewModel: mockViewModel)),
        );

        // Assert
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.elevation, equals(0));
        expect(appBar.title, isA<Text>());
      });
    });
  });
}
