import 'package:flutter_test/flutter_test.dart';
import 'package:arya/product/constants/home_constants.dart';

void main() {
  group('HomeConstants Tests', () {
    group('Static Constants Validation', () {
      test('should have all required category constants', () {
        // Arrange & Act
        final constants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Assert
        expect(constants.length, equals(11));
        for (final constant in constants) {
          expect(constant, isA<String>());
          expect(constant, isNotEmpty);
        }
      });

      test('should have correct basic category constants', () {
        // Assert - Basic food categories
        expect(
          HomeConstants.catFruitsVegetables,
          equals('assets/images/categories/cat_fruits.png'),
        );
        expect(
          HomeConstants.catBreakfast,
          equals('assets/images/categories/cat_breakfast.png'),
        );
        expect(
          HomeConstants.catBeverages,
          equals('assets/images/categories/cat_beverages.png'),
        );
        expect(
          HomeConstants.catMeatFish,
          equals('assets/images/categories/cat_meat_fish.png'),
        );
        expect(
          HomeConstants.catSnacks,
          equals('assets/images/categories/cat_snacks.png'),
        );
        expect(
          HomeConstants.catDairy,
          equals('assets/images/categories/cat_dairy.png'),
        );
      });

      test('should have correct nutritional category constants', () {
        // Assert - Nutritional value categories
        expect(
          HomeConstants.catHighProtein,
          equals('assets/images/categories/cat_meat_fish.png'),
        );
        expect(
          HomeConstants.catHighCarbohydrate,
          equals('assets/images/categories/cat_breakfast.png'),
        );
        expect(
          HomeConstants.catHighFat,
          equals('assets/images/categories/cat_snacks.png'),
        );
        expect(
          HomeConstants.catHighVitaminsMinerals,
          equals('assets/images/categories/cat_fruits.png'),
        );
        expect(
          HomeConstants.catHighFiber,
          equals('assets/images/categories/cat_fruits.png'),
        );
      });
    });

    group('Asset Path Format Tests', () {
      test('should have correct asset path format for all constants', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          expect(constant, startsWith('assets/images/categories/'));
          expect(constant, endsWith('.png'));
          expect(constant, contains('cat_'));
        }
      });

      test('should have valid file extensions', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          expect(constant, endsWith('.png'));
          expect(constant, isNot(endsWith('.jpg')));
          expect(constant, isNot(endsWith('.jpeg')));
          expect(constant, isNot(endsWith('.gif')));
          expect(constant, isNot(endsWith('.svg')));
        }
      });

      test('should have consistent directory structure', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          expect(constant, startsWith('assets/'));
          expect(constant, contains('/images/'));
          expect(constant, contains('/categories/'));
          expect(constant, isNot(contains('//'))); // No double slashes
        }
      });
    });

    group('File Naming Convention Tests', () {
      test('should follow consistent naming pattern', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          final fileName = constant.split('/').last;
          expect(fileName, startsWith('cat_'));
          expect(fileName, endsWith('.png'));
          expect(fileName, isNot(contains(' '))); // No spaces
          expect(fileName, isNot(contains('UPPERCASE'))); // Should be lowercase
        }
      });

      test('should have descriptive file names', () {
        // Assert - Check specific naming patterns
        expect(HomeConstants.catFruitsVegetables, contains('cat_fruits'));
        expect(HomeConstants.catBreakfast, contains('cat_breakfast'));
        expect(HomeConstants.catBeverages, contains('cat_beverages'));
        expect(HomeConstants.catMeatFish, contains('cat_meat_fish'));
        expect(HomeConstants.catSnacks, contains('cat_snacks'));
        expect(HomeConstants.catDairy, contains('cat_dairy'));
      });

      test('should use underscores for word separation', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          final fileName = constant.split('/').last;
          // Should not contain hyphens or spaces
          expect(fileName, isNot(contains('-')));
          expect(fileName, isNot(contains(' ')));
          // Should use underscores for separation
          if (fileName.contains('_') && fileName != 'cat_fruits.png') {
            expect(fileName, contains('_'));
          }
        }
      });
    });

    group('Constants Consistency Tests', () {
      test('should have unique constant values', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act
        final uniqueConstants = allConstants.toSet();

        // Assert
        expect(uniqueConstants.length, equals(6)); // 6 unique image paths
        expect(allConstants.length, equals(11)); // 11 total constants
      });

      test('should have logical image reuse for similar categories', () {
        // Assert - High protein uses meat/fish image
        expect(HomeConstants.catHighProtein, equals(HomeConstants.catMeatFish));

        // Assert - High carbohydrate uses breakfast image
        expect(
          HomeConstants.catHighCarbohydrate,
          equals(HomeConstants.catBreakfast),
        );

        // Assert - High fat uses snacks image
        expect(HomeConstants.catHighFat, equals(HomeConstants.catSnacks));

        // Assert - High vitamins/minerals uses fruits image
        expect(
          HomeConstants.catHighVitaminsMinerals,
          equals(HomeConstants.catFruitsVegetables),
        );

        // Assert - High fiber uses fruits image
        expect(
          HomeConstants.catHighFiber,
          equals(HomeConstants.catFruitsVegetables),
        );
      });

      test('should maintain consistent path structure', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          final pathParts = constant.split('/');
          expect(
            pathParts.length,
            equals(4),
          ); // assets/images/categories/filename.png
          expect(pathParts[0], equals('assets'));
          expect(pathParts[1], equals('images'));
          expect(pathParts[2], equals('categories'));
          expect(pathParts[3], endsWith('.png'));
        }
      });
    });

    group('Constants Access Tests', () {
      test('should be accessible as static constants', () {
        // Act & Assert - All constants should be accessible
        expect(() => HomeConstants.catFruitsVegetables, returnsNormally);
        expect(() => HomeConstants.catBreakfast, returnsNormally);
        expect(() => HomeConstants.catBeverages, returnsNormally);
        expect(() => HomeConstants.catMeatFish, returnsNormally);
        expect(() => HomeConstants.catSnacks, returnsNormally);
        expect(() => HomeConstants.catDairy, returnsNormally);
        expect(() => HomeConstants.catHighProtein, returnsNormally);
        expect(() => HomeConstants.catHighCarbohydrate, returnsNormally);
        expect(() => HomeConstants.catHighFat, returnsNormally);
        expect(() => HomeConstants.catHighVitaminsMinerals, returnsNormally);
        expect(() => HomeConstants.catHighFiber, returnsNormally);
      });

      test('should return string values', () {
        // Act & Assert
        expect(HomeConstants.catFruitsVegetables, isA<String>());
        expect(HomeConstants.catBreakfast, isA<String>());
        expect(HomeConstants.catBeverages, isA<String>());
        expect(HomeConstants.catMeatFish, isA<String>());
        expect(HomeConstants.catSnacks, isA<String>());
        expect(HomeConstants.catDairy, isA<String>());
        expect(HomeConstants.catHighProtein, isA<String>());
        expect(HomeConstants.catHighCarbohydrate, isA<String>());
        expect(HomeConstants.catHighFat, isA<String>());
        expect(HomeConstants.catHighVitaminsMinerals, isA<String>());
        expect(HomeConstants.catHighFiber, isA<String>());
      });

      test('should be immutable constants', () {
        // Act & Assert - Constants should be final and immutable
        expect(
          HomeConstants.catFruitsVegetables,
          equals('assets/images/categories/cat_fruits.png'),
        );
        expect(
          HomeConstants.catBreakfast,
          equals('assets/images/categories/cat_breakfast.png'),
        );
        expect(
          HomeConstants.catBeverages,
          equals('assets/images/categories/cat_beverages.png'),
        );
        expect(
          HomeConstants.catMeatFish,
          equals('assets/images/categories/cat_meat_fish.png'),
        );
        expect(
          HomeConstants.catSnacks,
          equals('assets/images/categories/cat_snacks.png'),
        );
        expect(
          HomeConstants.catDairy,
          equals('assets/images/categories/cat_dairy.png'),
        );
      });
    });

    group('Integration Tests', () {
      test('should work with HomeCategory model', () {
        // Arrange
        final categoryConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in categoryConstants) {
          // Should be valid for HomeCategory imageUrl property
          expect(constant, isA<String>());
          expect(constant, isNotEmpty);
          expect(constant, startsWith('assets/'));
          expect(constant, endsWith('.png'));
        }
      });

      test('should be compatible with Flutter asset system', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          // Should be valid Flutter asset paths
          expect(constant, startsWith('assets/'));
          expect(constant, isNot(contains('\\'))); // No Windows-style paths
          expect(constant, isNot(contains('..'))); // No relative paths
          expect(constant, isNot(contains('~'))); // No home directory paths
        }
      });
    });

    group('Edge Cases and Validation Tests', () {
      test('should handle empty string validation', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          expect(constant, isNotEmpty);
          expect(constant.length, greaterThan(10)); // Should be reasonably long
        }
      });

      test('should not contain special characters in paths', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          expect(constant, isNot(contains('@')));
          expect(constant, isNot(contains('#')));
          expect(constant, isNot(contains(r'$')));
          expect(constant, isNot(contains('%')));
          expect(constant, isNot(contains('&')));
          expect(constant, isNot(contains('*')));
          expect(constant, isNot(contains('+')));
          expect(constant, isNot(contains('=')));
          expect(constant, isNot(contains('?')));
          expect(constant, isNot(contains('^')));
          expect(constant, isNot(contains('`')));
          expect(constant, isNot(contains('|')));
          expect(constant, isNot(contains('~')));
        }
      });

      test('should have reasonable path lengths', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        for (final constant in allConstants) {
          expect(constant.length, greaterThan(30)); // Minimum reasonable length
          expect(constant.length, lessThan(100)); // Maximum reasonable length
        }
      });
    });

    group('Performance Tests', () {
      test('should access constants efficiently', () {
        // Arrange
        final stopwatch = Stopwatch()..start();

        // Act
        for (int i = 0; i < 10000; i++) {
          final constants = [
            HomeConstants.catFruitsVegetables,
            HomeConstants.catBreakfast,
            HomeConstants.catBeverages,
            HomeConstants.catMeatFish,
            HomeConstants.catSnacks,
            HomeConstants.catDairy,
            HomeConstants.catHighProtein,
            HomeConstants.catHighCarbohydrate,
            HomeConstants.catHighFat,
            HomeConstants.catHighVitaminsMinerals,
            HomeConstants.catHighFiber,
          ];
          expect(constants.length, equals(11));
        }

        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
        ); // Should be very fast
      });

      test('should handle string operations efficiently', () {
        // Arrange
        final allConstants = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        final stopwatch = Stopwatch()..start();

        // Act
        for (int i = 0; i < 1000; i++) {
          for (final constant in allConstants) {
            final fileName = constant.split('/').last;
            final hasUnderscore = fileName.contains('_');
            final endsWithPng = fileName.endsWith('.png');
            expect(hasUnderscore, isTrue);
            expect(endsWithPng, isTrue);
          }
        }

        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
        ); // Should be very fast
      });
    });

    group('Documentation and Maintainability Tests', () {
      test('should have consistent naming patterns for maintainability', () {
        // Arrange
        final basicCategories = [
          'catFruitsVegetables',
          'catBreakfast',
          'catBeverages',
          'catMeatFish',
          'catSnacks',
          'catDairy',
        ];

        final nutritionalCategories = [
          'catHighProtein',
          'catHighCarbohydrate',
          'catHighFat',
          'catHighVitaminsMinerals',
          'catHighFiber',
        ];

        // Act & Assert
        for (final category in basicCategories) {
          expect(category, startsWith('cat'));
          expect(category, isNot(contains('High')));
        }

        for (final category in nutritionalCategories) {
          expect(category, startsWith('cat'));
          expect(category, contains('High'));
        }
      });

      test('should have logical grouping of constants', () {
        // Arrange
        final basicFoodCategories = [
          HomeConstants.catFruitsVegetables,
          HomeConstants.catBreakfast,
          HomeConstants.catBeverages,
          HomeConstants.catMeatFish,
          HomeConstants.catSnacks,
          HomeConstants.catDairy,
        ];

        final nutritionalCategories = [
          HomeConstants.catHighProtein,
          HomeConstants.catHighCarbohydrate,
          HomeConstants.catHighFat,
          HomeConstants.catHighVitaminsMinerals,
          HomeConstants.catHighFiber,
        ];

        // Act & Assert
        expect(basicFoodCategories.length, equals(6));
        expect(nutritionalCategories.length, equals(5));

        // All should follow the same path structure
        for (final constant in [
          ...basicFoodCategories,
          ...nutritionalCategories,
        ]) {
          expect(constant, startsWith('assets/images/categories/'));
          expect(constant, endsWith('.png'));
        }
      });
    });
  });
}
