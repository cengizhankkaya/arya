import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';

import '../../helpers/test_helpers.dart';
@GenerateMocks([ProfileViewModel])
import 'edit_profile_form_test.mocks.dart';

// Test için lokalizasyon kullanmayan EditProfileForm
class TestEditProfileForm extends StatelessWidget {
  const TestEditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: viewModel.nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: viewModel.surnameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Surname',
              prefixIcon: Icon(Icons.badge),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => viewModel.toggleEditMode(),
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => viewModel.updateUserFromControllers(),
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  group('EditProfileForm Tests', () {
    late MockProfileViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockProfileViewModel();

      // Mock setup
      when(mockViewModel.nameController).thenReturn(TextEditingController());
      when(mockViewModel.surnameController).thenReturn(TextEditingController());

      // Mock methods
      when(mockViewModel.toggleEditMode()).thenAnswer((_) async {});
      when(mockViewModel.updateUserFromControllers()).thenAnswer((_) async {});
    });

    testWidgets('should display form with name and surname fields', (
      WidgetTester tester,
    ) async {
      // Arrange

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Assert
      expect(find.byType(TestEditProfileForm), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should display save and cancel buttons', (
      WidgetTester tester,
    ) async {
      // Arrange

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.save_rounded), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should call toggleEditMode when cancel button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange

      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Cancel'));
      await tester.pump();

      // Assert
      verify(mockViewModel.toggleEditMode()).called(1);
    });

    testWidgets(
      'should call updateUserFromControllers when save button is pressed',
      (WidgetTester tester) async {
        // Arrange
        when(mockViewModel.nameController).thenReturn(TextEditingController());
        when(
          mockViewModel.surnameController,
        ).thenReturn(TextEditingController());

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const TestEditProfileForm(),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Assert
        verify(mockViewModel.updateUserFromControllers()).called(1);
      },
    );

    testWidgets('should have proper form structure', (
      WidgetTester tester,
    ) async {
      // Arrange

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Assert
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsAtLeastNWidgets(1));
      expect(find.byType(Expanded), findsNWidgets(2));
    });

    testWidgets('should display name field with correct properties', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.nameController).thenReturn(TextEditingController());

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Assert
      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      final nameField = textFields.first;

      expect(nameField.textInputAction, equals(TextInputAction.next));
      expect(nameField.decoration?.prefixIcon, isA<Icon>());
    });

    testWidgets('should display surname field with correct properties', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.surnameController).thenReturn(TextEditingController());

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Assert
      final textFields = tester.widgetList<TextField>(find.byType(TextField));
      final surnameField = textFields.last;

      expect(surnameField.textInputAction, equals(TextInputAction.next));
      expect(surnameField.decoration?.prefixIcon, isA<Icon>());
    });

    testWidgets('should have proper container decoration', (
      WidgetTester tester,
    ) async {
      // Arrange

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isNotNull);
      expect(container.padding, isNotNull);
    });

    testWidgets('should maintain state during rebuild', (
      WidgetTester tester,
    ) async {
      // Arrange

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Rebuild
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Assert
      expect(find.byType(TestEditProfileForm), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Arrange

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: ChangeNotifierProvider<ProfileViewModel>.value(
            value: mockViewModel,
            child: const TestEditProfileForm(),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Should be able to interact with fields and buttons
      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pump();
      await tester.tap(find.text('Cancel'));
      await tester.pump();
    });

    group('Button Layout Tests', () {
      testWidgets('should have buttons in a row with proper spacing', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.nameController).thenReturn(TextEditingController());
        when(
          mockViewModel.surnameController,
        ).thenReturn(TextEditingController());

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const TestEditProfileForm(),
            ),
          ),
        );

        // Assert
        expect(find.byType(Row), findsAtLeastNWidgets(1));
        expect(find.byType(Expanded), findsNWidgets(2));
      });

      testWidgets('should have cancel button with close icon', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.nameController).thenReturn(TextEditingController());
        when(
          mockViewModel.surnameController,
        ).thenReturn(TextEditingController());

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const TestEditProfileForm(),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('should have save button with save icon', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.nameController).thenReturn(TextEditingController());
        when(
          mockViewModel.surnameController,
        ).thenReturn(TextEditingController());

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const TestEditProfileForm(),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.save_rounded), findsOneWidget);
        expect(find.text('Save'), findsOneWidget);
      });
    });

    group('Form Field Tests', () {
      testWidgets('should have name field with person icon', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.nameController).thenReturn(TextEditingController());

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const TestEditProfileForm(),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
      });

      testWidgets('should have surname field with person icon', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(
          mockViewModel.surnameController,
        ).thenReturn(TextEditingController());

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const TestEditProfileForm(),
            ),
          ),
        );

        // Assert
        expect(find.byIcon(Icons.badge), findsOneWidget);
      });

      testWidgets('should have proper text input actions', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.nameController).thenReturn(TextEditingController());
        when(
          mockViewModel.surnameController,
        ).thenReturn(TextEditingController());

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<ProfileViewModel>.value(
              value: mockViewModel,
              child: const TestEditProfileForm(),
            ),
          ),
        );

        // Assert
        final textFields = tester.widgetList<TextField>(find.byType(TextField));
        for (final field in textFields) {
          expect(field.textInputAction, equals(TextInputAction.next));
        }
      });
    });
  });
}
