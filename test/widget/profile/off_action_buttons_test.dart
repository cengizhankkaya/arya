import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:arya/features/profile/view/widgets/off_action_buttons.dart';
import 'package:arya/features/profile/view_model/off_credentials_view_model.dart';
import '../../helpers/test_helpers.dart';

@GenerateMocks([OffCredentialsViewModel])
import 'off_action_buttons_test.mocks.dart';

void main() {
  group('OffActionButtons Tests', () {
    late MockOffCredentialsViewModel mockViewModel;

    setUp(() {
      mockViewModel = MockOffCredentialsViewModel();
    });

    testWidgets('should display save and clear buttons', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(false);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should disable buttons when loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(true);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Assert
      final saveButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final clearButton = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );

      expect(saveButton.onPressed, isNull);
      expect(clearButton.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should enable buttons when not loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(false);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Assert
      final saveButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final clearButton = tester.widget<OutlinedButton>(
        find.byType(OutlinedButton),
      );

      expect(saveButton.onPressed, isNotNull);
      expect(clearButton.onPressed, isNotNull);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should call handleSave when save button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(false);

      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      verify(mockViewModel.handleSave(any)).called(1);
    });

    testWidgets('should call handleClear when clear button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(false);

      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Act
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      // Assert
      verify(mockViewModel.handleClear(any)).called(1);
    });

    testWidgets('should display loading indicator when loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(true);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.save), findsNothing);
    });

    testWidgets('should display save icon when not loading', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(false);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should have proper button layout', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(false);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Assert
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Expanded), findsNWidgets(2));
    });

    testWidgets('should maintain button state during rebuild', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(false);

      // Act
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Rebuild
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Assert
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('should handle loading state changes', (
      WidgetTester tester,
    ) async {
      // Arrange
      when(mockViewModel.loading).thenReturn(false);

      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Change to loading state
      when(mockViewModel.loading).thenReturn(true);
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          child: OffActionButtons(viewModel: mockViewModel),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    group('Button Styling Tests', () {
      testWidgets('should have correct save button styling', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffActionButtons(viewModel: mockViewModel),
          ),
        );

        // Assert
        final saveButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(saveButton.style, isNotNull);
      });

      testWidgets('should have correct clear button styling', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffActionButtons(viewModel: mockViewModel),
          ),
        );

        // Assert
        final clearButton = tester.widget<OutlinedButton>(
          find.byType(OutlinedButton),
        );
        expect(clearButton.style, isNotNull);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should be accessible when enabled', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(false);

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffActionButtons(viewModel: mockViewModel),
          ),
        );

        // Assert
        expect(find.byType(ElevatedButton), findsOneWidget);
        expect(find.byType(OutlinedButton), findsOneWidget);

        // Buttons should be tappable
        await tester.tap(find.byType(ElevatedButton));
        await tester.tap(find.byType(OutlinedButton));
      });

      testWidgets('should not be accessible when disabled', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.loading).thenReturn(true);

        // Act
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: OffActionButtons(viewModel: mockViewModel),
          ),
        );

        // Assert
        final saveButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        final clearButton = tester.widget<OutlinedButton>(
          find.byType(OutlinedButton),
        );

        expect(saveButton.onPressed, isNull);
        expect(clearButton.onPressed, isNull);
      });
    });
  });
}
