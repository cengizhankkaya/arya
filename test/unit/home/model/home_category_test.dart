import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:arya/features/home/model/home_category.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/product/constants/home_constants.dart';

import 'home_category_test.mocks.dart';

// Mock sınıfları generate etmek için annotation
@GenerateMocks([HomeCategory])
void main() {
  group('HomeCategory Model Tests', () {
    late HomeCategoryFactory categoryFactory;
    late CategoryPaletteFactory paletteFactory;

    setUp(() {
      categoryFactory = HomeCategoryFactory();
      paletteFactory = CategoryPaletteFactory();
    });

    group('Constructor and Factory Tests', () {
      test('should create HomeCategory with factory method', () {
        // Arrange
        final expectedTitleKey = 'categories.test';
        final expectedImageUrl = 'assets/images/test.png';
        final expectedPalette = CategoryPalette.highProtein;

        // Act
        final category = categoryFactory.create(
          titleKey: expectedTitleKey,
          imageUrl: expectedImageUrl,
          palette: expectedPalette,
        );

        // Assert
        expect(category, isA<HomeCategory>());
        expect(category.titleKey, equals(expectedTitleKey));
        expect(category.imageUrl, equals(expectedImageUrl));
        expect(category.palette, equals(expectedPalette));
      });

      test('should create HomeCategory with const constructor', () {
        // Arrange & Act
        const category = HomeCategory(
          titleKey: 'categories.const_test',
          imageUrl: 'assets/images/const_test.png',
          palette: CategoryPalette.breakfast,
        );

        // Assert
        expect(category.titleKey, equals('categories.const_test'));
        expect(category.imageUrl, equals('assets/images/const_test.png'));
        expect(category.palette, equals(CategoryPalette.breakfast));
      });

      test('should create HomeCategory with all CategoryPalette values', () {
        // Arrange
        final allPalettes = CategoryPalette.values;

        // Act & Assert
        for (final palette in allPalettes) {
          final category = categoryFactory.createWithPalette(palette);

          expect(category.palette, equals(palette));
          expect(category.titleKey, isNotEmpty);
          expect(category.imageUrl, isNotEmpty);
        }
      });
    });

    group('Property Validation Tests', () {
      late HomeCategory testCategory;

      setUp(() {
        testCategory = categoryFactory.create(
          titleKey: 'categories.validation_test',
          imageUrl: 'assets/images/validation_test.png',
          palette: CategoryPalette.highProtein,
        );
      });

      test('should have correct titleKey property', () {
        // Assert
        expect(testCategory.titleKey, equals('categories.validation_test'));
        expect(testCategory.titleKey, isA<String>());
        expect(testCategory.titleKey, isNotEmpty);
        expect(testCategory.titleKey, startsWith('categories.'));
      });

      test('should have correct imageUrl property', () {
        // Assert
        expect(
          testCategory.imageUrl,
          equals('assets/images/validation_test.png'),
        );
        expect(testCategory.imageUrl, isA<String>());
        expect(testCategory.imageUrl, isNotEmpty);
        expect(testCategory.imageUrl, endsWith('.png'));
      });

      test('should have correct palette property', () {
        // Assert
        expect(testCategory.palette, equals(CategoryPalette.highProtein));
        expect(testCategory.palette, isA<CategoryPalette>());
        expect(CategoryPalette.values, contains(testCategory.palette));
      });

      test('should maintain immutability', () {
        // Assert - Properties should be final and immutable
        expect(testCategory.titleKey, equals('categories.validation_test'));
        expect(
          testCategory.imageUrl,
          equals('assets/images/validation_test.png'),
        );
        expect(testCategory.palette, equals(CategoryPalette.highProtein));
      });
    });

    group('Equality and HashCode Tests', () {
      test('should be equal when all properties are identical', () {
        // Arrange
        final category1 = categoryFactory.create(
          titleKey: 'categories.equality_test',
          imageUrl: 'assets/images/equality_test.png',
          palette: CategoryPalette.highProtein,
        );

        final category2 = categoryFactory.create(
          titleKey: 'categories.equality_test',
          imageUrl: 'assets/images/equality_test.png',
          palette: CategoryPalette.highProtein,
        );

        // Act & Assert
        expect(category1, equals(category2));
        expect(category1.hashCode, equals(category2.hashCode));
        expect(category1 == category2, isTrue);
      });

      test('should not be equal when titleKey differs', () {
        // Arrange
        final category1 = categoryFactory.create(
          titleKey: 'categories.test1',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        final category2 = categoryFactory.create(
          titleKey: 'categories.test2',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        // Act & Assert
        expect(category1, isNot(equals(category2)));
        expect(category1.hashCode, isNot(equals(category2.hashCode)));
        expect(category1 == category2, isFalse);
      });

      test('should not be equal when imageUrl differs', () {
        // Arrange
        final category1 = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test1.png',
          palette: CategoryPalette.highProtein,
        );

        final category2 = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test2.png',
          palette: CategoryPalette.highProtein,
        );

        // Act & Assert
        expect(category1, isNot(equals(category2)));
        expect(category1.hashCode, isNot(equals(category2.hashCode)));
        expect(category1 == category2, isFalse);
      });

      test('should not be equal when palette differs', () {
        // Arrange
        final category1 = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        final category2 = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.breakfast,
        );

        // Act & Assert
        expect(category1, isNot(equals(category2)));
        expect(category1.hashCode, isNot(equals(category2.hashCode)));
        expect(category1 == category2, isFalse);
      });

      test('should handle null equality correctly', () {
        // Arrange
        final category = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        // Act & Assert
        expect(category, isNot(equals(null)));
        expect(category == null, isFalse);
      });

      test('should handle different type equality correctly', () {
        // Arrange
        final category = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        // Act & Assert
        expect(category, isNot(equals('string')));
        expect(category, isNot(equals(123)));
        expect(category, isNot(equals({})));
        expect(category, isNot(equals([])));
      });
    });

    group('CategoryPalette Integration Tests', () {
      test('should work with all CategoryPalette enum values', () {
        // Arrange
        final allPalettes = CategoryPalette.values;

        // Act & Assert
        for (final palette in allPalettes) {
          final category = categoryFactory.createWithPalette(palette);

          expect(category.palette, equals(palette));
          expect(category.palette.name, isNotEmpty);
          expect(CategoryPalette.values, contains(category.palette));
        }
      });

      test('should maintain palette consistency', () {
        // Arrange
        final palette = CategoryPalette.highProtein;
        final category1 = categoryFactory.createWithPalette(palette);
        final category2 = categoryFactory.createWithPalette(palette);

        // Act & Assert
        expect(category1.palette, equals(category2.palette));
        expect(category1.palette.name, equals(category2.palette.name));
      });
    });

    group('Edge Cases and Boundary Tests', () {
      test('should handle empty titleKey', () {
        // Arrange & Act
        final category = categoryFactory.create(
          titleKey: '',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        // Assert
        expect(category.titleKey, equals(''));
        expect(category.titleKey, isEmpty);
      });

      test('should handle empty imageUrl', () {
        // Arrange & Act
        final category = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: '',
          palette: CategoryPalette.highProtein,
        );

        // Assert
        expect(category.imageUrl, equals(''));
        expect(category.imageUrl, isEmpty);
      });

      test('should handle very long titleKey', () {
        // Arrange
        final longKey = 'categories.' + 'a' * 1000;

        // Act
        final category = categoryFactory.create(
          titleKey: longKey,
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        // Assert
        expect(category.titleKey, equals(longKey));
        expect(category.titleKey.length, greaterThan(1000));
      });

      test('should handle special characters in titleKey', () {
        // Arrange
        const specialKey = 'categories.test-key_with.special@chars#123';

        // Act
        final category = categoryFactory.create(
          titleKey: specialKey,
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        // Assert
        expect(category.titleKey, equals(specialKey));
        expect(category.titleKey, contains('@'));
        expect(category.titleKey, contains('#'));
        expect(category.titleKey, contains('-'));
      });

      test('should handle URL as imageUrl', () {
        // Arrange
        const urlImage = 'https://example.com/images/test.png';

        // Act
        final category = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: urlImage,
          palette: CategoryPalette.highProtein,
        );

        // Assert
        expect(category.imageUrl, equals(urlImage));
        expect(category.imageUrl, startsWith('https://'));
        expect(category.imageUrl, endsWith('.png'));
      });

      test('should handle special characters in imageUrl', () {
        // Arrange
        const specialImageUrl =
            'assets/images/test-image_with.special@chars#123.png';

        // Act
        final category = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: specialImageUrl,
          palette: CategoryPalette.highProtein,
        );

        // Assert
        expect(category.imageUrl, equals(specialImageUrl));
        expect(category.imageUrl, contains('@'));
        expect(category.imageUrl, contains('#'));
        expect(category.imageUrl, contains('-'));
      });
    });

    group('HomeConstants Integration Tests', () {
      test('should work with all HomeConstants image paths', () {
        // Arrange
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

        // Act & Assert
        for (int i = 0; i < constants.length; i++) {
          final category = categoryFactory.create(
            titleKey: 'categories.test_$i',
            imageUrl: constants[i],
            palette: CategoryPalette.values[i % CategoryPalette.values.length],
          );

          expect(category.imageUrl, equals(constants[i]));
          expect(category.imageUrl, startsWith('assets/images/categories/'));
          expect(category.imageUrl, endsWith('.png'));
        }
      });

      test('should maintain consistency with HomeConstants', () {
        // Arrange
        final categories = [
          const HomeCategory(
            titleKey: 'categories.fruits_vegetables',
            imageUrl: HomeConstants.catFruitsVegetables,
            palette: CategoryPalette.fruitsVegetables,
          ),
          const HomeCategory(
            titleKey: 'categories.breakfast',
            imageUrl: HomeConstants.catBreakfast,
            palette: CategoryPalette.breakfast,
          ),
          const HomeCategory(
            titleKey: 'categories.beverages',
            imageUrl: HomeConstants.catBeverages,
            palette: CategoryPalette.beverages,
          ),
          const HomeCategory(
            titleKey: 'categories.meat_fish',
            imageUrl: HomeConstants.catMeatFish,
            palette: CategoryPalette.meatFish,
          ),
          const HomeCategory(
            titleKey: 'categories.snacks',
            imageUrl: HomeConstants.catSnacks,
            palette: CategoryPalette.snacks,
          ),
          const HomeCategory(
            titleKey: 'categories.dairy',
            imageUrl: HomeConstants.catDairy,
            palette: CategoryPalette.dairy,
          ),
          const HomeCategory(
            titleKey: 'categories.high_protein',
            imageUrl: HomeConstants.catHighProtein,
            palette: CategoryPalette.highProtein,
          ),
          const HomeCategory(
            titleKey: 'categories.high_carbohydrate',
            imageUrl: HomeConstants.catHighCarbohydrate,
            palette: CategoryPalette.highCarbohydrate,
          ),
          const HomeCategory(
            titleKey: 'categories.high_fat',
            imageUrl: HomeConstants.catHighFat,
            palette: CategoryPalette.highFat,
          ),
          const HomeCategory(
            titleKey: 'categories.high_vitamins_minerals',
            imageUrl: HomeConstants.catHighVitaminsMinerals,
            palette: CategoryPalette.highVitaminsMinerals,
          ),
          const HomeCategory(
            titleKey: 'categories.high_fiber',
            imageUrl: HomeConstants.catHighFiber,
            palette: CategoryPalette.highFiber,
          ),
        ];

        // Act & Assert
        expect(categories.length, equals(11));

        for (final category in categories) {
          expect(category.titleKey, isNotEmpty);
          expect(category.titleKey, startsWith('categories.'));
          expect(category.imageUrl, isNotEmpty);
          expect(category.imageUrl, startsWith('assets/images/categories/'));
          expect(category.palette, isA<CategoryPalette>());
        }

        // Test unique title keys
        final titleKeys = categories.map((c) => c.titleKey).toList();
        final uniqueTitleKeys = titleKeys.toSet();
        expect(uniqueTitleKeys.length, equals(titleKeys.length));

        // Test image URL distribution (some may be reused)
        final imageUrls = categories.map((c) => c.imageUrl).toList();
        final uniqueImageUrls = imageUrls.toSet();
        expect(uniqueImageUrls.length, equals(6)); // 6 unique image URLs
      });
    });

    group('Collection and List Operations Tests', () {
      test('should work with List operations', () {
        // Arrange
        final categories = [
          categoryFactory.create(
            titleKey: 'categories.test1',
            imageUrl: 'assets/images/test1.png',
            palette: CategoryPalette.highProtein,
          ),
          categoryFactory.create(
            titleKey: 'categories.test2',
            imageUrl: 'assets/images/test2.png',
            palette: CategoryPalette.breakfast,
          ),
          categoryFactory.create(
            titleKey: 'categories.test3',
            imageUrl: 'assets/images/test3.png',
            palette: CategoryPalette.beverages,
          ),
        ];

        // Act & Assert
        expect(categories.length, equals(3));
        expect(categories.first.titleKey, equals('categories.test1'));
        expect(categories.last.titleKey, equals('categories.test3'));

        // Test filtering
        final proteinCategories = categories
            .where((c) => c.palette == CategoryPalette.highProtein)
            .toList();
        expect(proteinCategories.length, equals(1));
        expect(proteinCategories.first.titleKey, equals('categories.test1'));

        // Test mapping
        final titleKeys = categories.map((c) => c.titleKey).toList();
        expect(titleKeys, contains('categories.test1'));
        expect(titleKeys, contains('categories.test2'));
        expect(titleKeys, contains('categories.test3'));

        // Test sorting
        final sortedCategories = List.from(categories)
          ..sort((a, b) => a.titleKey.compareTo(b.titleKey));
        expect(sortedCategories.first.titleKey, equals('categories.test1'));
        expect(sortedCategories.last.titleKey, equals('categories.test3'));
      });

      test('should work with Set operations', () {
        // Arrange
        final category1 = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        final category2 = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        final category3 = categoryFactory.create(
          titleKey: 'categories.different',
          imageUrl: 'assets/images/different.png',
          palette: CategoryPalette.breakfast,
        );

        // Act
        final categorySet = {category1, category2, category3};

        // Assert
        expect(
          categorySet.length,
          equals(2),
        ); // category1 and category2 are equal
        expect(categorySet, contains(category1));
        expect(categorySet, contains(category3));
      });

      test('should work with Map operations', () {
        // Arrange
        final categories = [
          categoryFactory.create(
            titleKey: 'categories.test1',
            imageUrl: 'assets/images/test1.png',
            palette: CategoryPalette.highProtein,
          ),
          categoryFactory.create(
            titleKey: 'categories.test2',
            imageUrl: 'assets/images/test2.png',
            palette: CategoryPalette.breakfast,
          ),
        ];

        // Act
        final categoryMap = {
          for (final category in categories) category.titleKey: category,
        };

        // Assert
        expect(categoryMap.length, equals(2));
        expect(categoryMap['categories.test1'], equals(categories[0]));
        expect(categoryMap['categories.test2'], equals(categories[1]));
      });
    });

    group('Performance and Memory Tests', () {
      test('should create many categories efficiently', () {
        // Arrange
        final stopwatch = Stopwatch()..start();

        // Act
        final categories = List.generate(1000, (index) {
          return categoryFactory.create(
            titleKey: 'categories.test_$index',
            imageUrl: 'assets/images/test_$index.png',
            palette:
                CategoryPalette.values[index % CategoryPalette.values.length],
          );
        });

        stopwatch.stop();

        // Assert
        expect(categories.length, equals(1000));
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
        ); // Should be very fast
      });

      test('should handle equality comparisons efficiently', () {
        // Arrange
        final category1 = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        final category2 = categoryFactory.create(
          titleKey: 'categories.test',
          imageUrl: 'assets/images/test.png',
          palette: CategoryPalette.highProtein,
        );

        final stopwatch = Stopwatch()..start();

        // Act
        for (int i = 0; i < 10000; i++) {
          expect(category1 == category2, isTrue);
          expect(category1.hashCode == category2.hashCode, isTrue);
        }

        stopwatch.stop();

        // Assert
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(100),
        ); // Should be very fast
      });

      test('should handle hashCode distribution well', () {
        // Arrange
        final categories = List.generate(100, (index) {
          return categoryFactory.create(
            titleKey: 'categories.test_$index',
            imageUrl: 'assets/images/test_$index.png',
            palette:
                CategoryPalette.values[index % CategoryPalette.values.length],
          );
        });

        // Act
        final hashCodes = categories.map((c) => c.hashCode).toSet();

        // Assert
        expect(
          hashCodes.length,
          equals(100),
        ); // All hash codes should be unique
      });
    });

    group('Mock and Dependency Injection Tests', () {
      late MockHomeCategory mockCategory;

      setUp(() {
        mockCategory = MockHomeCategory();
      });

      test('should work with mock objects', () {
        // Arrange
        when(mockCategory.titleKey).thenReturn('categories.mock_test');
        when(mockCategory.imageUrl).thenReturn('assets/images/mock_test.png');
        when(mockCategory.palette).thenReturn(CategoryPalette.highProtein);

        // Act
        final titleKey = mockCategory.titleKey;
        final imageUrl = mockCategory.imageUrl;
        final palette = mockCategory.palette;

        // Assert
        expect(titleKey, equals('categories.mock_test'));
        expect(imageUrl, equals('assets/images/mock_test.png'));
        expect(palette, equals(CategoryPalette.highProtein));

        verify(mockCategory.titleKey).called(1);
        verify(mockCategory.imageUrl).called(1);
        verify(mockCategory.palette).called(1);
      });

      test('should work with real CategoryPalette enum', () {
        // Arrange
        final realPalette = CategoryPalette.highProtein;

        // Act
        final name = realPalette.name;
        final index = realPalette.index;

        // Assert
        expect(name, equals('highProtein'));
        expect(index, equals(6));
        expect(CategoryPalette.values, contains(realPalette));
      });

      test('should integrate mocks with real objects', () {
        // Arrange
        when(mockCategory.titleKey).thenReturn('categories.integration_test');
        when(
          mockCategory.imageUrl,
        ).thenReturn('assets/images/integration_test.png');
        when(mockCategory.palette).thenReturn(CategoryPalette.highProtein);

        final realCategory = categoryFactory.create(
          titleKey: 'categories.real_test',
          imageUrl: 'assets/images/real_test.png',
          palette: CategoryPalette.breakfast,
        );

        // Act
        final mockTitleKey = mockCategory.titleKey;
        final realTitleKey = realCategory.titleKey;

        // Assert
        expect(mockTitleKey, equals('categories.integration_test'));
        expect(realTitleKey, equals('categories.real_test'));
        expect(mockTitleKey, isNot(equals(realTitleKey)));

        verify(mockCategory.titleKey).called(1);
      });
    });
  });
}

/// Factory class for creating HomeCategory instances with dependency injection
class HomeCategoryFactory {
  /// Creates a HomeCategory with the specified parameters
  HomeCategory create({
    required String titleKey,
    required String imageUrl,
    required CategoryPalette palette,
  }) {
    return HomeCategory(
      titleKey: titleKey,
      imageUrl: imageUrl,
      palette: palette,
    );
  }

  /// Creates a HomeCategory with a specific palette and generated title/image
  HomeCategory createWithPalette(CategoryPalette palette) {
    return HomeCategory(
      titleKey: 'categories.${palette.name}',
      imageUrl: 'assets/images/categories/${palette.name}.png',
      palette: palette,
    );
  }

  /// Creates a HomeCategory with default test values
  HomeCategory createDefault() {
    return HomeCategory(
      titleKey: 'categories.default_test',
      imageUrl: 'assets/images/default_test.png',
      palette: CategoryPalette.highProtein,
    );
  }

  /// Creates multiple HomeCategory instances
  List<HomeCategory> createMultiple(int count) {
    return List.generate(count, (index) {
      return create(
        titleKey: 'categories.test_$index',
        imageUrl: 'assets/images/test_$index.png',
        palette: CategoryPalette.values[index % CategoryPalette.values.length],
      );
    });
  }
}

/// Factory class for CategoryPalette operations
class CategoryPaletteFactory {
  /// Gets all available palettes
  List<CategoryPalette> getAllPalettes() {
    return CategoryPalette.values;
  }

  /// Gets a random palette
  CategoryPalette getRandomPalette() {
    final palettes = CategoryPalette.values;
    return palettes[DateTime.now().millisecond % palettes.length];
  }

  /// Gets palettes by name pattern
  List<CategoryPalette> getPalettesByNamePattern(String pattern) {
    return CategoryPalette.values
        .where((palette) => palette.name.contains(pattern))
        .toList();
  }
}
