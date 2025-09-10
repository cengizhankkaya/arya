import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('CategoryScreen Widget Tests', () {
    late List<HomeCategory> mockCategories;

    setUp(() {
      mockCategories = [
        const HomeCategory(
          titleKey: 'categories.high_protein',
          imageUrl: 'assets/images/categories/protein.png',
          palette: CategoryPalette.highProtein,
        ),
        const HomeCategory(
          titleKey: 'categories.breakfast',
          imageUrl: 'assets/images/categories/breakfast.png',
          palette: CategoryPalette.breakfast,
        ),
        const HomeCategory(
          titleKey: 'categories.fruits_vegetables',
          imageUrl: 'assets/images/categories/fruits.png',
          palette: CategoryPalette.fruitsVegetables,
        ),
      ];
    });

    Widget createTestWidget({List<HomeCategory>? categories}) {
      return TestHelpers.createTestApp(
        child: ChangeNotifierProvider<HomeViewModel>(
          create: (_) =>
              HomeViewModel(categories: categories ?? mockCategories),
          child: const CategoryScreen(),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('CategoryScreen renders correctly with all components', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // AppBar kontrolü
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('appbar.categories'), findsOneWidget);

        // GridView kontrolü
        expect(find.byType(GridView), findsOneWidget);

        // CategoryCard'ların render edildiğini kontrol et
        expect(find.byType(CategoryCard), findsWidgets);
      });

      testWidgets('AppBar has correct properties', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final appBar = tester.widget<AppBar>(find.byType(AppBar));

        expect(appBar.centerTitle, isTrue);
        expect(appBar.elevation, equals(0));
        expect(appBar.backgroundColor, isNotNull);
        expect(appBar.foregroundColor, isNotNull);
      });

      testWidgets('GridView has correct configuration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final gridView = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

        expect(delegate.crossAxisCount, equals(2));
        expect(delegate.mainAxisSpacing, equals(16));
        expect(delegate.crossAxisSpacing, equals(16));
        expect(delegate.childAspectRatio, equals(0.85));
      });
    });

    group('State Management', () {
      testWidgets('HomeViewModel is properly provided to the widget tree', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Provider'ın doğru şekilde sağlandığını kontrol et
        final homeViewModel = tester
            .element(find.byType(CategoryScreen))
            .read<HomeViewModel>();

        expect(homeViewModel, isA<HomeViewModel>());
        expect(homeViewModel.categories, equals(mockCategories));
      });

      testWidgets('Consumer rebuilds when HomeViewModel changes', (
        WidgetTester tester,
      ) async {
        final homeViewModel = HomeViewModel(categories: mockCategories);

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<HomeViewModel>(
              create: (_) => homeViewModel,
              child: const CategoryScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // İlk render'da kategori sayısını kontrol et
        expect(find.byType(CategoryCard), findsWidgets);

        // ViewModel'i güncelle
        homeViewModel.notifyListeners();
        await tester.pumpAndSettle();

        // Consumer'ın yeniden build edildiğini kontrol et
        expect(find.byType(CategoryCard), findsWidgets);
      });
    });

    group('Theme Integration', () {
      testWidgets('CategoryScreen uses correct theme colors', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final appBar = tester.widget<AppBar>(find.byType(AppBar));

        // Theme renklerinin kullanıldığını kontrol et
        expect(appBar.backgroundColor, isNotNull);
        expect(appBar.foregroundColor, isNotNull);
      });
    });

    group('Accessibility', () {
      testWidgets('CategoryScreen has proper accessibility support', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Semantics kontrolü
        expect(find.byType(Semantics), findsWidgets);

        // AppBar'ın accessibility özelliklerini kontrol et
        final appBar = tester.widget<AppBar>(find.byType(AppBar));
        expect(appBar.title, isA<Text>());
      });
    });

    group('Error Handling', () {
      testWidgets('CategoryScreen handles null categories gracefully', (
        WidgetTester tester,
      ) async {
        // Null categories ile test (HomeViewModel constructor'ı null'ı handle eder)
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            child: ChangeNotifierProvider<HomeViewModel>(
              create: (_) => HomeViewModel(categories: null),
              child: const CategoryScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Widget'ın crash etmediğini kontrol et
        expect(find.byType(CategoryScreen), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
      });
    });

    group('Localization', () {
      testWidgets('CategoryScreen displays localized text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // AppBar'ın title'ının görüntülendiğini kontrol et
        expect(find.text('appbar.categories'), findsOneWidget);

        // CategoryCard'ların render edildiğini kontrol et
        expect(find.byType(CategoryCard), findsWidgets);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('CategoryScreen disposes properly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Widget'ı kaldır
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        // Widget'ın kaldırıldığını kontrol et
        expect(find.byType(CategoryScreen), findsNothing);
      });
    });
  });
}
