import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/features/store/view/widget/search_bar_widget.dart';
import 'package:arya/features/store/view_model/store_view_model.dart';
import 'package:arya/product/theme/app_colors.dart';

import 'search_bar_widget_test.mocks.dart';

@GenerateMocks([StoreViewModel])
void main() {
  group('SearchStoreBar Widget Tests', () {
    late MockStoreViewModel mockStoreViewModel;
    late ColorScheme colorScheme;
    late AppColors appColors;

    setUp(() {
      mockStoreViewModel = MockStoreViewModel();
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      appColors = AppColors.light;

      // Default mock setup
      when(mockStoreViewModel.search(any)).thenAnswer((_) async {});
      when(mockStoreViewModel.fetchRandomProducts()).thenAnswer((_) async {});
    });

    Widget createTestWidget({Widget? child}) {
      return MaterialApp(
        localizationsDelegates: const [
          // EasyLocalization için gerekli delegate'ler
        ],
        supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
        theme: ThemeData(colorScheme: colorScheme, extensions: [appColors]),
        home: ChangeNotifierProvider<StoreViewModel>.value(
          value: mockStoreViewModel,
          child: Scaffold(body: child ?? const SearchStoreBar()),
        ),
      );
    }

    group('Widget Rendering Tests', () {
      testWidgets('should render SearchStoreBar without crashing', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(SearchStoreBar), findsOneWidget);
        expect(find.byType(Container), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should render TextField with correct properties', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.controller, isNotNull);
        expect(textField.decoration?.filled, isTrue);
        expect(textField.decoration?.suffixIcon, isNotNull);
      });

      testWidgets('should render search icon button', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byIcon(Icons.search), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('should have correct container decoration', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(18));
        expect(decoration.color, colorScheme.surface);
      });

      testWidgets('should have correct TextField decoration', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        final decoration = textField.decoration!;

        expect(decoration.filled, isTrue);
        expect(decoration.fillColor, colorScheme.surface);
        expect(decoration.border, isA<OutlineInputBorder>());
        expect(decoration.focusedBorder, isA<OutlineInputBorder>());

        final border = decoration.border as OutlineInputBorder;
        final focusedBorder = decoration.focusedBorder as OutlineInputBorder;
        expect(border.borderRadius, BorderRadius.circular(18));
        expect(focusedBorder.borderRadius, BorderRadius.circular(18));
        expect(focusedBorder.borderSide.color, colorScheme.outline);
        expect(focusedBorder.borderSide.width, 2);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should allow text input in TextField', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.enterText(find.byType(TextField), 'test search');

        // Assert
        expect(find.text('test search'), findsOneWidget);
      });

      testWidgets(
        'should call search method when search button is pressed with text',
        (tester) async {
          // Act
          await tester.pumpWidget(createTestWidget());
          await tester.enterText(find.byType(TextField), 'test product');
          await tester.tap(find.byIcon(Icons.search));
          await tester.pump();

          // Assert
          verify(mockStoreViewModel.search('test product')).called(1);
          verifyNever(mockStoreViewModel.fetchRandomProducts());
        },
      );

      testWidgets(
        'should call fetchRandomProducts when search button is pressed with empty text',
        (tester) async {
          // Act
          await tester.pumpWidget(createTestWidget());
          await tester.tap(find.byIcon(Icons.search));
          await tester.pump();

          // Assert
          verify(mockStoreViewModel.fetchRandomProducts()).called(1);
          verifyNever(mockStoreViewModel.search(any));
        },
      );

      testWidgets(
        'should call fetchRandomProducts when search button is pressed with whitespace only',
        (tester) async {
          // Act
          await tester.pumpWidget(createTestWidget());
          await tester.enterText(find.byType(TextField), '   ');
          await tester.tap(find.byIcon(Icons.search));
          await tester.pump();

          // Assert
          verify(mockStoreViewModel.fetchRandomProducts()).called(1);
          verifyNever(mockStoreViewModel.search(any));
        },
      );

      testWidgets('should trim whitespace from search query', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.enterText(find.byType(TextField), '  test product  ');
        await tester.tap(find.byIcon(Icons.search));
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.search('test product')).called(1);
      });
    });

    group('Edge Cases and Error Handling', () {
      testWidgets('should handle very long search text', (tester) async {
        // Arrange
        final longText = 'a' * 1000;

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.enterText(find.byType(TextField), longText);
        await tester.tap(find.byIcon(Icons.search));
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.search(longText)).called(1);
      });

      testWidgets('should handle special characters in search', (tester) async {
        // Arrange
        const specialText = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.enterText(find.byType(TextField), specialText);
        await tester.tap(find.byIcon(Icons.search));
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.search(specialText)).called(1);
      });

      testWidgets('should handle unicode characters in search', (tester) async {
        // Arrange
        const unicodeText = 'çğıöşüÇĞIÖŞÜ';

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.enterText(find.byType(TextField), unicodeText);
        await tester.tap(find.byIcon(Icons.search));
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.search(unicodeText)).called(1);
      });

      testWidgets('should handle multiple rapid button presses', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.enterText(find.byType(TextField), 'test');

        // Multiple rapid taps
        await tester.tap(find.byIcon(Icons.search));
        await tester.tap(find.byIcon(Icons.search));
        await tester.tap(find.byIcon(Icons.search));
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.search('test')).called(3);
      });
    });

    group('State Management Tests', () {
      testWidgets('should maintain text state during widget rebuilds', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.enterText(find.byType(TextField), 'persistent text');

        // Rebuild widget
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Assert
        expect(find.text('persistent text'), findsOneWidget);
      });

      testWidgets('should clear text when widget is disposed and recreated', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.enterText(find.byType(TextField), 'temporary text');

        // Dispose and recreate
        await tester.pumpWidget(Container());
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.text('temporary text'), findsNothing);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic properties', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(TextField), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);

        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.decoration?.hintText, isNotNull);
      });

      testWidgets('should be focusable and tappable', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Focus on TextField
        await tester.tap(find.byType(TextField));
        await tester.pump();

        // Tap search button
        await tester.tap(find.byIcon(Icons.search));
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.fetchRandomProducts()).called(1);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('should use correct colors from theme', (tester) async {
        // Arrange
        final customColorScheme = ColorScheme.fromSeed(seedColor: Colors.red);
        final customAppColors = AppColors.dark;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: customColorScheme,
              extensions: [customAppColors],
            ),
            home: ChangeNotifierProvider<StoreViewModel>.value(
              value: mockStoreViewModel,
              child: const Scaffold(body: SearchStoreBar()),
            ),
          ),
        );

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.color, customColorScheme.surface);
      });

      testWidgets('should adapt to different text themes', (tester) async {
        // Arrange
        final customTheme = ThemeData(
          colorScheme: colorScheme,
          extensions: [appColors],
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            theme: customTheme,
            home: ChangeNotifierProvider<StoreViewModel>.value(
              value: mockStoreViewModel,
              child: const Scaffold(body: SearchStoreBar()),
            ),
          ),
        );

        // Assert
        final textField = tester.widget<TextField>(find.byType(TextField));
        expect(textField.style?.fontSize, 16);
        expect(textField.style?.fontWeight, FontWeight.bold);
      });
    });

    group('Performance Tests', () {
      testWidgets('should handle rapid text changes efficiently', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Rapid text changes
        for (int i = 0; i < 10; i++) {
          await tester.enterText(find.byType(TextField), 'text $i');
          await tester.pump();
        }

        // Final search
        await tester.tap(find.byIcon(Icons.search));
        await tester.pump();

        // Assert
        verify(mockStoreViewModel.search('text 9')).called(1);
      });
    });
  });
}
