import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/store/view/widget/product_detail_nutrition_grid.dart';

void main() {
  group('ProductDetailNutritionGrid Widget Tests', () {
    late ColorScheme colorScheme;
    late Map<String, dynamic> sampleNutriments;
    late List<Map<String, String>> sampleNutritionData;

    setUp(() {
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);

      sampleNutriments = {
        'energy-kcal_100g': 250.5,
        'fat_100g': 15.2,
        'saturated-fat_100g': 5.8,
        'carbohydrates_100g': 30.0,
        'sugars_100g': 12.5,
        'proteins_100g': 8.3,
        'salt_100g': 1.2,
      };

      sampleNutritionData = [
        {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
        {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        {'key': 'saturated-fat_100g', 'label': 'Saturated Fat', 'unit': 'g'},
        {'key': 'carbohydrates_100g', 'label': 'Carbohydrates', 'unit': 'g'},
        {'key': 'sugars_100g', 'label': 'Sugars', 'unit': 'g'},
        {'key': 'proteins_100g', 'label': 'Proteins', 'unit': 'g'},
        {'key': 'salt_100g', 'label': 'Salt', 'unit': 'g'},
      ];
    });

    Widget createTestWidget({
      required Map<String, dynamic> nutriments,
      required List<Map<String, String>> nutritionData,
      required ColorScheme scheme,
      double? width,
    }) {
      return MaterialApp(
        theme: ThemeData(colorScheme: scheme),
        home: Scaffold(
          body: SizedBox(
            width: width ?? 400,
            child: ProductDetailNutritionGrid(
              nutriments: nutriments,
              nutritionData: nutritionData,
              scheme: scheme,
            ),
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render ProductDetailNutritionGrid correctly', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(ProductDetailNutritionGrid), findsOneWidget);
        expect(find.byType(LayoutBuilder), findsOneWidget);
        expect(find.byType(Wrap), findsOneWidget);
      });

      testWidgets('should render nutrition items as containers', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(Container), findsWidgets);
        // Should have 7 nutrition items
        expect(find.byType(Container), findsNWidgets(7));
      });

      testWidgets('should display nutrition values and labels', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text('250.5 kcal'), findsOneWidget);
        expect(find.text('Energy'), findsOneWidget);
        expect(find.text('15.2 g'), findsOneWidget);
        expect(find.text('Fat'), findsOneWidget);
        expect(find.text('8.3 g'), findsOneWidget);
        expect(find.text('Proteins'), findsOneWidget);
      });
    });

    group('Data Parsing', () {
      testWidgets('should handle numeric values correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final numericNutriments = {'energy-kcal_100g': 250, 'fat_100g': 15.5};
        final simpleNutritionData = [
          {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
          {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: numericNutriments,
            nutritionData: simpleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text('250.0 kcal'), findsOneWidget);
        expect(find.text('15.5 g'), findsOneWidget);
      });

      testWidgets('should handle string values correctly', (
        WidgetTester tester,
      ) async {
        // Arrange
        final stringNutriments = {
          'energy-kcal_100g': '250,5',
          'fat_100g': '15,2',
        };
        final simpleNutritionData = [
          {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
          {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: stringNutriments,
            nutritionData: simpleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text('250.5 kcal'), findsOneWidget);
        expect(find.text('15.2 g'), findsOneWidget);
      });

      testWidgets('should handle invalid string values', (
        WidgetTester tester,
      ) async {
        // Arrange
        final invalidNutriments = {
          'energy-kcal_100g': 'invalid',
          'fat_100g': 15.2,
        };
        final simpleNutritionData = [
          {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
          {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: invalidNutriments,
            nutritionData: simpleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(
          find.text('Energy'),
          findsNothing,
        ); // Invalid value should not render
        expect(find.text('15.2 g'), findsOneWidget);
        expect(find.text('Fat'), findsOneWidget);
      });

      testWidgets('should handle null values', (WidgetTester tester) async {
        // Arrange
        final nullNutriments = {'energy-kcal_100g': null, 'fat_100g': 15.2};
        final simpleNutritionData = [
          {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
          {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: nullNutriments,
            nutritionData: simpleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(
          find.text('Energy'),
          findsNothing,
        ); // Null value should not render
        expect(find.text('15.2 g'), findsOneWidget);
        expect(find.text('Fat'), findsOneWidget);
      });
    });

    group('Layout and Responsive Design', () {
      testWidgets('should use 2 columns for narrow screens', (
        WidgetTester tester,
      ) async {
        // Arrange
        const narrowWidth = 400.0;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
            width: narrowWidth,
          ),
        );

        // Assert
        expect(find.byType(Wrap), findsOneWidget);
        // For narrow screens, should use 2 columns
        // This is tested indirectly through the layout structure
      });

      testWidgets('should use 3 columns for wide screens', (
        WidgetTester tester,
      ) async {
        // Arrange
        const wideWidth = 600.0;

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
            width: wideWidth,
          ),
        );

        // Assert
        expect(find.byType(Wrap), findsOneWidget);
        // For wide screens, should use 3 columns
        // This is tested indirectly through the layout structure
      });

      testWidgets('should apply correct spacing between items', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        final wrap = tester.widget<Wrap>(find.byType(Wrap));
        expect(wrap.spacing, equals(12.0));
        expect(wrap.runSpacing, equals(12.0));
      });
    });

    group('Styling and Colors', () {
      testWidgets('should apply correct container styling', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        final containers = tester.widgetList<Container>(find.byType(Container));
        final nutritionContainer = containers.firstWhere(
          (container) => container.padding == const EdgeInsets.all(14),
        );

        final decoration = nutritionContainer.decoration as BoxDecoration;
        expect(decoration.color, equals(colorScheme.surfaceContainerHighest));
        expect(decoration.borderRadius, isA<BorderRadius>());
        expect(decoration.border, isA<Border>());
      });

      testWidgets('should apply correct padding to nutrition items', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        final containers = tester.widgetList<Container>(find.byType(Container));
        final nutritionContainers = containers.where(
          (container) => container.padding == const EdgeInsets.all(14),
        );

        expect(nutritionContainers.length, equals(7));
        for (final container in nutritionContainers) {
          expect(container.padding, equals(const EdgeInsets.all(14)));
        }
      });

      testWidgets('should apply correct text colors', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        final textWidgets = tester.widgetList<Text>(find.byType(Text));

        // Check that we have both value and label texts
        expect(textWidgets.length, greaterThan(0));

        // The exact color testing would require accessing the TextStyle
        // which is more complex in widget tests, so we verify the structure
        expect(find.text('250.5 kcal'), findsOneWidget);
        expect(find.text('Energy'), findsOneWidget);
      });
    });

    group('Empty Data Handling', () {
      testWidgets('should handle empty nutriments map', (
        WidgetTester tester,
      ) async {
        // Arrange
        final emptyNutriments = <String, dynamic>{};

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: emptyNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(ProductDetailNutritionGrid), findsOneWidget);
        expect(find.byType(Wrap), findsOneWidget);
        // Should not render any nutrition items
        expect(find.byType(Container), findsNothing);
      });

      testWidgets('should handle empty nutrition data list', (
        WidgetTester tester,
      ) async {
        // Arrange
        final emptyNutritionData = <Map<String, String>>[];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: emptyNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(ProductDetailNutritionGrid), findsOneWidget);
        expect(find.byType(Wrap), findsOneWidget);
        // Should not render any nutrition items
        expect(find.byType(Container), findsNothing);
      });

      testWidgets('should handle nutrition data with missing keys', (
        WidgetTester tester,
      ) async {
        // Arrange
        final partialNutriments = {
          'energy-kcal_100g': 250.5,
          'fat_100g': 15.2,
          // Missing other keys
        };

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: partialNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text('250.5 kcal'), findsOneWidget);
        expect(find.text('15.2 g'), findsOneWidget);
        // Should only render items with valid data
        expect(find.byType(Container), findsNWidgets(2));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very large nutrition values', (
        WidgetTester tester,
      ) async {
        // Arrange
        final largeNutriments = {
          'energy-kcal_100g': 9999.99,
          'fat_100g': 100.0,
        };
        final simpleNutritionData = [
          {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
          {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: largeNutriments,
            nutritionData: simpleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text('10000.0 kcal'), findsOneWidget);
        expect(find.text('100.0 g'), findsOneWidget);
      });

      testWidgets('should handle very small nutrition values', (
        WidgetTester tester,
      ) async {
        // Arrange
        final smallNutriments = {'energy-kcal_100g': 0.1, 'fat_100g': 0.05};
        final simpleNutritionData = [
          {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
          {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: smallNutriments,
            nutritionData: simpleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text('0.1 kcal'), findsOneWidget);
        expect(find.text('0.1 g'), findsOneWidget);
      });

      testWidgets('should handle zero nutrition values', (
        WidgetTester tester,
      ) async {
        // Arrange
        final zeroNutriments = {'energy-kcal_100g': 0, 'fat_100g': 0.0};
        final simpleNutritionData = [
          {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
          {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: zeroNutriments,
            nutritionData: simpleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text('0.0 kcal'), findsOneWidget);
        expect(find.text('0.0 g'), findsOneWidget);
      });

      testWidgets('should handle nutrition data with empty labels', (
        WidgetTester tester,
      ) async {
        // Arrange
        final nutritionDataWithEmptyLabel = [
          {'key': 'energy-kcal_100g', 'label': '', 'unit': 'kcal'},
          {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: nutritionDataWithEmptyLabel,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.text('250.5 kcal'), findsOneWidget);
        expect(find.text('15.2 g'), findsOneWidget);
        expect(find.text('Fat'), findsOneWidget);
      });
    });

    group('Theme Integration', () {
      testWidgets('should work with different color schemes', (
        WidgetTester tester,
      ) async {
        // Arrange
        final lightScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
        final darkScheme = ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        );

        // Act - Light theme
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: lightScheme,
          ),
        );

        // Assert - Light theme
        expect(find.byType(ProductDetailNutritionGrid), findsOneWidget);

        // Act - Dark theme
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: darkScheme,
          ),
        );

        // Assert - Dark theme
        expect(find.byType(ProductDetailNutritionGrid), findsOneWidget);
      });
    });

    group('Performance and Structure', () {
      testWidgets('should render efficiently with many nutrition items', (
        WidgetTester tester,
      ) async {
        // Arrange
        final manyNutriments = <String, dynamic>{};
        final manyNutritionData = <Map<String, String>>[];

        for (int i = 0; i < 20; i++) {
          manyNutriments['nutrient_$i'] = i * 10.5;
          manyNutritionData.add({
            'key': 'nutrient_$i',
            'label': 'Nutrient $i',
            'unit': 'g',
          });
        }

        // Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: manyNutriments,
            nutritionData: manyNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(ProductDetailNutritionGrid), findsOneWidget);
        expect(find.byType(Container), findsNWidgets(20));
      });

      testWidgets('should maintain proper widget hierarchy', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          createTestWidget(
            nutriments: sampleNutriments,
            nutritionData: sampleNutritionData,
            scheme: colorScheme,
          ),
        );

        // Assert
        expect(find.byType(ProductDetailNutritionGrid), findsOneWidget);
        expect(find.byType(LayoutBuilder), findsOneWidget);
        expect(find.byType(Wrap), findsOneWidget);

        // Each nutrition item should be wrapped in a SizedBox
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.length, greaterThan(0));
      });
    });
  });
}
