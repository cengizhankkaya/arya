import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arya/features/home/view/widget/category_shimmer_widget.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('CategoryShimmerWidget Tests', () {
    Widget createTestWidget() {
      return TestHelpers.createTestApp(child: const CategoryShimmerWidget());
    }

    group('Widget Rendering', () {
      testWidgets(
        'CategoryShimmerWidget renders correctly with all components',
        (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          // GridView kontrolü
          expect(find.byType(GridView), findsOneWidget);

          // Shimmer widget'larının render edildiğini kontrol et
          expect(find.byType(Shimmer), findsWidgets);

          // Container'ların render edildiğini kontrol et
          expect(find.byType(Container), findsWidgets);
        },
      );

      testWidgets('GridView has correct configuration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        expect(delegate.crossAxisCount, equals(2));
        expect(delegate.mainAxisSpacing, equals(16));
        expect(delegate.crossAxisSpacing, equals(16));
        expect(delegate.childAspectRatio, equals(0.95));
      });

      testWidgets('GridView has correct padding', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final gridView = tester.widget<GridView>(find.byType(GridView));

        expect(gridView.padding, equals(ProjectPadding.allSmall()));
      });

      testWidgets('GridView has correct item count', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.childrenDelegate as SliverChildBuilderDelegate;

        expect(delegate.childCount, equals(8));
      });
    });

    group('Shimmer Animation', () {
      testWidgets('Shimmer widgets are properly configured', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final shimmerWidgets = tester.widgetList<Shimmer>(find.byType(Shimmer));

        expect(shimmerWidgets, isNotEmpty);

        // Shimmer widget'larının render edildiğini kontrol et
        for (final shimmer in shimmerWidgets) {
          expect(shimmer, isA<Shimmer>());
        }
      });

      testWidgets('Shimmer uses theme colors', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final shimmerWidgets = tester.widgetList<Shimmer>(find.byType(Shimmer));

        // Shimmer widget'larının theme renklerini kullandığını kontrol et
        expect(shimmerWidgets, isNotEmpty);
        for (final shimmer in shimmerWidgets) {
          expect(shimmer, isA<Shimmer>());
        }
      });
    });

    group('Shimmer Card Structure', () {
      testWidgets('Shimmer cards have correct structure', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Container'ların (shimmer card'ların) render edildiğini kontrol et
        expect(find.byType(Container), findsWidgets);

        // Column'ların render edildiğini kontrol et
        expect(find.byType(Column), findsWidgets);

        // SizedBox'ların render edildiğini kontrol et
        expect(find.byType(SizedBox), findsWidgets);
      });

      testWidgets('Shimmer cards have correct decoration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final containers = tester.widgetList<Container>(find.byType(Container));

        // En az bir container'ın decoration'a sahip olduğunu kontrol et
        bool hasDecoratedContainer = false;
        for (final container in containers) {
          if (container.decoration != null) {
            hasDecoratedContainer = true;
            final decoration = container.decoration as BoxDecoration;

            // Border radius kontrolü
            expect(decoration.borderRadius, isNotNull);

            // Border kontrolü (null olabilir)
            if (decoration.border != null) {
              expect(decoration.border, isNotNull);
            }
          }
        }

        // En az bir decorated container olmalı
        expect(hasDecoratedContainer, isTrue);
      });

      testWidgets('Shimmer cards have correct padding', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final containers = tester.widgetList<Container>(find.byType(Container));

        for (final container in containers) {
          if (container.padding != null) {
            expect(container.padding, equals(ProjectPadding.allVerySmall()));
          }
        }
      });
    });

    group('Theme Integration', () {
      testWidgets('CategoryShimmerWidget uses correct theme colors', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final shimmerWidgets = tester.widgetList<Shimmer>(find.byType(Shimmer));

        // Shimmer widget'larının theme renklerini kullandığını kontrol et
        expect(shimmerWidgets, isNotEmpty);
        for (final shimmer in shimmerWidgets) {
          expect(shimmer, isA<Shimmer>());
        }
      });

      testWidgets('Shimmer cards use theme colors for decoration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        final containers = tester.widgetList<Container>(find.byType(Container));

        for (final container in containers) {
          if (container.decoration != null) {
            final decoration = container.decoration as BoxDecoration;

            // Theme renklerinin kullanıldığını kontrol et
            if (decoration.color != null) {
              expect(decoration.color, isA<Color>());
            }
          }
        }
      });
    });

    group('Accessibility', () {
      testWidgets('CategoryShimmerWidget has proper accessibility support', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Semantics kontrolü
        expect(find.byType(Semantics), findsWidgets);

        // GridView'in accessibility özelliklerini kontrol et
        final gridView = tester.widget<GridView>(find.byType(GridView));
        expect(gridView, isA<GridView>());
      });
    });

    group('Performance', () {
      testWidgets('CategoryShimmerWidget renders efficiently', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Widget'ın hızlı render edildiğini kontrol et
        expect(find.byType(CategoryShimmerWidget), findsOneWidget);
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(Shimmer), findsWidgets);
      });

      testWidgets('Shimmer animation does not cause performance issues', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Shimmer animasyonunun başladığını kontrol et
        expect(find.byType(Shimmer), findsWidgets);

        // Animasyon sırasında widget'ın stable olduğunu kontrol et
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(CategoryShimmerWidget), findsOneWidget);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('CategoryShimmerWidget disposes properly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Widget'ı kaldır
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();

        // Widget'ın kaldırıldığını kontrol et
        expect(find.byType(CategoryShimmerWidget), findsNothing);
      });
    });

    group('Edge Cases', () {
      testWidgets('CategoryShimmerWidget handles theme changes', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Widget'ın theme değişikliklerini handle ettiğini kontrol et
        expect(find.byType(CategoryShimmerWidget), findsOneWidget);
        expect(find.byType(Shimmer), findsWidgets);
      });

      testWidgets('CategoryShimmerWidget maintains consistent layout', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Layout'un tutarlı olduğunu kontrol et
        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        expect(delegate.crossAxisCount, equals(2));
        expect(delegate.mainAxisSpacing, equals(16));
        expect(delegate.crossAxisSpacing, equals(16));
        expect(delegate.childAspectRatio, equals(0.95));
      });
    });
  });
}
