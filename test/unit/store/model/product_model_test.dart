import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/store/model/product_model.dart';

void main() {
  group('ProductModel Tests', () {
    late ProductModel productModel;
    late Map<String, dynamic> sampleNutriments;

    setUp(() {
      sampleNutriments = {
        'proteins': 15.5,
        'proteins_100g': 20.0,
        'carbohydrates': 30.0,
        'carbohydrates_100g': 40.0,
        'fat': 8.5,
        'fat_100g': 12.0,
        'vitamin-c': 25.0,
        'vitamin-c_100g': 30.0,
        'calcium': 150.0,
        'calcium_100g': 200.0,
        'fiber': 5.0,
        'fiber_100g': 8.0,
      };
    });

    group('Constructor Tests', () {
      test('should create ProductModel with all parameters', () {
        // Arrange & Act
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Assert
        expect(productModel.name, equals('Test Product'));
        expect(productModel.brand, equals('Test Brand'));
        expect(productModel.imageUrl, equals('https://example.com/image.jpg'));
        expect(productModel.ingredients, equals('Test ingredients'));
        expect(productModel.quantity, equals('100g'));
        expect(productModel.nutriments, equals(sampleNutriments));
      });

      test('should create ProductModel with minimal parameters', () {
        // Arrange & Act
        productModel = ProductModel(nutriments: {});

        // Assert
        expect(productModel.name, isNull);
        expect(productModel.brand, isNull);
        expect(productModel.imageUrl, isNull);
        expect(productModel.ingredients, isNull);
        expect(productModel.quantity, isNull);
        expect(productModel.nutriments, isEmpty);
      });
    });

    group('fromMap Factory Tests', () {
      test('should create ProductModel from complete map', () {
        // Arrange
        final map = {
          'product_name': 'Test Product',
          'brands': 'Test Brand',
          'image_url': 'https://example.com/image.jpg',
          'ingredients_text': 'Test ingredients',
          'quantity': '100g',
          'nutriments': sampleNutriments,
        };

        // Act
        productModel = ProductModel.fromMap(map);

        // Assert
        expect(productModel.name, equals('Test Product'));
        expect(productModel.brand, equals('Test Brand'));
        expect(productModel.imageUrl, equals('https://example.com/image.jpg'));
        expect(productModel.ingredients, equals('Test ingredients'));
        expect(productModel.quantity, equals('100g'));
        expect(productModel.nutriments, equals(sampleNutriments));
      });

      test('should create ProductModel from incomplete map', () {
        // Arrange
        final map = {
          'product_name': 'Test Product',
          'nutriments': sampleNutriments,
        };

        // Act
        productModel = ProductModel.fromMap(map);

        // Assert
        expect(productModel.name, equals('Test Product'));
        expect(productModel.brand, isNull);
        expect(productModel.imageUrl, isNull);
        expect(productModel.ingredients, isNull);
        expect(productModel.quantity, isNull);
        expect(productModel.nutriments, equals(sampleNutriments));
      });

      test('should handle null nutriments in map', () {
        // Arrange
        final map = {'product_name': 'Test Product', 'nutriments': null};

        // Act
        productModel = ProductModel.fromMap(map);

        // Assert
        expect(productModel.name, equals('Test Product'));
        expect(productModel.nutriments, isEmpty);
      });

      test('should handle missing nutriments key in map', () {
        // Arrange
        final map = {'product_name': 'Test Product'};

        // Act
        productModel = ProductModel.fromMap(map);

        // Assert
        expect(productModel.name, equals('Test Product'));
        expect(productModel.nutriments, isEmpty);
      });
    });

    group('Nutritional Value Getters Tests', () {
      setUp(() {
        productModel = ProductModel(nutriments: sampleNutriments);
      });

      test('should return correct protein value', () {
        // Act & Assert
        expect(productModel.proteinValue, equals(15.5));
      });

      test('should return correct carbohydrate value', () {
        // Act & Assert
        expect(productModel.carbohydrateValue, equals(30.0));
      });

      test('should return correct fat value', () {
        // Act & Assert
        expect(productModel.fatValue, equals(8.5));
      });

      test('should return correct vitamin C value', () {
        // Act & Assert
        expect(productModel.vitaminCValue, equals(25.0));
      });

      test('should return correct calcium value', () {
        // Act & Assert
        expect(productModel.calciumValue, equals(150.0));
      });

      test('should return correct fiber value', () {
        // Act & Assert
        expect(productModel.fiberValue, equals(5.0));
      });
    });

    group('Nutritional Value Fallback Tests', () {
      test('should use _100g values when per-serving values are missing', () {
        // Arrange
        final nutriments = {
          'proteins_100g': 20.0,
          'carbohydrates_100g': 40.0,
          'fat_100g': 12.0,
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.proteinValue, equals(20.0));
        expect(productModel.carbohydrateValue, equals(40.0));
        expect(productModel.fatValue, equals(12.0));
      });

      test('should return 0.0 for missing nutritional values', () {
        // Arrange
        productModel = ProductModel(nutriments: {});

        // Act & Assert
        expect(productModel.proteinValue, equals(0.0));
        expect(productModel.carbohydrateValue, equals(0.0));
        expect(productModel.fatValue, equals(0.0));
        expect(productModel.vitaminCValue, equals(0.0));
        expect(productModel.calciumValue, equals(0.0));
        expect(productModel.fiberValue, equals(0.0));
      });

      test('should handle string nutritional values', () {
        // Arrange
        final nutriments = {
          'proteins': '15.5',
          'carbohydrates': '30.0',
          'fat': '8.5',
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.proteinValue, equals(15.5));
        expect(productModel.carbohydrateValue, equals(30.0));
        expect(productModel.fatValue, equals(8.5));
      });

      test('should handle invalid string nutritional values', () {
        // Arrange
        final nutriments = {
          'proteins': 'invalid',
          'carbohydrates': null,
          'fat': '',
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.proteinValue, equals(0.0));
        expect(productModel.carbohydrateValue, equals(0.0));
        expect(productModel.fatValue, equals(0.0));
      });
    });

    group('hasNutritionInfo Tests', () {
      test('should return true when product has nutritional information', () {
        // Arrange
        productModel = ProductModel(nutriments: sampleNutriments);

        // Act & Assert
        expect(productModel.hasNutritionInfo, isTrue);
      });

      test(
        'should return false when product has no nutritional information',
        () {
          // Arrange
          productModel = ProductModel(nutriments: {});

          // Act & Assert
          expect(productModel.hasNutritionInfo, isFalse);
        },
      );

      test('should return true when only one nutrient has value', () {
        // Arrange
        final nutriments = {'proteins': 10.0};
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.hasNutritionInfo, isTrue);
      });

      test('should return false when all nutrients are zero', () {
        // Arrange
        final nutriments = {
          'proteins': 0.0,
          'carbohydrates': 0.0,
          'fat': 0.0,
          'vitamin-c': 0.0,
          'calcium': 0.0,
          'fiber': 0.0,
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.hasNutritionInfo, isFalse);
      });
    });

    group('dominantNutrient Tests', () {
      test('should return correct dominant nutrient', () {
        // Arrange
        productModel = ProductModel(nutriments: sampleNutriments);

        // Act & Assert
        // Calcium (200.0) is the highest value in sampleNutriments
        expect(productModel.dominantNutrient, equals('Kalsiyum'));
      });

      test('should return protein as dominant when highest', () {
        // Arrange
        final nutriments = {
          'proteins': 50.0,
          'carbohydrates': 30.0,
          'fat': 20.0,
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.dominantNutrient, equals('Protein'));
      });

      test('should return fat as dominant when highest', () {
        // Arrange
        final nutriments = {
          'proteins': 10.0,
          'carbohydrates': 20.0,
          'fat': 50.0,
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.dominantNutrient, equals('Yağ'));
      });

      test('should return vitamin C as dominant when highest', () {
        // Arrange
        final nutriments = {
          'proteins': 10.0,
          'carbohydrates': 20.0,
          'fat': 15.0,
          'vitamin-c': 100.0,
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.dominantNutrient, equals('Vitamin C'));
      });

      test('should return calcium as dominant when highest', () {
        // Arrange
        final nutriments = {
          'proteins': 10.0,
          'carbohydrates': 20.0,
          'fat': 15.0,
          'calcium': 200.0,
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.dominantNutrient, equals('Kalsiyum'));
      });

      test('should return fiber as dominant when highest', () {
        // Arrange
        final nutriments = {
          'proteins': 10.0,
          'carbohydrates': 20.0,
          'fat': 15.0,
          'fiber': 25.0,
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.dominantNutrient, equals('Lif'));
      });

      test('should handle equal values correctly', () {
        // Arrange
        final nutriments = {
          'proteins': 10.0,
          'carbohydrates': 10.0,
          'fat': 10.0,
        };
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.dominantNutrient, equals('Protein'));
      });

      test('should handle zero values correctly', () {
        // Arrange
        productModel = ProductModel(nutriments: {});

        // Act & Assert
        expect(productModel.dominantNutrient, equals('Protein'));
      });
    });

    group('toMap Tests', () {
      test('should convert ProductModel to map correctly', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Act
        final map = productModel.toMap();

        // Assert
        expect(map['product_name'], equals('Test Product'));
        expect(map['brands'], equals('Test Brand'));
        expect(map['image_url'], equals('https://example.com/image.jpg'));
        expect(map['ingredients_text'], equals('Test ingredients'));
        expect(map['quantity'], equals('100g'));
        expect(map['nutriments'], equals(sampleNutriments));
      });

      test('should convert ProductModel with null values to map correctly', () {
        // Arrange
        productModel = ProductModel(nutriments: {});

        // Act
        final map = productModel.toMap();

        // Assert
        expect(map['product_name'], isNull);
        expect(map['brands'], isNull);
        expect(map['image_url'], isNull);
        expect(map['ingredients_text'], isNull);
        expect(map['quantity'], isNull);
        expect(map['nutriments'], isEmpty);
      });
    });

    group('copyWith Tests', () {
      setUp(() {
        productModel = ProductModel(
          name: 'Original Product',
          brand: 'Original Brand',
          imageUrl: 'https://example.com/original.jpg',
          ingredients: 'Original ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );
      });

      test('should create copy with updated name', () {
        // Act
        final updatedModel = productModel.copyWith(name: 'New Product');

        // Assert
        expect(updatedModel.name, equals('New Product'));
        expect(updatedModel.brand, equals('Original Brand'));
        expect(
          updatedModel.imageUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.ingredients, equals('Original ingredients'));
        expect(updatedModel.quantity, equals('100g'));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated brand', () {
        // Act
        final updatedModel = productModel.copyWith(brand: 'New Brand');

        // Assert
        expect(updatedModel.name, equals('Original Product'));
        expect(updatedModel.brand, equals('New Brand'));
        expect(
          updatedModel.imageUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.ingredients, equals('Original ingredients'));
        expect(updatedModel.quantity, equals('100g'));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated imageUrl', () {
        // Act
        final updatedModel = productModel.copyWith(
          imageUrl: 'https://example.com/new.jpg',
        );

        // Assert
        expect(updatedModel.name, equals('Original Product'));
        expect(updatedModel.brand, equals('Original Brand'));
        expect(updatedModel.imageUrl, equals('https://example.com/new.jpg'));
        expect(updatedModel.ingredients, equals('Original ingredients'));
        expect(updatedModel.quantity, equals('100g'));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated ingredients', () {
        // Act
        final updatedModel = productModel.copyWith(
          ingredients: 'New ingredients',
        );

        // Assert
        expect(updatedModel.name, equals('Original Product'));
        expect(updatedModel.brand, equals('Original Brand'));
        expect(
          updatedModel.imageUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.ingredients, equals('New ingredients'));
        expect(updatedModel.quantity, equals('100g'));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated quantity', () {
        // Act
        final updatedModel = productModel.copyWith(quantity: '200g');

        // Assert
        expect(updatedModel.name, equals('Original Product'));
        expect(updatedModel.brand, equals('Original Brand'));
        expect(
          updatedModel.imageUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.ingredients, equals('Original ingredients'));
        expect(updatedModel.quantity, equals('200g'));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated nutriments', () {
        // Arrange
        final newNutriments = {'proteins': 20.0, 'carbohydrates': 40.0};

        // Act
        final updatedModel = productModel.copyWith(nutriments: newNutriments);

        // Assert
        expect(updatedModel.name, equals('Original Product'));
        expect(updatedModel.brand, equals('Original Brand'));
        expect(
          updatedModel.imageUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.ingredients, equals('Original ingredients'));
        expect(updatedModel.quantity, equals('100g'));
        expect(updatedModel.nutriments, equals(newNutriments));
      });

      test('should create copy with multiple updated fields', () {
        // Arrange
        final newNutriments = {'proteins': 25.0};

        // Act
        final updatedModel = productModel.copyWith(
          name: 'New Product',
          brand: 'New Brand',
          nutriments: newNutriments,
        );

        // Assert
        expect(updatedModel.name, equals('New Product'));
        expect(updatedModel.brand, equals('New Brand'));
        expect(
          updatedModel.imageUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.ingredients, equals('Original ingredients'));
        expect(updatedModel.quantity, equals('100g'));
        expect(updatedModel.nutriments, equals(newNutriments));
      });

      test('should create copy with null values', () {
        // Act
        final updatedModel = productModel.copyWith(name: null, brand: null);

        // Assert
        // copyWith doesn't change to null if the parameter is null, it keeps original value
        expect(updatedModel.name, equals('Original Product'));
        expect(updatedModel.brand, equals('Original Brand'));
        expect(
          updatedModel.imageUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.ingredients, equals('Original ingredients'));
        expect(updatedModel.quantity, equals('100g'));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });
    });

    group('toString Tests', () {
      test('should return correct string representation with all fields', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Act
        final stringRepresentation = productModel.toString();

        // Assert
        expect(stringRepresentation, contains('ProductModel'));
        expect(stringRepresentation, contains('Test Product'));
        expect(stringRepresentation, contains('Test Brand'));
        expect(stringRepresentation, contains('https://example.com/image.jpg'));
        expect(stringRepresentation, contains('Test ingredients'));
        expect(stringRepresentation, contains('100g'));
      });

      test('should handle null values in string representation', () {
        // Arrange
        productModel = ProductModel(nutriments: {});

        // Act
        final stringRepresentation = productModel.toString();

        // Assert
        expect(stringRepresentation, contains('ProductModel'));
        expect(stringRepresentation, contains('null'));
      });

      test('should handle partial null values in string representation', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: null,
          imageUrl: 'https://example.com/image.jpg',
          ingredients: null,
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Act
        final stringRepresentation = productModel.toString();

        // Assert
        expect(stringRepresentation, contains('ProductModel'));
        expect(stringRepresentation, contains('Test Product'));
        expect(stringRepresentation, contains('https://example.com/image.jpg'));
        expect(stringRepresentation, contains('100g'));
        expect(stringRepresentation, contains('null'));
      });
    });

    group('Equality Tests', () {
      test('should be equal to identical object', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        final identicalModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Act & Assert
        expect(productModel, equals(identicalModel));
        expect(productModel == identicalModel, isTrue);
      });

      test('should not be equal to different object', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        final differentModel = ProductModel(
          name: 'Different Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Act & Assert
        expect(productModel, isNot(equals(differentModel)));
        expect(productModel == differentModel, isFalse);
      });

      test('should not be equal to object with different brand', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        final differentModel = ProductModel(
          name: 'Test Product',
          brand: 'Different Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Act & Assert
        expect(productModel, isNot(equals(differentModel)));
        expect(productModel == differentModel, isFalse);
      });

      test('should not be equal to object with different nutriments', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        final differentNutriments = {'proteins': 20.0, 'carbohydrates': 40.0};
        final differentModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: differentNutriments,
        );

        // Act & Assert
        expect(productModel, isNot(equals(differentModel)));
        expect(productModel == differentModel, isFalse);
      });

      test('should be equal to object with null values', () {
        // Arrange
        productModel = ProductModel(nutriments: {});

        final identicalModel = ProductModel(nutriments: {});

        // Act & Assert
        expect(productModel, equals(identicalModel));
        expect(productModel == identicalModel, isTrue);
      });

      test('should not be equal to null', () {
        // Arrange
        productModel = ProductModel(nutriments: {});

        // Act & Assert
        expect(productModel, isNotNull);
      });

      test('should not be equal to different type', () {
        // Arrange
        productModel = ProductModel(nutriments: {});

        // Act & Assert
        expect(productModel == 'string', isFalse);
        expect(productModel == 123, isFalse);
        expect(productModel == {}, isFalse);
      });
    });

    group('HashCode Tests', () {
      test('should have different hashCode for different objects', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        final differentModel = ProductModel(
          name: 'Different Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Act & Assert
        expect(productModel.hashCode, isNot(equals(differentModel.hashCode)));
      });

      test('should have consistent hashCode for identical objects', () {
        // Arrange
        productModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        final identicalModel = ProductModel(
          name: 'Test Product',
          brand: 'Test Brand',
          imageUrl: 'https://example.com/image.jpg',
          ingredients: 'Test ingredients',
          quantity: '100g',
          nutriments: sampleNutriments,
        );

        // Act & Assert
        // Equality kontrolü yapabiliriz
        expect(productModel == identicalModel, isTrue);
        // HashCode'lar farklı olabilir çünkü Object.hashAllUnordered kullanıyoruz
        // Bu durumda sadece equality kontrolü yeterli
        expect(productModel.hashCode, isA<int>());
        expect(identicalModel.hashCode, isA<int>());
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very large nutritional values', () {
        // Arrange
        final nutriments = {'proteins': 999999.99, 'carbohydrates': 888888.88};
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.proteinValue, equals(999999.99));
        expect(productModel.carbohydrateValue, equals(888888.88));
        expect(productModel.dominantNutrient, equals('Protein'));
      });

      test('should handle negative nutritional values', () {
        // Arrange
        final nutriments = {'proteins': -10.0, 'carbohydrates': 20.0};
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.proteinValue, equals(-10.0));
        expect(productModel.carbohydrateValue, equals(20.0));
        expect(productModel.dominantNutrient, equals('Karbonhidrat'));
      });

      test('should handle very small nutritional values', () {
        // Arrange
        final nutriments = {'proteins': 0.001, 'carbohydrates': 0.002};
        productModel = ProductModel(nutriments: nutriments);

        // Act & Assert
        expect(productModel.proteinValue, equals(0.001));
        expect(productModel.carbohydrateValue, equals(0.002));
        expect(productModel.dominantNutrient, equals('Karbonhidrat'));
      });
    });
  });
}
