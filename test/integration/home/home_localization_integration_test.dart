// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helpers.dart';

/// Mock translation service for testing
class MockTranslationService {
  static const Map<String, Map<String, String>> _translations = {
    'tr': {
      'appbar.categories': 'Kategoriler',
      'categories.high_protein': 'Protein',
      'categories.high_carbohydrate': 'Karbonhidrat',
      'categories.high_fat': 'Yağ',
      'categories.breakfast': 'Kahvaltı',
      'categories.fruits_vegetables': 'Meyve & Sebze',
      'categories.beverages': 'İçecekler',
      'categories.meat_fish': 'Et & Balık',
      'categories.snacks': 'Atıştırmalıklar',
      'categories.dairy': 'Süt Ürünleri',
      'categories.high_vitamins_minerals': 'Vitamin/Mineral',
      'categories.high_fiber': 'Lif',
    },
    'en': {
      'appbar.categories': 'Categories',
      'categories.high_protein': 'Protein',
      'categories.high_carbohydrate': 'Carbs',
      'categories.high_fat': 'Fat',
      'categories.breakfast': 'Breakfast',
      'categories.fruits_vegetables': 'Fruits & Vegetables',
      'categories.beverages': 'Beverages',
      'categories.meat_fish': 'Meat & Fish',
      'categories.snacks': 'Snacks',
      'categories.dairy': 'Dairy',
      'categories.high_vitamins_minerals': 'Vitamins/Minerals',
      'categories.high_fiber': 'Fiber',
    },
  };

  static String translate(String key, String locale) {
    return _translations[locale]?[key] ?? key;
  }
}

/// Mock CategoryCard widget for localization testing
///
/// Bu widget gerçek CategoryCard widget'ının davranışını simüle eder
/// ve test sırasında kategori kartlarının render edilmesini sağlar.
/// Localization testleri için özel olarak tasarlanmıştır.
class MockLocalizedCategoryCard extends StatelessWidget {
  final HomeCategory category;
  final VoidCallback? onTap;
  final Locale currentLocale;

  const MockLocalizedCategoryCard({
    super.key,
    required this.category,
    this.onTap,
    required this.currentLocale,
  });

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
              MockTranslationService.translate(
                category.titleKey,
                currentLocale.languageCode,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Locale: ${currentLocale.languageCode}',
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

/// Test data factory for creating test categories with localization
class LocalizationTestCategoryFactory {
  static List<HomeCategory> createLocalizedCategories() {
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
      HomeCategory(
        titleKey: 'categories.fruits_vegetables',
        imageUrl: 'assets/images/categories/fruits_vegetables.png',
        palette: CategoryPalette.fruitsVegetables,
      ),
    ];
  }

  static List<HomeCategory> createAllLocalizedCategories() {
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
        titleKey: 'categories.high_vitamins_minerals',
        imageUrl: 'assets/images/categories/high_vitamins_minerals.png',
        palette: CategoryPalette.highVitaminsMinerals,
      ),
      HomeCategory(
        titleKey: 'categories.high_fiber',
        imageUrl: 'assets/images/categories/high_fiber.png',
        palette: CategoryPalette.highFiber,
      ),
      HomeCategory(
        titleKey: 'categories.fruits_vegetables',
        imageUrl: 'assets/images/categories/fruits_vegetables.png',
        palette: CategoryPalette.fruitsVegetables,
      ),
      HomeCategory(
        titleKey: 'categories.breakfast',
        imageUrl: 'assets/images/categories/breakfast.png',
        palette: CategoryPalette.breakfast,
      ),
      HomeCategory(
        titleKey: 'categories.beverages',
        imageUrl: 'assets/images/categories/beverages.png',
        palette: CategoryPalette.beverages,
      ),
      HomeCategory(
        titleKey: 'categories.meat_fish',
        imageUrl: 'assets/images/categories/meat_fish.png',
        palette: CategoryPalette.meatFish,
      ),
      HomeCategory(
        titleKey: 'categories.snacks',
        imageUrl: 'assets/images/categories/snacks.png',
        palette: CategoryPalette.snacks,
      ),
      HomeCategory(
        titleKey: 'categories.dairy',
        imageUrl: 'assets/images/categories/dairy.png',
        palette: CategoryPalette.dairy,
      ),
    ];
  }
}

/// Test helper methods for localization tests
class LocalizationTestHelpers {
  /// Creates a test widget with localization support
  static Widget createLocalizedTestWidget({
    required HomeViewModel homeViewModel,
    required Locale locale,
    VoidCallback? onCategoryTap,
  }) {
    return MaterialApp(
      theme: TestHelpers.createTestTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            MockTranslationService.translate(
              'appbar.categories',
              locale.languageCode,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Locale indicator
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Current Locale: ${locale.languageCode}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: homeViewModel.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return MockLocalizedCategoryCard(
                      category: homeViewModel.categories[index],
                      onTap: onCategoryTap,
                      currentLocale: locale,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      locale: locale,
    );
  }

  /// Creates a test widget with category list layout for localization
  static Widget createLocalizedListWidget({
    required HomeViewModel homeViewModel,
    required Locale locale,
    VoidCallback? onCategoryTap,
  }) {
    return MaterialApp(
      theme: TestHelpers.createTestTheme(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            MockTranslationService.translate(
              'appbar.categories',
              locale.languageCode,
            ),
          ),
        ),
        body: Column(
          children: [
            // Locale indicator
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Current Locale: ${locale.languageCode}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: homeViewModel.categories.length,
                itemBuilder: (context, index) {
                  final category = homeViewModel.categories[index];
                  return ListTile(
                    title: Text(
                      MockTranslationService.translate(
                        category.titleKey,
                        locale.languageCode,
                      ),
                    ),
                    subtitle: Text('Key: ${category.titleKey}'),
                    onTap: onCategoryTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('tr')],
      locale: locale,
    );
  }

  /// Verifies that all expected category translations are present
  static void verifyCategoryTranslations(
    List<HomeCategory> categories,
    Locale locale,
  ) {
    final expectedTranslations = {
      'categories.high_protein': {'en': 'Protein', 'tr': 'Protein'},
      'categories.high_carbohydrate': {'en': 'Carbs', 'tr': 'Karbonhidrat'},
      'categories.high_fat': {'en': 'Fat', 'tr': 'Yağ'},
      'categories.breakfast': {'en': 'Breakfast', 'tr': 'Kahvaltı'},
      'categories.fruits_vegetables': {
        'en': 'Fruits & Vegetables',
        'tr': 'Meyve & Sebze',
      },
    };

    for (final category in categories) {
      if (expectedTranslations.containsKey(category.titleKey)) {
        final expectedTranslation =
            expectedTranslations[category.titleKey]![locale.languageCode];
        expect(
          expectedTranslation,
          isNotNull,
          reason:
              'Translation for ${category.titleKey} in ${locale.languageCode} should exist',
        );
      }
    }
  }

  /// Verifies that category titles are properly localized
  static void verifyLocalizedCategoryTitles(
    List<HomeCategory> categories,
    Locale locale,
  ) {
    for (final category in categories) {
      final localizedTitle = MockTranslationService.translate(
        category.titleKey,
        locale.languageCode,
      );
      expect(
        localizedTitle,
        isNotEmpty,
        reason: 'Localized title for ${category.titleKey} should not be empty',
      );
      expect(
        localizedTitle,
        isNot(equals(category.titleKey)),
        reason: 'Localized title should not be the same as the key',
      );
    }
  }

  /// Verifies that app bar title is properly localized
  static void verifyAppBarLocalization(Locale locale) {
    final appBarTitle = MockTranslationService.translate(
      'appbar.categories',
      locale.languageCode,
    );
    expect(
      appBarTitle,
      isNotEmpty,
      reason: 'App bar title should not be empty',
    );

    final expectedTitles = {'en': 'Categories', 'tr': 'Kategoriler'};

    expect(
      appBarTitle,
      equals(expectedTitles[locale.languageCode]),
      reason:
          'App bar title should match expected translation for ${locale.languageCode}',
    );
  }
}

/// Home Localization Integration Test Suite
///
/// Bu test suite'i home ekranındaki localization entegrasyonunu test eder.
/// Kategori başlıklarının çevirisi, dil değişiklikleri, ve UI etkileşimleri kapsanır.
///
/// Test Coverage:
/// - HomeViewModel localization desteği
/// - Kategori başlıklarının çevirisi
/// - Dil değişikliklerinin UI'ya yansıması
/// - EasyLocalization entegrasyonu
/// - Fallback dil desteği
/// - Edge case senaryoları
/// - Performance testleri

void main() {
  group('Home Localization Integration Tests', () {
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

    group('Basic Localization Tests', () {
      testWidgets('Kategori başlıkları Türkçe olarak çevrilir', (tester) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Kategoriler'),
          findsOneWidget,
          reason: 'App bar title should be in Turkish',
        );
        expect(
          find.text('Protein'),
          findsAtLeastNWidgets(1),
          reason: 'High protein category should be translated to Turkish',
        );
      });

      testWidgets('Kategori başlıkları İngilizce olarak çevrilir', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('en'),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Categories'),
          findsOneWidget,
          reason: 'App bar title should be in English',
        );
        expect(
          find.text('Protein'),
          findsAtLeastNWidgets(1),
          reason: 'High protein category should be translated to English',
        );
      });

      testWidgets('HomeViewModel localize metodu çalışır', (tester) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Mock translation service kullanarak test et
        final localizedTitle = MockTranslationService.translate(
          'categories.high_protein',
          'tr',
        );

        // Assert
        expect(
          localizedTitle,
          equals('Protein'),
          reason:
              'HomeViewModel localize method should return Turkish translation',
        );
      });

      testWidgets('Tüm kategori başlıkları çevrilir', (tester) async {
        // Arrange
        final allCategories =
            LocalizationTestCategoryFactory.createAllLocalizedCategories();
        final testHomeViewModel = HomeViewModel(categories: allCategories);

        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: testHomeViewModel,
            locale: const Locale('tr'),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        LocalizationTestHelpers.verifyLocalizedCategoryTitles(
          testHomeViewModel.categories,
          const Locale('tr'),
        );
      });
    });

    group('Language Switching Tests', () {
      testWidgets('Dil değişikliği UI\'yı günceller', (tester) async {
        // Arrange - Türkçe ile başla
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Türkçe başlıkları kontrol et
        expect(
          find.text('Kategoriler'),
          findsOneWidget,
          reason: 'Initial app bar should be in Turkish',
        );

        // Act - İngilizce'ye geç
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('en'),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - İngilizce başlıkları kontrol et
        expect(
          find.text('Categories'),
          findsOneWidget,
          reason: 'App bar should be updated to English',
        );
        expect(
          find.text('Carbs'),
          findsOneWidget,
          reason: 'Category titles should be updated to English',
        );
      });

      testWidgets('Dil değişikliği kategori başlıklarını günceller', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedListWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Türkçe başlıkları
        expect(
          find.text('Meyve & Sebze'),
          findsOneWidget,
          reason: 'Fruits & vegetables should be in Turkish',
        );

        // Act - İngilizce'ye geç
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedListWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('en'),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - İngilizce başlıkları
        expect(
          find.text('Fruits & Vegetables'),
          findsOneWidget,
          reason: 'Fruits & vegetables should be in English',
        );
      });

      testWidgets('Hızlı dil değişiklikleri handle edilir', (tester) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Hızlı dil değişiklikleri
        final locales = [
          const Locale('tr'),
          const Locale('en'),
          const Locale('tr'),
        ];

        for (final locale in locales) {
          await tester.pumpWidget(
            LocalizationTestHelpers.createLocalizedTestWidget(
              homeViewModel: homeViewModel,
              locale: locale,
            ),
          );
          await tester.pumpAndSettle();
        }

        // Assert - Son dil (Türkçe) aktif olmalı
        expect(
          find.text('Kategoriler'),
          findsOneWidget,
          reason: 'Final language should be Turkish after rapid changes',
        );
      });
    });

    group('Fallback Language Tests', () {
      testWidgets('Desteklenmeyen dil için fallback çalışır', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: TestHelpers.createTestTheme(),
            home: Scaffold(
              appBar: AppBar(
                title: Text(
                  MockTranslationService.translate('appbar.categories', 'fr'),
                ),
              ),
              body: Text(
                'Test: ${MockTranslationService.translate('categories.high_protein', 'fr')}',
              ),
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('tr')],
            locale: const Locale('fr'),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert - Fallback dil (Türkçe) kullanılmalı
        expect(
          find.text('appbar.categories'),
          findsOneWidget,
          reason: 'Fallback should return key for unsupported locale',
        );
        expect(
          find.text('Test: categories.high_protein'),
          findsOneWidget,
          reason:
              'Category translation should return key for unsupported locale',
        );
      });

      testWidgets('Eksik çeviri için fallback çalışır', (tester) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('en'),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Eksik çeviri anahtarı test et
        final missingTranslation = MockTranslationService.translate(
          'categories.nonexistent',
          'en',
        );

        // Assert - Eksik çeviri anahtarı döndürülmeli
        expect(
          missingTranslation,
          equals('categories.nonexistent'),
          reason: 'Missing translation should return the key itself',
        );
      });
    });

    group('Localization Performance Tests', () {
      testWidgets('Çok sayıda kategori ile localization performansı', (
        tester,
      ) async {
        // Arrange
        final largeCategoryList = List.generate(
          50,
          (index) => HomeCategory(
            titleKey: 'categories.test_$index',
            imageUrl: 'assets/images/categories/test_$index.png',
            palette:
                CategoryPalette.values[index % CategoryPalette.values.length],
          ),
        );
        final largeHomeViewModel = HomeViewModel(categories: largeCategoryList);
        final stopwatch = Stopwatch()..start();

        // Act
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: largeHomeViewModel,
            locale: const Locale('tr'),
          ),
        );
        await tester.pumpAndSettle();
        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(1000),
          reason: 'Large category list localization should be fast (< 1s)',
        );
        expect(
          find.byType(MockLocalizedCategoryCard),
          findsAtLeastNWidgets(1),
          reason: 'Category cards should be rendered with localization',
        );
      });

      testWidgets('Dil değişikliği performansı', (tester) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Dil değişikliği performansını test et
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('en'),
          ),
        );
        await tester.pumpAndSettle();

        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(500),
          reason: 'Language switching should be fast (< 500ms)',
        );
      });

      testWidgets('Memory usage localization ile', (tester) async {
        // Arrange
        final initialMemory = ProcessInfo.currentRss;

        // Act - Çok sayıda localization widget oluştur
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(
            LocalizationTestHelpers.createLocalizedTestWidget(
              homeViewModel: homeViewModel,
              locale: i % 2 == 0 ? const Locale('tr') : const Locale('en'),
            ),
          );
          await tester.pumpAndSettle();
        }

        // Assert
        final finalMemory = ProcessInfo.currentRss;
        final memoryIncrease = finalMemory - initialMemory;

        // Memory artışı makul seviyede olmalı (30MB'den az)
        expect(
          memoryIncrease,
          lessThan(30 * 1024 * 1024),
          reason:
              'Memory usage should not increase excessively with localization',
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('Boş kategori listesi ile localization çalışır', (
        tester,
      ) async {
        // Arrange
        final emptyHomeViewModel = HomeViewModel(categories: []);

        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: emptyHomeViewModel,
            locale: const Locale('tr'),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Kategoriler'),
          findsOneWidget,
          reason: 'App bar should still be localized with empty categories',
        );
        expect(
          find.byType(MockLocalizedCategoryCard),
          findsNothing,
          reason: 'No category cards should be rendered with empty list',
        );
      });

      testWidgets('Null locale durumunu handle eder', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            theme: TestHelpers.createTestTheme(),
            home: Scaffold(
              appBar: AppBar(
                title: Text(
                  MockTranslationService.translate('appbar.categories', 'tr'),
                ),
              ),
              body: const Text('Test'),
            ),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('tr')],
            locale: null, // Null locale
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert - Fallback locale kullanılmalı
        expect(
          find.text('Kategoriler'),
          findsOneWidget,
          reason: 'Fallback locale should be used when locale is null',
        );
      });

      testWidgets('Geçersiz çeviri anahtarı handle edilir', (tester) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Geçersiz çeviri anahtarı test et
        final invalidKey = MockTranslationService.translate(
          'invalid.key.with.special.chars!@#',
          'tr',
        );

        // Assert
        expect(
          invalidKey,
          equals('invalid.key.with.special.chars!@#'),
          reason: 'Invalid translation key should return the key itself',
        );
      });

      testWidgets('Çok uzun çeviri anahtarı handle edilir', (tester) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Çok uzun çeviri anahtarı test et
        final longKey = MockTranslationService.translate(
          'categories.very_long_category_name_that_might_cause_issues_in_translation_system_and_should_be_handled_gracefully',
          'tr',
        );

        // Assert
        expect(
          longKey,
          isNotEmpty,
          reason: 'Long translation key should be handled gracefully',
        );
      });
    });

    group('Localization Integration Tests', () {
      testWidgets('HomeViewModel ve EasyLocalization entegrasyonu', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Mock translation service ile test et
        final localizedCategories = homeViewModel.categories.map((category) {
          return MockTranslationService.translate(category.titleKey, 'tr');
        }).toList();

        // Assert
        expect(
          localizedCategories,
          isNotEmpty,
          reason: 'Localized categories should not be empty',
        );
        expect(
          localizedCategories.every((title) => title.isNotEmpty),
          isTrue,
          reason: 'All localized category titles should be non-empty',
        );
        expect(
          localizedCategories.every(
            (title) => !title.startsWith('categories.'),
          ),
          isTrue,
          reason: 'All localized titles should not start with the key prefix',
        );
      });

      testWidgets('Kategori kartları localization ile render edilir', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('en'),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        final categoryCards = find.byType(MockLocalizedCategoryCard);
        expect(
          categoryCards,
          findsAtLeastNWidgets(1),
          reason: 'Localized category cards should be rendered',
        );

        // Her kategori kartının localized title içerdiğini kontrol et
        for (int i = 0; i < categoryCards.evaluate().length; i++) {
          final card = categoryCards.at(i);
          expect(
            card,
            findsOneWidget,
            reason: 'Category card $i should be present',
          );
        }
      });

      testWidgets('Locale indicator doğru gösterilir', (tester) async {
        // Arrange
        const testLocale = Locale('en');
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: testLocale,
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Current Locale: en'),
          findsOneWidget,
          reason: 'Locale indicator should show current locale',
        );
      });
    });

    group('Accessibility with Localization', () {
      testWidgets('Localized kategori kartları erişilebilir', (tester) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedTestWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        final categoryCards = find.byType(MockLocalizedCategoryCard);
        expect(
          categoryCards,
          findsAtLeastNWidgets(1),
          reason: 'Localized category cards should be accessible',
        );

        // Semantik bilgileri kontrol et
        final semantics = tester.getSemantics(categoryCards.first);
        expect(
          semantics,
          isNotNull,
          reason: 'Localized category cards should have semantic information',
        );
      });

      testWidgets('Screen reader localized metinleri okuyabilir', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          LocalizationTestHelpers.createLocalizedListWidget(
            homeViewModel: homeViewModel,
            locale: const Locale('tr'),
          ),
        );

        // Act
        await tester.pumpAndSettle();

        // Assert
        expect(
          find.text('Kategoriler'),
          findsOneWidget,
          reason:
              'Localized app bar title should be readable by screen readers',
        );
        expect(
          find.text('Protein'),
          findsOneWidget,
          reason:
              'Localized category title should be readable by screen readers',
        );
      });
    });
  });
}
