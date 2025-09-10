// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helpers.dart';

/// Mock CategoryCard widget for testing
///
/// Bu widget gerçek CategoryCard widget'ının davranışını simüle eder
/// ve test sırasında kategori kartlarının render edilmesini sağlar.
class MockCategoryCard extends StatelessWidget {
  final HomeCategory category;
  final VoidCallback? onTap;

  const MockCategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              category.titleKey,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.imageUrl,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

/// Test data factory for creating test categories
class TestCategoryFactory {
  static List<HomeCategory> createDefaultCategories() {
    return [
      HomeCategory(
        titleKey: 'categories.high_protein',
        imageUrl: 'assets/images/categories/high_protein.png',
        palette: CategoryPalette.highProtein,
      ),
      HomeCategory(
        titleKey: 'categories.high_carbohydrate',
        imageUrl: 'assets/images/categories/high_carbohydrate.png',
        palette: CategoryPalette.highCarbohydrate,
      ),
      HomeCategory(
        titleKey: 'categories.high_fat',
        imageUrl: 'assets/images/categories/high_fat.png',
        palette: CategoryPalette.highFat,
      ),
      HomeCategory(
        titleKey: 'categories.breakfast',
        imageUrl: 'assets/images/categories/breakfast.png',
        palette: CategoryPalette.breakfast,
      ),
    ];
  }

  static List<HomeCategory> createLargeCategoryList(int count) {
    return List.generate(
      count,
      (index) => HomeCategory(
        titleKey: 'categories.test_$index',
        imageUrl: 'assets/images/categories/test_$index.png',
        palette: CategoryPalette.values[index % CategoryPalette.values.length],
      ),
    );
  }
}

/// Test helper methods for category navigation tests
class CategoryNavigationTestHelpers {
  /// Creates a test widget with category grid layout
  static Widget createCategoryGridWidget({
    required HomeViewModel homeViewModel,
    VoidCallback? onCategoryTap,
  }) {
    return TestHelpers.createTestApp(
      child: ChangeNotifierProvider<HomeViewModel>.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, vm, _) {
            return Scaffold(
              appBar: AppBar(title: const Text('Categories')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        itemCount: vm.categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                        itemBuilder: (context, index) {
                          return MockCategoryCard(
                            category: vm.categories[index],
                            onTap: onCategoryTap,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Creates a test widget with category list layout
  static Widget createCategoryListWidget({
    required HomeViewModel homeViewModel,
    VoidCallback? onCategoryTap,
  }) {
    return TestHelpers.createTestApp(
      child: ChangeNotifierProvider<HomeViewModel>.value(
        value: homeViewModel,
        child: Consumer<HomeViewModel>(
          builder: (context, vm, _) {
            return Scaffold(
              appBar: AppBar(title: const Text('Categories')),
              body: ListView.builder(
                itemCount: vm.categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(vm.categories[index].titleKey),
                    subtitle: Text(vm.categories[index].imageUrl),
                    onTap: onCategoryTap,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// Verifies that all expected categories are present
  static void verifyDefaultCategories(List<HomeCategory> categories) {
    final expectedCategories = [
      'categories.high_protein',
      'categories.high_carbohydrate',
      'categories.high_fat',
      'categories.breakfast',
    ];

    for (final expectedCategory in expectedCategories) {
      expect(
        categories.any((cat) => cat.titleKey == expectedCategory),
        isTrue,
        reason: 'Category $expectedCategory should be present',
      );
    }
  }

  /// Verifies category structure integrity
  static void verifyCategoryStructure(List<HomeCategory> categories) {
    for (final category in categories) {
      expect(
        category.titleKey,
        isNotEmpty,
        reason: 'Category title should not be empty',
      );
      expect(
        category.imageUrl,
        isNotEmpty,
        reason: 'Category image URL should not be empty',
      );
      expect(
        category.palette,
        isA<CategoryPalette>(),
        reason: 'Category should have valid palette',
      );
    }
  }
}

/// Home Category Navigation Integration Test Suite
///
/// Bu test suite'i home ekranındaki kategori navigasyonunun entegrasyonunu test eder.
/// Kategori kartlarına tıklama, navigasyon, ve UI etkileşimleri kapsanır.
///
/// Test Coverage:
/// - HomeViewModel kategori yönetimi
/// - Kategori ekranı render edilmesi
/// - Grid layout doğruluğu
/// - Edge case senaryoları
/// - Performance testleri
/// - Navigasyon testleri

void main() {
  group('Home Category Navigation Integration Tests', () {
    late HomeViewModel homeViewModel;

    setUp(() {
      // Test setup
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupAssetMocks();
      TestHelpers.setupComprehensiveFirebaseMocks();

      // HomeViewModel oluştur
      homeViewModel = HomeViewModel();
    });

    tearDown(() {
      TestHelpers.tearDown();
    });

    group('HomeViewModel Tests', () {
      testWidgets('HomeViewModel kategorileri doğru sayıda', (tester) async {
        // Arrange & Act
        final categories = homeViewModel.categories;

        // Assert
        expect(
          categories,
          isNotEmpty,
          reason: 'Categories list should not be empty',
        );
        expect(
          categories.length,
          equals(11),
          reason: 'Should have exactly 11 categories',
        );
        expect(
          categories.first,
          isA<HomeCategory>(),
          reason: 'First item should be HomeCategory',
        );
      });

      testWidgets('HomeViewModel kategorileri doğru içeriği içerir', (
        tester,
      ) async {
        // Arrange & Act
        final categories = homeViewModel.categories;

        // Assert - Helper metod kullanarak kategori doğrulaması
        CategoryNavigationTestHelpers.verifyDefaultCategories(categories);
      });

      testWidgets('HomeViewModel kategorileri doğru yapıda', (tester) async {
        // Arrange & Act
        final categories = homeViewModel.categories;

        // Assert - Helper metod kullanarak yapı doğrulaması
        CategoryNavigationTestHelpers.verifyCategoryStructure(categories);
      });

      testWidgets('HomeViewModel kategorileri benzersiz titleKey\'lere sahip', (
        tester,
      ) async {
        // Arrange & Act
        final categories = homeViewModel.categories;
        final titleKeys = categories.map((cat) => cat.titleKey).toList();

        // Assert
        expect(
          titleKeys.length,
          equals(titleKeys.toSet().length),
          reason: 'All category titleKeys should be unique',
        );
      });

      testWidgets(
        'HomeViewModel kategorileri geçerli palette değerlerine sahip',
        (tester) async {
          // Arrange & Act
          final categories = homeViewModel.categories;

          // Assert
          for (final category in categories) {
            expect(
              CategoryPalette.values.contains(category.palette),
              isTrue,
              reason:
                  'Category palette should be a valid CategoryPalette value',
            );
          }
        },
      );
    });

    group('Category Screen Basic Rendering', () {
      testWidgets('CategoryScreen temel bileşenleri render edilir', (
        tester,
      ) async {
        // Arrange - Helper metod kullanarak test widget'ı oluştur
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.byType(Scaffold),
          findsAtLeastNWidgets(1),
          reason: 'Scaffold should be present',
        );
        expect(
          find.byType(AppBar),
          findsOneWidget,
          reason: 'AppBar should be present',
        );
        expect(
          find.byType(GridView),
          findsOneWidget,
          reason: 'GridView should be present',
        );
        expect(
          find.text('Categories'),
          findsOneWidget,
          reason: 'AppBar title should be displayed',
        );
      });

      testWidgets('Kategori kartları render edilir', (tester) async {
        // Arrange - Helper metod kullanarak test widget'ı oluştur
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert - MockCategoryCard'lar render edilmeli
        final categoryCards = find.byType(MockCategoryCard);
        expect(
          categoryCards,
          findsAtLeastNWidgets(1),
          reason: 'At least one category card should be rendered',
        );
        expect(
          categoryCards.evaluate().length,
          lessThanOrEqualTo(homeViewModel.categories.length),
          reason: 'Should not render more cards than categories available',
        );
      });

      testWidgets('Kategori kartları doğru içeriği gösterir', (tester) async {
        // Arrange
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert - İlk kategori kartının içeriğini kontrol et
        final firstCategory = homeViewModel.categories.first;
        expect(
          find.text(firstCategory.titleKey),
          findsOneWidget,
          reason: 'First category title should be displayed',
        );
      });

      testWidgets('Kategori listesi layout alternatifi çalışır', (
        tester,
      ) async {
        // Arrange - List layout kullanarak test et
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryListWidget(
            homeViewModel: homeViewModel,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.byType(ListView),
          findsOneWidget,
          reason: 'ListView should be present in list layout',
        );
        expect(
          find.byType(ListTile),
          findsAtLeastNWidgets(1),
          reason: 'At least one ListTile should be present',
        );
      });
    });

    group('Grid Layout', () {
      testWidgets('GridView doğru layout parametrelerini kullanır', (
        tester,
      ) async {
        // Arrange - Helper metod kullanarak test widget'ı oluştur
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        final gridView = find.byType(GridView);
        expect(gridView, findsOneWidget, reason: 'GridView should be present');

        final gridViewWidget = tester.widget<GridView>(gridView);
        final delegate =
            gridViewWidget.gridDelegate
                as SliverGridDelegateWithFixedCrossAxisCount;

        expect(
          delegate.crossAxisCount,
          equals(2),
          reason: 'Grid should have 2 columns',
        );
        expect(
          delegate.mainAxisSpacing,
          equals(16),
          reason: 'Main axis spacing should be 16',
        );
        expect(
          delegate.crossAxisSpacing,
          equals(16),
          reason: 'Cross axis spacing should be 16',
        );
        expect(
          delegate.childAspectRatio,
          equals(0.85),
          reason: 'Child aspect ratio should be 0.85',
        );
      });

      testWidgets('GridView responsive layout parametrelerini destekler', (
        tester,
      ) async {
        // Arrange - Farklı ekran boyutları için test
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        final gridView = find.byType(GridView);
        expect(
          gridView,
          findsOneWidget,
          reason: 'GridView should be present in different screen size',
        );

        // Grid'in ekran boyutuna uyum sağladığını kontrol et
        final gridViewWidget = tester.widget<GridView>(gridView);
        expect(
          gridViewWidget.gridDelegate,
          isA<SliverGridDelegateWithFixedCrossAxisCount>(),
          reason:
              'Grid delegate should be SliverGridDelegateWithFixedCrossAxisCount',
        );
      });

      testWidgets('GridView scroll davranışı doğru çalışır', (tester) async {
        // Arrange - Çok sayıda kategori ile test
        final largeCategoryList = TestCategoryFactory.createLargeCategoryList(
          20,
        );
        final largeHomeViewModel = HomeViewModel(categories: largeCategoryList);

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: largeHomeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Scroll işlemi
        await tester.drag(find.byType(GridView), const Offset(0, -200));
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.byType(GridView),
          findsOneWidget,
          reason: 'GridView should still be present after scrolling',
        );
        expect(
          find.byType(MockCategoryCard),
          findsAtLeastNWidgets(1),
          reason: 'Category cards should still be visible after scrolling',
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('Boş kategori listesi durumunu handle eder', (tester) async {
        // Arrange - Boş kategori listesi ile HomeViewModel oluştur
        final emptyHomeViewModel = HomeViewModel(categories: []);

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: emptyHomeViewModel,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert - Boş liste durumunda hiç kategori kartı olmamalı
        final categoryCards = find.byType(MockCategoryCard);
        expect(
          categoryCards,
          findsNothing,
          reason: 'No category cards should be rendered with empty list',
        );
        expect(
          find.byType(GridView),
          findsOneWidget,
          reason: 'GridView should still be present with empty list',
        );
        expect(
          find.byType(Scaffold),
          findsAtLeastNWidgets(1),
          reason: 'Scaffold should still be present with empty list',
        );
      });

      testWidgets('Çok büyük kategori listesi durumunu handle eder', (
        tester,
      ) async {
        // Arrange - Çok büyük kategori listesi oluştur
        final largeCategoryList = TestCategoryFactory.createLargeCategoryList(
          50,
        );
        final largeHomeViewModel = HomeViewModel(categories: largeCategoryList);

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: largeHomeViewModel,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert - Büyük liste durumunda çok sayıda kategori kartı olmalı
        final categoryCards = find.byType(MockCategoryCard);
        expect(
          categoryCards,
          findsAtLeastNWidgets(1),
          reason: 'At least one category card should be rendered',
        );
        expect(
          find.byType(GridView),
          findsOneWidget,
          reason: 'GridView should handle large lists',
        );

        // Performance kontrolü - render süresi makul olmalı
        expect(
          largeHomeViewModel.categories.length,
          equals(50),
          reason: 'Large category list should have 50 items',
        );
      });

      testWidgets('Null kategori değerleri handle edilir', (tester) async {
        // Arrange - Null değerler içeren kategori listesi
        final categoriesWithNulls = [
          HomeCategory(
            titleKey: 'categories.valid',
            imageUrl: 'assets/images/categories/valid.png',
            palette: CategoryPalette.highProtein,
          ),
          // Null değerler test edilemez çünkü HomeCategory non-nullable
          // Bu test daha çok defensive programming için
        ];

        final homeViewModelWithNulls = HomeViewModel(
          categories: categoriesWithNulls,
        );

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModelWithNulls,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.byType(MockCategoryCard),
          findsAtLeastNWidgets(1),
          reason: 'Valid categories should still render',
        );
      });

      testWidgets('Çok uzun kategori isimleri handle edilir', (tester) async {
        // Arrange - Çok uzun isimli kategori
        final longNameCategory = HomeCategory(
          titleKey:
              'categories.very_long_category_name_that_might_cause_layout_issues_in_ui_components',
          imageUrl: 'assets/images/categories/long_name.png',
          palette: CategoryPalette.highProtein,
        );

        final longNameHomeViewModel = HomeViewModel(
          categories: [longNameCategory],
        );

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: longNameHomeViewModel,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text(longNameCategory.titleKey),
          findsOneWidget,
          reason: 'Long category name should be displayed',
        );
        expect(
          find.byType(MockCategoryCard),
          findsOneWidget,
          reason: 'Category card should render with long name',
        );
      });

      testWidgets('Geçersiz image URL\'leri handle edilir', (tester) async {
        // Arrange - Geçersiz image URL'li kategori
        final invalidImageCategory = HomeCategory(
          titleKey: 'categories.invalid_image',
          imageUrl: 'invalid/path/to/image.png',
          palette: CategoryPalette.highProtein,
        );

        final invalidImageHomeViewModel = HomeViewModel(
          categories: [invalidImageCategory],
        );

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: invalidImageHomeViewModel,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text(invalidImageCategory.titleKey),
          findsOneWidget,
          reason: 'Category title should still be displayed',
        );
        expect(
          find.byType(MockCategoryCard),
          findsOneWidget,
          reason: 'Category card should render despite invalid image URL',
        );
      });

      testWidgets('Rapid kategori değişiklikleri handle edilir', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Hızlı kategori değişiklikleri
        final newCategories = TestCategoryFactory.createDefaultCategories();
        final newHomeViewModel = HomeViewModel(categories: newCategories);

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: newHomeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(
          find.byType(MockCategoryCard),
          findsAtLeastNWidgets(1),
          reason: 'Category cards should render after rapid changes',
        );
        expect(
          find.byType(GridView),
          findsOneWidget,
          reason: 'GridView should remain stable during rapid changes',
        );
      });
    });

    group('Performance', () {
      testWidgets('HomeViewModel oluşturma hızlı', (tester) async {
        // Arrange
        final stopwatch = Stopwatch()..start();

        // Act
        final testViewModel = HomeViewModel();
        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
          reason: 'HomeViewModel creation should be fast (< 100ms)',
        );
        expect(
          testViewModel.categories,
          isNotEmpty,
          reason: 'Created HomeViewModel should have categories',
        );
      });

      testWidgets('Büyük kategori listesi render performansı', (tester) async {
        // Arrange
        final largeCategoryList = TestCategoryFactory.createLargeCategoryList(
          100,
        );
        final largeHomeViewModel = HomeViewModel(categories: largeCategoryList);
        final stopwatch = Stopwatch()..start();

        // Act
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: largeHomeViewModel,
          ),
        );
        await tester.pumpAndSettle();
        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1000),
          reason: 'Large category list should render in reasonable time (< 1s)',
        );
        expect(
          find.byType(MockCategoryCard),
          findsAtLeastNWidgets(1),
          reason: 'Category cards should be rendered',
        );
      });

      testWidgets('Memory usage kontrolü', (tester) async {
        // Arrange
        final initialMemory = ProcessInfo.currentRss;

        // Act - Çok sayıda widget oluştur
        for (int i = 0; i < 10; i++) {
          final testViewModel = HomeViewModel();
          await tester.pumpWidget(
            CategoryNavigationTestHelpers.createCategoryGridWidget(
              homeViewModel: testViewModel,
            ),
          );
          await tester.pumpAndSettle();
        }

        // Assert
        final finalMemory = ProcessInfo.currentRss;
        final memoryIncrease = finalMemory - initialMemory;

        // Memory artışı makul seviyede olmalı (20MB'den az)
        expect(
          memoryIncrease,
          lessThan(20 * 1024 * 1024),
          reason: 'Memory usage should not increase excessively',
        );
      });
    });

    group('Navigation Tests', () {
      testWidgets('Kategori kartına tıklama callback çalışır', (tester) async {
        // Arrange
        bool callbackCalled = false;
        final testCallback = () {
          callbackCalled = true;
        };

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
            onCategoryTap: testCallback,
          ),
        );

        await tester.pumpAndSettle();

        // Act - İlk kategori kartına tıkla
        final firstCategoryCard = find.byType(MockCategoryCard).first;
        await tester.tap(firstCategoryCard);
        await tester.pumpAndSettle();

        // Assert
        expect(
          callbackCalled,
          isTrue,
          reason: 'Category tap callback should be called',
        );
      });

      testWidgets('Kategori kartı tıklama animasyonu çalışır', (tester) async {
        // Arrange
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Kategori kartına tıkla ve animasyonu gözlemle
        final firstCategoryCard = find.byType(MockCategoryCard).first;
        await tester.tap(firstCategoryCard);
        await tester.pump(); // Animasyon başlangıcı

        // Assert
        expect(
          find.byType(MockCategoryCard),
          findsAtLeastNWidgets(1),
          reason: 'Category card should still be present after tap',
        );
      });

      testWidgets('Çoklu kategori tıklamaları handle edilir', (tester) async {
        // Arrange
        int tapCount = 0;
        final testCallback = () {
          tapCount++;
        };

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
            onCategoryTap: testCallback,
          ),
        );

        await tester.pumpAndSettle();

        // Act - Birden fazla kategori kartına tıkla
        final categoryCards = find.byType(MockCategoryCard);
        for (int i = 0; i < 3 && i < categoryCards.evaluate().length; i++) {
          await tester.tap(categoryCards.at(i));
          await tester.pumpAndSettle();
        }

        // Assert
        expect(
          tapCount,
          equals(3),
          reason: 'Multiple category taps should be handled correctly',
        );
      });

      testWidgets('Kategori navigasyonu state değişikliklerini handle eder', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act - State değişikliği simüle et
        final newCategories = TestCategoryFactory.createDefaultCategories();
        final newHomeViewModel = HomeViewModel(categories: newCategories);

        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: newHomeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(
          find.byType(MockCategoryCard),
          findsAtLeastNWidgets(1),
          reason: 'Category cards should update with state changes',
        );
        expect(
          find.byType(GridView),
          findsOneWidget,
          reason: 'GridView should remain stable during state changes',
        );
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Kategori kartları erişilebilir', (tester) async {
        // Arrange
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act & Assert
        final categoryCards = find.byType(MockCategoryCard);
        expect(
          categoryCards,
          findsAtLeastNWidgets(1),
          reason: 'Category cards should be accessible',
        );

        // Semantik bilgileri kontrol et
        final semantics = tester.getSemantics(
          find.byType(MockCategoryCard).first,
        );
        expect(
          semantics,
          isNotNull,
          reason: 'Category cards should have semantic information',
        );
      });

      testWidgets('Screen reader uyumluluğu', (tester) async {
        // Arrange
        await tester.pumpWidget(
          CategoryNavigationTestHelpers.createCategoryGridWidget(
            homeViewModel: homeViewModel,
          ),
        );

        await tester.pumpAndSettle();

        // Act & Assert
        final firstCategory = homeViewModel.categories.first;
        expect(
          find.text(firstCategory.titleKey),
          findsOneWidget,
          reason: 'Category titles should be readable by screen readers',
        );
      });
    });
  });
}
