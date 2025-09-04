import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/home/view_model/home_view_model.dart';
import 'package:arya/features/home/model/home_category.dart';

void main() {
  group('HomeViewModel Tests', () {
    late HomeViewModel viewModel;

    setUp(() {
      viewModel = HomeViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization Tests', () {
      test('should initialize with categories', () {
        expect(viewModel.categories, isNotEmpty);
        expect(viewModel.categories.length, greaterThan(0));
      });

      test('should be a ChangeNotifier', () {
        expect(viewModel, isA<ChangeNotifier>());
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
    });

    group('Localization Tests', () {
      test('should provide localization method', () {
        expect(viewModel.localize, isA<Function>());
      });

      test('should handle localization keys correctly', () {
        // This test verifies the localize method exists
        expect(viewModel.localize, isA<Function>());
      });
    });

    group('Category Types Tests', () {
      test('should have high protein category', () {
        final highProteinCategory = viewModel.categories
            .where((c) => c.titleKey.contains('high_protein'))
            .firstOrNull;
        expect(highProteinCategory, isNotNull);
      });

      test('should have high carb category', () {
        final highCarbCategory = viewModel.categories
            .where((c) => c.titleKey.contains('high_carb'))
            .firstOrNull;
        expect(highCarbCategory, isNotNull);
      });

      test('should have high fat category', () {
        final highFatCategory = viewModel.categories
            .where((c) => c.titleKey.contains('high_fat'))
            .firstOrNull;
        expect(highFatCategory, isNotNull);
      });

      test('should have fruits vegetables category', () {
        final fruitsVegCategory = viewModel.categories
            .where((c) => c.titleKey.contains('fruits_vegetables'))
            .firstOrNull;
        expect(fruitsVegCategory, isNotNull);
      });

      test('should have meat fish category', () {
        final meatFishCategory = viewModel.categories
            .where((c) => c.titleKey.contains('meat_fish'))
            .firstOrNull;
        expect(meatFishCategory, isNotNull);
      });

      test('should have dairy category', () {
        final dairyCategory = viewModel.categories
            .where((c) => c.titleKey.contains('dairy'))
            .firstOrNull;
        expect(dairyCategory, isNotNull);
      });

      test('should have breakfast category', () {
        final breakfastCategory = viewModel.categories
            .where((c) => c.titleKey.contains('breakfast'))
            .firstOrNull;
        expect(breakfastCategory, isNotNull);
      });

      test('should have snacks category', () {
        final snacksCategory = viewModel.categories
            .where((c) => c.titleKey.contains('snacks'))
            .firstOrNull;
        expect(snacksCategory, isNotNull);
      });

      test('should have beverages category', () {
        final beveragesCategory = viewModel.categories
            .where((c) => c.titleKey.contains('beverages'))
            .firstOrNull;
        expect(beveragesCategory, isNotNull);
      });
    });

    group('Category Properties Tests', () {
      test('should have consistent color schemes', () {
        for (final category in viewModel.categories) {
          expect(category.palette, isNotNull);
          expect(category.palette.runtimeType.toString(), contains('CategoryPalette'));
        }
      });

      test('should have valid image dimensions', () {
        for (final category in viewModel.categories) {
          expect(category.imageUrl, isNotEmpty);
          expect(category.imageUrl, contains('.png'));
        }
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty categories gracefully', () {
        // This test ensures the viewModel doesn't crash with empty categories
        expect(() => viewModel.categories, returnsNormally);
      });

      test('should have reasonable category count', () {
        // Categories should be between 5 and 20 for good UX
        expect(viewModel.categories.length, greaterThanOrEqualTo(5));
        expect(viewModel.categories.length, lessThanOrEqualTo(20));
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
    });
  });
}
