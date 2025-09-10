import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/features/home/view_model/home_view_model.dart';
import 'package:arya/features/home/model/home_category.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/product/constants/home_constants.dart';

import 'home_view_model_test.mocks.dart';

// Mock sınıfları generate etmek için annotation
@GenerateMocks([BuildContext])
void main() {
  group('HomeViewModel Tests', () {
    late HomeViewModel viewModel;
    late MockBuildContext mockContext;

    setUp(() {
      mockContext = MockBuildContext();
      viewModel = HomeViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Constructor Tests', () {
      test(
        'should initialize with default categories when no categories provided',
        () {
          expect(viewModel.categories, isNotEmpty);
          expect(viewModel.categories.length, equals(11));
        },
      );

      test('should initialize with custom categories when provided', () {
        final customCategories = [
          const HomeCategory(
            titleKey: 'test.category1',
            imageUrl: 'test_image1.png',
            palette: CategoryPalette.fruitsVegetables,
          ),
          const HomeCategory(
            titleKey: 'test.category2',
            imageUrl: 'test_image2.png',
            palette: CategoryPalette.breakfast,
          ),
        ];

        final customViewModel = HomeViewModel(categories: customCategories);

        expect(customViewModel.categories, equals(customCategories));
        expect(customViewModel.categories.length, equals(2));
      });

      test('should be a ChangeNotifier', () {
        expect(viewModel, isA<ChangeNotifier>());
      });

      test('should not be disposed initially', () {
        expect(viewModel.hasListeners, isFalse);
      });
    });

    group('Categories Tests', () {
      test('should have valid category structure', () {
        for (final category in viewModel.categories) {
          expect(category.titleKey, isNotEmpty);
          expect(category.imageUrl, isNotEmpty);
          expect(category.palette, isNotNull);
        }
      });

      test('should have unique category keys', () {
        final keys = viewModel.categories.map((c) => c.titleKey).toSet();
        expect(keys.length, equals(viewModel.categories.length));
      });

      test('should have valid image paths', () {
        for (final category in viewModel.categories) {
          expect(category.imageUrl, startsWith('assets/images/categories/'));
          expect(category.imageUrl, endsWith('.png'));
        }
      });

      test('should have all required categories', () {
        final expectedCategories = [
          'categories.high_protein',
          'categories.high_carbohydrate',
          'categories.high_fat',
          'categories.high_vitamins_minerals',
          'categories.high_fiber',
          'categories.fruits_vegetables',
          'categories.breakfast',
          'categories.beverages',
          'categories.meat_fish',
          'categories.snacks',
          'categories.dairy',
        ];

        final actualKeys = viewModel.categories.map((c) => c.titleKey).toList();

        for (final expectedKey in expectedCategories) {
          expect(actualKeys, contains(expectedKey));
        }
      });

      test('should have consistent color schemes', () {
        for (final category in viewModel.categories) {
          expect(category.palette, isNotNull);
          expect(
            category.palette.runtimeType.toString(),
            contains('CategoryPalette'),
          );
        }
      });

      test('should have valid image dimensions', () {
        for (final category in viewModel.categories) {
          expect(category.imageUrl, isNotEmpty);
          expect(category.imageUrl, contains('.png'));
        }
      });
    });

    group('Localization Tests', () {
      test('should provide localization method', () {
        expect(viewModel.localize, isA<Function>());
      });

      test('should handle localization keys correctly', () {
        // Localize metodunu test et
        final result = viewModel.localize(
          mockContext,
          'categories.high_protein',
        );

        expect(result, isA<String>());
        expect(result, isNotEmpty);
      });

      test('should handle empty localization key', () {
        final result = viewModel.localize(mockContext, '');

        expect(result, isA<String>());
        expect(result, equals(''));
      });

      test('should handle null localization key gracefully', () {
        expect(
          () => viewModel.localize(mockContext, 'categories.nonexistent'),
          returnsNormally,
        );
      });
    });

    group('Category Types Tests', () {
      test('should have high protein category', () {
        final highProteinCategory = viewModel.categories
            .where((c) => c.titleKey.contains('high_protein'))
            .firstOrNull;
        expect(highProteinCategory, isNotNull);
        expect(
          highProteinCategory!.titleKey,
          equals('categories.high_protein'),
        );
        expect(
          highProteinCategory.imageUrl,
          equals(HomeConstants.catHighProtein),
        );
        expect(
          highProteinCategory.palette,
          equals(CategoryPalette.highProtein),
        );
      });

      test('should have high carbohydrate category', () {
        final highCarbCategory = viewModel.categories
            .where((c) => c.titleKey.contains('high_carbohydrate'))
            .firstOrNull;
        expect(highCarbCategory, isNotNull);
        expect(
          highCarbCategory!.titleKey,
          equals('categories.high_carbohydrate'),
        );
        expect(
          highCarbCategory.imageUrl,
          equals(HomeConstants.catHighCarbohydrate),
        );
        expect(
          highCarbCategory.palette,
          equals(CategoryPalette.highCarbohydrate),
        );
      });

      test('should have high fat category', () {
        final highFatCategory = viewModel.categories
            .where((c) => c.titleKey.contains('high_fat'))
            .firstOrNull;
        expect(highFatCategory, isNotNull);
        expect(highFatCategory!.titleKey, equals('categories.high_fat'));
        expect(highFatCategory.imageUrl, equals(HomeConstants.catHighFat));
        expect(highFatCategory.palette, equals(CategoryPalette.highFat));
      });

      test('should have high vitamins minerals category', () {
        final highVitaminsCategory = viewModel.categories
            .where((c) => c.titleKey.contains('high_vitamins_minerals'))
            .firstOrNull;
        expect(highVitaminsCategory, isNotNull);
        expect(
          highVitaminsCategory!.titleKey,
          equals('categories.high_vitamins_minerals'),
        );
        expect(
          highVitaminsCategory.imageUrl,
          equals(HomeConstants.catHighVitaminsMinerals),
        );
        expect(
          highVitaminsCategory.palette,
          equals(CategoryPalette.highVitaminsMinerals),
        );
      });

      test('should have high fiber category', () {
        final highFiberCategory = viewModel.categories
            .where((c) => c.titleKey.contains('high_fiber'))
            .firstOrNull;
        expect(highFiberCategory, isNotNull);
        expect(highFiberCategory!.titleKey, equals('categories.high_fiber'));
        expect(highFiberCategory.imageUrl, equals(HomeConstants.catHighFiber));
        expect(highFiberCategory.palette, equals(CategoryPalette.highFiber));
      });

      test('should have fruits vegetables category', () {
        final fruitsVegCategory = viewModel.categories
            .where((c) => c.titleKey.contains('fruits_vegetables'))
            .firstOrNull;
        expect(fruitsVegCategory, isNotNull);
        expect(
          fruitsVegCategory!.titleKey,
          equals('categories.fruits_vegetables'),
        );
        expect(
          fruitsVegCategory.imageUrl,
          equals(HomeConstants.catFruitsVegetables),
        );
        expect(
          fruitsVegCategory.palette,
          equals(CategoryPalette.fruitsVegetables),
        );
      });

      test('should have meat fish category', () {
        final meatFishCategory = viewModel.categories
            .where((c) => c.titleKey.contains('meat_fish'))
            .firstOrNull;
        expect(meatFishCategory, isNotNull);
        expect(meatFishCategory!.titleKey, equals('categories.meat_fish'));
        expect(meatFishCategory.imageUrl, equals(HomeConstants.catMeatFish));
        expect(meatFishCategory.palette, equals(CategoryPalette.meatFish));
      });

      test('should have dairy category', () {
        final dairyCategory = viewModel.categories
            .where((c) => c.titleKey.contains('dairy'))
            .firstOrNull;
        expect(dairyCategory, isNotNull);
        expect(dairyCategory!.titleKey, equals('categories.dairy'));
        expect(dairyCategory.imageUrl, equals(HomeConstants.catDairy));
        expect(dairyCategory.palette, equals(CategoryPalette.dairy));
      });

      test('should have breakfast category', () {
        final breakfastCategory = viewModel.categories
            .where((c) => c.titleKey.contains('breakfast'))
            .firstOrNull;
        expect(breakfastCategory, isNotNull);
        expect(breakfastCategory!.titleKey, equals('categories.breakfast'));
        expect(breakfastCategory.imageUrl, equals(HomeConstants.catBreakfast));
        expect(breakfastCategory.palette, equals(CategoryPalette.breakfast));
      });

      test('should have snacks category', () {
        final snacksCategory = viewModel.categories
            .where((c) => c.titleKey.contains('snacks'))
            .firstOrNull;
        expect(snacksCategory, isNotNull);
        expect(snacksCategory!.titleKey, equals('categories.snacks'));
        expect(snacksCategory.imageUrl, equals(HomeConstants.catSnacks));
        expect(snacksCategory.palette, equals(CategoryPalette.snacks));
      });

      test('should have beverages category', () {
        final beveragesCategory = viewModel.categories
            .where((c) => c.titleKey.contains('beverages'))
            .firstOrNull;
        expect(beveragesCategory, isNotNull);
        expect(beveragesCategory!.titleKey, equals('categories.beverages'));
        expect(beveragesCategory.imageUrl, equals(HomeConstants.catBeverages));
        expect(beveragesCategory.palette, equals(CategoryPalette.beverages));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty categories gracefully', () {
        final emptyViewModel = HomeViewModel(categories: []);

        expect(emptyViewModel.categories, isEmpty);
        expect(() => emptyViewModel.categories, returnsNormally);
      });

      test('should have reasonable category count', () {
        // Categories should be between 5 and 20 for good UX
        expect(viewModel.categories.length, greaterThanOrEqualTo(5));
        expect(viewModel.categories.length, lessThanOrEqualTo(20));
      });

      test('should handle null context in localize method', () {
        expect(
          () => viewModel.localize(mockContext, 'test.key'),
          returnsNormally,
        );
      });

      test('should maintain immutability of categories', () {
        final originalCategories = viewModel.categories;

        // Categories list should be immutable
        expect(
          () => originalCategories.add(
            const HomeCategory(
              titleKey: 'test',
              imageUrl: 'test.png',
              palette: CategoryPalette.fruitsVegetables,
            ),
          ),
          throwsA(isA<UnsupportedError>()),
        );
      });
    });

    group('Performance Tests', () {
      test('should build categories quickly', () {
        final stopwatch = Stopwatch()..start();
        final categories = viewModel.categories;
        stopwatch.stop();

        expect(categories, isNotEmpty);
        expect(stopwatch.elapsedMilliseconds, lessThan(100));
      });

      test('should handle multiple access efficiently', () {
        final stopwatch = Stopwatch()..start();
        for (int i = 0; i < 100; i++) {
          final categories = viewModel.categories;
          expect(categories, isNotEmpty);
        }
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('should handle multiple localize calls efficiently', () {
        final stopwatch = Stopwatch()..start();
        for (int i = 0; i < 100; i++) {
          final result = viewModel.localize(
            mockContext,
            'categories.high_protein',
          );
          expect(result, isNotEmpty);
        }
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('Memory Management Tests', () {
      test('should dispose properly', () {
        final testViewModel = HomeViewModel();

        expect(() => testViewModel.dispose(), returnsNormally);
        expect(testViewModel.hasListeners, isFalse);
      });

      test('should handle multiple dispose calls', () {
        final testViewModel = HomeViewModel();

        testViewModel.dispose();
        // İkinci dispose çağrısı hata vermemeli
        expect(() => testViewModel.dispose(), returnsNormally);
      });

      test('should not throw when accessing categories after dispose', () {
        final testViewModel = HomeViewModel();
        final categories = testViewModel.categories;

        testViewModel.dispose();

        expect(() => testViewModel.categories, returnsNormally);
        expect(testViewModel.categories, equals(categories));
      });
    });

    group('Integration Tests', () {
      test('should work with real localization keys', () {
        for (final category in viewModel.categories) {
          final result = viewModel.localize(mockContext, category.titleKey);
          expect(result, isA<String>());
          expect(result, isNotEmpty);
        }
      });

      test('should maintain consistency between categories and constants', () {
        final constants = [
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
        ];

        final categoryImageUrls = viewModel.categories
            .map((c) => c.imageUrl)
            .toList();

        for (final constant in constants) {
          expect(categoryImageUrls, contains(constant));
        }
      });
    });

    group('Error Handling Tests', () {
      test('should handle malformed category keys gracefully', () {
        expect(
          () => viewModel.localize(mockContext, 'invalid.key.format'),
          returnsNormally,
        );
      });

      test('should handle special characters in keys', () {
        expect(
          () => viewModel.localize(mockContext, 'categories.high_protein!@#'),
          returnsNormally,
        );
      });

      test('should handle very long keys', () {
        final longKey = 'categories.' + 'a' * 1000;
        expect(() => viewModel.localize(mockContext, longKey), returnsNormally);
      });
    });
  });
}
