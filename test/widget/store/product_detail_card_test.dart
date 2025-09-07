import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/store/view/widget/product_detail_detail_card.dart';
import 'package:arya/product/theme/app_colors.dart';

void main() {
  group('ProductDetailCard', () {
    late ColorScheme colorScheme;
    late AppColors appColors;

    setUp(() {
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      appColors = AppColors.light;
    });

    Widget createTestWidget({
      required ColorScheme scheme,
      required String titleKey,
      required IconData icon,
      required Widget child,
      bool showDisclaimer = true,
    }) {
      return MaterialApp(
        theme: ThemeData(colorScheme: colorScheme, extensions: [appColors]),
        home: Scaffold(
          body: ProductDetailCard(
            scheme: scheme,
            titleKey: titleKey,
            icon: icon,
            child: child,
            showDisclaimer: showDisclaimer,
          ),
        ),
      );
    }

    testWidgets('widget temel yapısı doğru oluşturulmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(Container), findsAtLeastNWidgets(2));
      expect(find.byType(Column), findsAtLeastNWidgets(1));
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsAtLeastNWidgets(2));
    });

    testWidgets('ana container doğru padding almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final mainContainer = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(mainContainer.padding, const EdgeInsets.all(20));
    });

    testWidgets('ana container gradient decoration almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final mainContainer = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(mainContainer.decoration, isA<BoxDecoration>());
      final decoration = mainContainer.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets('gradient doğru renkler almalı', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final mainContainer = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = mainContainer.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;

      expect(gradient.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);
      expect(gradient.colors.length, 2);
      expect(gradient.colors[0], colorScheme.surfaceContainerHighest);
      expect(gradient.colors[1], colorScheme.surface);
    });

    testWidgets('Column crossAxisAlignment start olmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('header Row doğru yapıda olmalı', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final row = tester.widget<Row>(find.byType(Row));
      expect(row.children.length, 3); // Icon container, SizedBox, Text
    });

    testWidgets('icon container doğru özellikler almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final containers = tester.widgetList<Container>(find.byType(Container));
      final iconContainer = containers.firstWhere(
        (container) => container.padding == const EdgeInsets.all(8),
      );

      expect(iconContainer.padding, const EdgeInsets.all(8));
      expect(iconContainer.decoration, isA<BoxDecoration>());

      final decoration = iconContainer.decoration as BoxDecoration;
      expect(decoration.color, colorScheme.primaryContainer);
      expect(decoration.borderRadius, isA<BorderRadius>());
    });

    testWidgets('icon doğru özellikler almalı', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.monitor_heart_outlined);
      expect(icon.color, colorScheme.onPrimaryContainer);
      expect(icon.size, 20);
    });

    testWidgets('title text doğru özellikler almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final texts = tester.widgetList<Text>(find.byType(Text));
      final titleText = texts.firstWhere(
        (text) => text.data == 'detail.nutrition_facts',
      );

      expect(titleText.data, 'detail.nutrition_facts');
      expect(titleText.style, isNotNull);
    });

    testWidgets('SizedBox spacing doğru olmalı', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));

      // Header'daki SizedBox (width: 12)
      final headerSizedBox = sizedBoxes.firstWhere((box) => box.width == 12.0);
      expect(headerSizedBox.width, 12.0);

      // Header ile child arasındaki SizedBox (height: 16)
      final spacingSizedBox = sizedBoxes.firstWhere(
        (box) => box.height == 16.0,
      );
      expect(spacingSizedBox.height, 16.0);
    });

    testWidgets('child widget doğru gösterilmeli', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Child Widget'), findsOneWidget);
    });

    testWidgets('disclaimer gösterilmeli (showDisclaimer true)', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
          showDisclaimer: true,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('detail.data_disclaimer'), findsOneWidget);
    });

    testWidgets('disclaimer gösterilmemeli (showDisclaimer false)', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
          showDisclaimer: false,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('detail.data_disclaimer'), findsNothing);
    });

    testWidgets('farklı icon ile çalışmalı', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.ingredients',
          icon: Icons.eco,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.eco);
    });

    testWidgets('farklı title key ile çalışmalı', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.ingredients',
          icon: Icons.eco,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('detail.ingredients'), findsOneWidget);
    });

    testWidgets('karmaşık child widget ile çalışmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      final complexChild = Column(
        children: [
          const Text('First Child'),
          const SizedBox(height: 8),
          const Text('Second Child'),
          Row(
            children: [
              const Icon(Icons.star),
              const SizedBox(width: 4),
              const Text('Rating'),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: complexChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('First Child'), findsOneWidget);
      expect(find.text('Second Child'), findsOneWidget);
      expect(find.text('Rating'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('border radius doğru olmalı', (WidgetTester tester) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final mainContainer = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = mainContainer.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;

      // ProjectRadius.xxLarge değerini kontrol et
      expect(borderRadius, isNotNull);
    });

    testWidgets('icon container border radius doğru olmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final containers = tester.widgetList<Container>(find.byType(Container));
      final iconContainer = containers.firstWhere(
        (container) => container.padding == const EdgeInsets.all(8),
      );

      final decoration = iconContainer.decoration as BoxDecoration;
      final borderRadius = decoration.borderRadius as BorderRadius;

      expect(borderRadius, isNotNull);
    });

    testWidgets('text style doğru özellikler almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final texts = tester.widgetList<Text>(find.byType(Text));
      final titleText = texts.firstWhere(
        (text) => text.data == 'detail.nutrition_facts',
      );

      expect(titleText.style, isNotNull);
      expect(titleText.style?.fontWeight, isNotNull);
      expect(titleText.style?.color, colorScheme.onSurface);
    });

    testWidgets('disclaimer text style doğru özellikler almalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
          showDisclaimer: true,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final texts = tester.widgetList<Text>(find.byType(Text));
      final disclaimerText = texts.firstWhere(
        (text) => text.data == 'detail.data_disclaimer',
      );

      expect(disclaimerText.style, isNotNull);
      expect(disclaimerText.style?.color, colorScheme.onSurfaceVariant);
      expect(disclaimerText.style?.fontWeight, isNotNull);
    });

    testWidgets('widget yükseklik ve genişlik doğru olmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      const testChild = Text('Test Child Widget');
      await tester.pumpWidget(
        createTestWidget(
          scheme: colorScheme,
          titleKey: 'detail.nutrition_facts',
          icon: Icons.monitor_heart_outlined,
          child: testChild,
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      final mainContainer = tester.widget<Container>(
        find.byType(Container).first,
      );

      // Container'ın boyutları null olmamalı (intrinsic size almalı)
      expect(mainContainer.constraints, isNull);
    });

    testWidgets('multiple ProductDetailCard aynı anda çalışmalı', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: colorScheme, extensions: [appColors]),
          home: Scaffold(
            body: Column(
              children: [
                ProductDetailCard(
                  scheme: colorScheme,
                  titleKey: 'detail.nutrition_facts',
                  icon: Icons.monitor_heart_outlined,
                  child: const Text('Nutrition Data'),
                ),
                const SizedBox(height: 16),
                ProductDetailCard(
                  scheme: colorScheme,
                  titleKey: 'detail.ingredients',
                  icon: Icons.eco,
                  child: const Text('Ingredients Data'),
                  showDisclaimer: false,
                ),
              ],
            ),
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('detail.nutrition_facts'), findsOneWidget);
      expect(find.text('detail.ingredients'), findsOneWidget);
      expect(find.text('Nutrition Data'), findsOneWidget);
      expect(find.text('Ingredients Data'), findsOneWidget);
      expect(
        find.text('detail.data_disclaimer'),
        findsOneWidget,
      ); // Sadece ilkinde
      expect(find.byIcon(Icons.monitor_heart_outlined), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsOneWidget);
    });
  });
}
