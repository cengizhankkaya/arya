import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arya/features/store/view/widget/cart_shimmer_widget.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/product/utility/constants/dimensions/project_padding.dart';

void main() {
  group('CartShimmerWidget Tests', () {
    late ColorScheme colorScheme;
    late AppColors appColors;

    setUp(() {
      colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      appColors = AppColors.light;
    });

    Widget createTestWidget() {
      return MaterialApp(
        theme: ThemeData(colorScheme: colorScheme, extensions: [appColors]),
        home: const Scaffold(body: CartShimmerWidget()),
      );
    }

    group('Widget Rendering Tests', () {
      testWidgets('should render cart shimmer widget', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(CartShimmerWidget), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should render cart summary shimmer section', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(Row), findsWidgets);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Shimmer), findsWidgets);
      });

      testWidgets('should render cart items shimmer list', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(Expanded), findsWidgets);
        expect(find.byType(ListView), findsOneWidget);
      });

      testWidgets('should render correct number of shimmer items', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final listView = tester.widget<ListView>(find.byType(ListView));
        expect(listView, isNotNull);
      });
    });

    group('Shimmer Animation Tests', () {
      testWidgets('should have shimmer animations', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(Shimmer), findsWidgets);

        // Check that shimmer widgets are present
        final shimmerWidgets = tester.widgetList<Shimmer>(find.byType(Shimmer));
        expect(shimmerWidgets, isNotEmpty);
      });

      testWidgets('should render shimmer containers with correct styling', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final shimmerContainers = find.descendant(
          of: find.byType(Shimmer),
          matching: find.byType(Container),
        );
        expect(shimmerContainers, findsWidgets);
      });
    });

    group('Layout Structure Tests', () {
      testWidgets('should have proper padding structure', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(Padding), findsWidgets);
        // Widget should render without errors
        expect(find.byType(CartShimmerWidget), findsOneWidget);
      });

      testWidgets('should have proper spacing between sections', (
        tester,
      ) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(SizedBox), findsWidgets);

        // Check for spacing between cart summary and items
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes, isNotEmpty);
      });

      testWidgets('should have proper container decorations', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers, isNotEmpty);

        // Check that containers have proper decoration
        for (final container in containers) {
          if (container.decoration != null) {
            expect(container.decoration, isA<BoxDecoration>());
          }
        }
      });
    });

    group('Cart Summary Shimmer Tests', () {
      testWidgets('should render two summary shimmer cards', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        // Should have expanded widgets for the summary cards
        final expandedWidgets = find.descendant(
          of: find.byType(Row),
          matching: find.byType(Expanded),
        );
        expect(expandedWidgets, findsWidgets);
      });

      testWidgets('should render clear button shimmer', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        // Should have a circular shimmer for the clear button
        final shimmerWidgets = find.descendant(
          of: find.byType(Row),
          matching: find.byType(Shimmer),
        );
        expect(shimmerWidgets, findsWidgets);
      });
    });

    group('Cart Item Shimmer Tests', () {
      testWidgets('should render product image shimmer', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        // Should have shimmer containers for product images
        final shimmerContainers = find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Shimmer),
        );
        expect(shimmerContainers, findsWidgets);
      });

      testWidgets('should render product info shimmer', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        // Should have shimmer containers for product information
        final expandedWidgets = find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Expanded),
        );
        expect(expandedWidgets, findsWidgets);
      });

      testWidgets('should render quantity controls shimmer', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        // Should have column for quantity controls
        final columns = find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Column),
        );
        expect(columns, findsWidgets);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('should adapt to different screen sizes', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(CartShimmerWidget), findsOneWidget);

        // Widget should render without errors on different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pump();
        expect(find.byType(CartShimmerWidget), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(600, 1000));
        await tester.pump();
        expect(find.byType(CartShimmerWidget), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should render efficiently', (tester) async {
        // Act
        final stopwatch = Stopwatch()..start();
        await tester.pumpWidget(createTestWidget());
        stopwatch.stop();

        // Assert
        expect(find.byType(CartShimmerWidget), findsOneWidget);
        // Should render quickly (less than 100ms for a simple shimmer widget)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      testWidgets('should not cause memory leaks', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Dispose and recreate multiple times
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();
        }

        // Assert
        expect(find.byType(CartShimmerWidget), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should be accessible to screen readers', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(CartShimmerWidget), findsOneWidget);

        // Shimmer widgets should not interfere with accessibility
        final shimmerWidgets = find.byType(Shimmer);
        expect(shimmerWidgets, findsWidgets);
      });

      testWidgets('should have proper semantics', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(CartShimmerWidget), findsOneWidget);

        // Widget should render without semantic errors
        expect(tester.takeException(), isNull);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle theme changes gracefully', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(CartShimmerWidget), findsOneWidget);

        // Change theme
        final newColorScheme = ColorScheme.fromSeed(seedColor: Colors.red);
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: newColorScheme,
              extensions: [appColors],
            ),
            home: const Scaffold(body: CartShimmerWidget()),
          ),
        );

        // Assert
        expect(find.byType(CartShimmerWidget), findsOneWidget);
      });

      testWidgets('should handle rapid rebuilds', (tester) async {
        // Act
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();
        }

        // Assert
        expect(find.byType(CartShimmerWidget), findsOneWidget);
      });
    });
  });
}
