import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/store/model/cart_item_model.dart';

void main() {
  group('CartItemModel Tests', () {
    late CartItemModel cartItemModel;
    late Map<String, dynamic> sampleNutriments;

    setUp(() {
      sampleNutriments = {
        'proteins': 15.5,
        'carbohydrates': 30.0,
        'fat': 8.5,
        'vitamin-c': 25.0,
        'calcium': 150.0,
        'fiber': 5.0,
      };
    });

    group('Constructor Tests', () {
      test('should create CartItemModel with all parameters', () {
        // Arrange & Act
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        // Assert
        expect(cartItemModel.id, equals('test-id-123'));
        expect(cartItemModel.productName, equals('Test Product'));
        expect(cartItemModel.brands, equals('Test Brand'));
        expect(
          cartItemModel.imageThumbUrl,
          equals('https://example.com/thumb.jpg'),
        );
        expect(cartItemModel.quantity, equals(2));
        expect(cartItemModel.nutriments, equals(sampleNutriments));
      });

      test('should create CartItemModel with minimal required parameters', () {
        // Arrange & Act
        cartItemModel = CartItemModel(
          id: 'test-id-456',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {},
        );

        // Assert
        expect(cartItemModel.id, equals('test-id-456'));
        expect(cartItemModel.productName, equals('Test Product'));
        expect(cartItemModel.brands, isNull);
        expect(cartItemModel.imageThumbUrl, isNull);
        expect(cartItemModel.quantity, equals(1));
        expect(cartItemModel.nutriments, isEmpty);
      });
    });

    group('fromMap Factory Tests', () {
      test('should create CartItemModel from complete map', () {
        // Arrange
        final map = {
          'id': 'test-id-789',
          'product_name': 'Test Product',
          'brands': 'Test Brand',
          'image_url': 'https://example.com/image.jpg',
          'image_small_url': 'https://example.com/small.jpg',
          'image_thumb_url': 'https://example.com/thumb.jpg',
          'quantity': 3,
          'nutriments': sampleNutriments,
        };

        // Act
        cartItemModel = CartItemModel.fromMap(map);

        // Assert
        expect(cartItemModel.id, equals('test-id-789'));
        expect(cartItemModel.productName, equals('Test Product'));
        expect(cartItemModel.brands, equals('Test Brand'));
        // image_url has priority over image_thumb_url in the actual implementation
        expect(
          cartItemModel.imageThumbUrl,
          equals('https://example.com/image.jpg'),
        );
        expect(cartItemModel.quantity, equals(3));
        expect(cartItemModel.nutriments, equals(sampleNutriments));
      });

      test('should create CartItemModel from incomplete map', () {
        // Arrange
        final map = {
          'id': 'test-id-101',
          'product_name': 'Test Product',
          'quantity': 1,
        };

        // Act
        cartItemModel = CartItemModel.fromMap(map);

        // Assert
        expect(cartItemModel.id, equals('test-id-101'));
        expect(cartItemModel.productName, equals('Test Product'));
        expect(cartItemModel.brands, isNull);
        expect(cartItemModel.imageThumbUrl, isNull);
        expect(cartItemModel.quantity, equals(1));
        expect(cartItemModel.nutriments, isEmpty);
      });

      test('should handle null values in map', () {
        // Arrange
        final map = {
          'id': null,
          'product_name': null,
          'brands': null,
          'image_url': null,
          'quantity': null,
          'nutriments': null,
        };

        // Act
        cartItemModel = CartItemModel.fromMap(map);

        // Assert
        expect(cartItemModel.id, equals(''));
        expect(cartItemModel.productName, equals('İsimsiz'));
        expect(cartItemModel.brands, isNull);
        expect(cartItemModel.imageThumbUrl, isNull);
        expect(cartItemModel.quantity, equals(1));
        expect(cartItemModel.nutriments, isEmpty);
      });

      test('should handle missing keys in map', () {
        // Arrange
        final map = <String, dynamic>{};

        // Act
        cartItemModel = CartItemModel.fromMap(map);

        // Assert
        expect(cartItemModel.id, equals(''));
        expect(cartItemModel.productName, equals('İsimsiz'));
        expect(cartItemModel.brands, isNull);
        expect(cartItemModel.imageThumbUrl, isNull);
        expect(cartItemModel.quantity, equals(1));
        expect(cartItemModel.nutriments, isEmpty);
      });

      test('should prioritize image_url over other image URLs', () {
        // Arrange
        final map = {
          'id': 'test-id',
          'product_name': 'Test Product',
          'image_url': 'https://example.com/image.jpg',
          'image_small_url': 'https://example.com/small.jpg',
          'image_thumb_url': 'https://example.com/thumb.jpg',
          'quantity': 1,
          'nutriments': {},
        };

        // Act
        cartItemModel = CartItemModel.fromMap(map);

        // Assert
        // image_url has priority in the actual implementation
        expect(
          cartItemModel.imageThumbUrl,
          equals('https://example.com/image.jpg'),
        );
      });

      test(
        'should fallback to image_small_url when image_url is not available',
        () {
          // Arrange
          final map = {
            'id': 'test-id',
            'product_name': 'Test Product',
            'image_small_url': 'https://example.com/small.jpg',
            'image_thumb_url': 'https://example.com/thumb.jpg',
            'quantity': 1,
            'nutriments': {},
          };

          // Act
          cartItemModel = CartItemModel.fromMap(map);

          // Assert
          expect(
            cartItemModel.imageThumbUrl,
            equals('https://example.com/small.jpg'),
          );
        },
      );

      test(
        'should fallback to image_thumb_url when other image URLs are not available',
        () {
          // Arrange
          final map = {
            'id': 'test-id',
            'product_name': 'Test Product',
            'image_thumb_url': 'https://example.com/thumb.jpg',
            'quantity': 1,
            'nutriments': {},
          };

          // Act
          cartItemModel = CartItemModel.fromMap(map);

          // Assert
          expect(
            cartItemModel.imageThumbUrl,
            equals('https://example.com/thumb.jpg'),
          );
        },
      );

      test('should handle numeric quantity values', () {
        // Arrange
        final map = {
          'id': 'test-id',
          'product_name': 'Test Product',
          'quantity': 5.0, // Double value
          'nutriments': {},
        };

        // Act
        cartItemModel = CartItemModel.fromMap(map);

        // Assert
        expect(cartItemModel.quantity, equals(5));
      });

      test('should handle string quantity values', () {
        // Arrange
        final map = {
          'id': 'test-id',
          'product_name': 'Test Product',
          'quantity': '3', // String value - will cause cast error
          'nutriments': {},
        };

        // Act & Assert
        // This should throw an error because string cannot be cast to num
        expect(() => CartItemModel.fromMap(map), throwsA(isA<TypeError>()));
      });

      test('should handle invalid nutriments data', () {
        // Arrange
        final map = {
          'id': 'test-id',
          'product_name': 'Test Product',
          'quantity': 1,
          'nutriments': 'invalid_data', // Not a Map
        };

        // Act
        cartItemModel = CartItemModel.fromMap(map);

        // Assert
        expect(cartItemModel.nutriments, isEmpty);
      });
    });

    group('toMap Tests', () {
      test('should convert CartItemModel to map correctly', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        // Act
        final map = cartItemModel.toMap();

        // Assert
        expect(map['id'], equals('test-id-123'));
        expect(map['product_name'], equals('Test Product'));
        expect(map['brands'], equals('Test Brand'));
        expect(map['image_thumb_url'], equals('https://example.com/thumb.jpg'));
        expect(map['image_url'], equals('https://example.com/thumb.jpg'));
        expect(map['quantity'], equals(2));
        expect(map['nutriments'], equals(sampleNutriments));
      });

      test(
        'should convert CartItemModel with null values to map correctly',
        () {
          // Arrange
          cartItemModel = CartItemModel(
            id: 'test-id-456',
            productName: 'Test Product',
            quantity: 1,
            nutriments: {},
          );

          // Act
          final map = cartItemModel.toMap();

          // Assert
          expect(map['id'], equals('test-id-456'));
          expect(map['product_name'], equals('Test Product'));
          expect(map['brands'], isNull);
          expect(map['image_thumb_url'], isNull);
          expect(map['image_url'], isNull);
          expect(map['quantity'], equals(1));
          expect(map['nutriments'], isEmpty);
        },
      );
    });

    group('copyWith Tests', () {
      setUp(() {
        cartItemModel = CartItemModel(
          id: 'original-id',
          productName: 'Original Product',
          brands: 'Original Brand',
          imageThumbUrl: 'https://example.com/original.jpg',
          quantity: 1,
          nutriments: sampleNutriments,
        );
      });

      test('should create copy with updated id', () {
        // Act
        final updatedModel = cartItemModel.copyWith(id: 'new-id');

        // Assert
        expect(updatedModel.id, equals('new-id'));
        expect(updatedModel.productName, equals('Original Product'));
        expect(updatedModel.brands, equals('Original Brand'));
        expect(
          updatedModel.imageThumbUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.quantity, equals(1));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated productName', () {
        // Act
        final updatedModel = cartItemModel.copyWith(productName: 'New Product');

        // Assert
        expect(updatedModel.id, equals('original-id'));
        expect(updatedModel.productName, equals('New Product'));
        expect(updatedModel.brands, equals('Original Brand'));
        expect(
          updatedModel.imageThumbUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.quantity, equals(1));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated brands', () {
        // Act
        final updatedModel = cartItemModel.copyWith(brands: 'New Brand');

        // Assert
        expect(updatedModel.id, equals('original-id'));
        expect(updatedModel.productName, equals('Original Product'));
        expect(updatedModel.brands, equals('New Brand'));
        expect(
          updatedModel.imageThumbUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.quantity, equals(1));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated imageThumbUrl', () {
        // Act
        final updatedModel = cartItemModel.copyWith(
          imageThumbUrl: 'https://example.com/new.jpg',
        );

        // Assert
        expect(updatedModel.id, equals('original-id'));
        expect(updatedModel.productName, equals('Original Product'));
        expect(updatedModel.brands, equals('Original Brand'));
        expect(
          updatedModel.imageThumbUrl,
          equals('https://example.com/new.jpg'),
        );
        expect(updatedModel.quantity, equals(1));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated quantity', () {
        // Act
        final updatedModel = cartItemModel.copyWith(quantity: 5);

        // Assert
        expect(updatedModel.id, equals('original-id'));
        expect(updatedModel.productName, equals('Original Product'));
        expect(updatedModel.brands, equals('Original Brand'));
        expect(
          updatedModel.imageThumbUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.quantity, equals(5));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });

      test('should create copy with updated nutriments', () {
        // Arrange
        final newNutriments = {'proteins': 20.0, 'carbohydrates': 40.0};

        // Act
        final updatedModel = cartItemModel.copyWith(nutriments: newNutriments);

        // Assert
        expect(updatedModel.id, equals('original-id'));
        expect(updatedModel.productName, equals('Original Product'));
        expect(updatedModel.brands, equals('Original Brand'));
        expect(
          updatedModel.imageThumbUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.quantity, equals(1));
        expect(updatedModel.nutriments, equals(newNutriments));
      });

      test('should create copy with multiple updated fields', () {
        // Arrange
        final newNutriments = {'proteins': 25.0};

        // Act
        final updatedModel = cartItemModel.copyWith(
          productName: 'New Product',
          quantity: 3,
          nutriments: newNutriments,
        );

        // Assert
        expect(updatedModel.id, equals('original-id'));
        expect(updatedModel.productName, equals('New Product'));
        expect(updatedModel.brands, equals('Original Brand'));
        expect(
          updatedModel.imageThumbUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.quantity, equals(3));
        expect(updatedModel.nutriments, equals(newNutriments));
      });

      test('should create copy with null values', () {
        // Act
        final updatedModel = cartItemModel.copyWith(
          brands: null,
          imageThumbUrl: null,
        );

        // Assert
        expect(updatedModel.id, equals('original-id'));
        expect(updatedModel.productName, equals('Original Product'));
        // copyWith doesn't change to null if the parameter is null, it keeps original value
        expect(updatedModel.brands, equals('Original Brand'));
        expect(
          updatedModel.imageThumbUrl,
          equals('https://example.com/original.jpg'),
        );
        expect(updatedModel.quantity, equals(1));
        expect(updatedModel.nutriments, equals(sampleNutriments));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very long product names', () {
        // Arrange
        final longName = 'A' * 1000;
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: longName,
          quantity: 1,
          nutriments: {},
        );

        // Assert
        expect(cartItemModel.productName, equals(longName));
      });

      test('should handle special characters in product name', () {
        // Arrange
        final specialName = 'Test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./';
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: specialName,
          quantity: 1,
          nutriments: {},
        );

        // Assert
        expect(cartItemModel.productName, equals(specialName));
      });

      test('should handle very large quantity values', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 999999,
          nutriments: {},
        );

        // Assert
        expect(cartItemModel.quantity, equals(999999));
      });

      test('should handle zero quantity', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 0,
          nutriments: {},
        );

        // Assert
        expect(cartItemModel.quantity, equals(0));
      });

      test('should handle negative quantity', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: -1,
          nutriments: {},
        );

        // Assert
        expect(cartItemModel.quantity, equals(-1));
      });

      test('should handle empty string id', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: '',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {},
        );

        // Assert
        expect(cartItemModel.id, equals(''));
      });

      test('should handle very large nutriments map', () {
        // Arrange
        final largeNutriments = <String, dynamic>{};
        for (int i = 0; i < 1000; i++) {
          largeNutriments['nutrient_$i'] = i.toDouble();
        }

        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: largeNutriments,
        );

        // Assert
        expect(cartItemModel.nutriments.length, equals(1000));
        expect(cartItemModel.nutriments['nutrient_0'], equals(0.0));
        expect(cartItemModel.nutriments['nutrient_999'], equals(999.0));
      });
    });

    group('toString Tests', () {
      test('should return correct string representation', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        // Act
        final stringRepresentation = cartItemModel.toString();

        // Assert
        expect(stringRepresentation, contains('CartItemModel'));
        expect(stringRepresentation, contains('test-id-123'));
        expect(stringRepresentation, contains('Test Product'));
        expect(stringRepresentation, contains('Test Brand'));
        expect(stringRepresentation, contains('https://example.com/thumb.jpg'));
        expect(stringRepresentation, contains('2'));
      });

      test('should handle null values in string representation', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-456',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {},
        );

        // Act
        final stringRepresentation = cartItemModel.toString();

        // Assert
        expect(stringRepresentation, contains('CartItemModel'));
        expect(stringRepresentation, contains('test-id-456'));
        expect(stringRepresentation, contains('Test Product'));
        expect(
          stringRepresentation,
          contains('null'),
        ); // brands and imageThumbUrl are null
      });
    });

    group('Equality Tests', () {
      test('should be equal to identical object', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        final identicalModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        // Act & Assert
        expect(cartItemModel, equals(identicalModel));
        expect(cartItemModel == identicalModel, isTrue);
      });

      test('should not be equal to different object', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        final differentModel = CartItemModel(
          id: 'different-id',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        // Act & Assert
        expect(cartItemModel, isNot(equals(differentModel)));
        expect(cartItemModel == differentModel, isFalse);
      });

      test('should not be equal to object with different product name', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        final differentModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Different Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        // Act & Assert
        expect(cartItemModel, isNot(equals(differentModel)));
        expect(cartItemModel == differentModel, isFalse);
      });

      test('should not be equal to object with different quantity', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        final differentModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 3,
          nutriments: sampleNutriments,
        );

        // Act & Assert
        expect(cartItemModel, isNot(equals(differentModel)));
        expect(cartItemModel == differentModel, isFalse);
      });

      test('should not be equal to object with different nutriments', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: sampleNutriments,
        );

        final differentNutriments = {'proteins': 20.0, 'carbohydrates': 40.0};
        final differentModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: differentNutriments,
        );

        // Act & Assert
        expect(cartItemModel, isNot(equals(differentModel)));
        expect(cartItemModel == differentModel, isFalse);
      });

      test('should be equal to object with null values', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {},
        );

        final identicalModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {},
        );

        // Act & Assert
        expect(cartItemModel, equals(identicalModel));
        expect(cartItemModel == identicalModel, isTrue);
      });

      test('should not be equal to null', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {},
        );

        // Act & Assert
        expect(cartItemModel, isNotNull);
      });

      test('should not be equal to different type', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {},
        );

        // Act & Assert
        expect(cartItemModel == 'string', isFalse);
        expect(cartItemModel == 123, isFalse);
        expect(cartItemModel == {}, isFalse);
      });
    });

    group('HashCode Tests', () {
      test('should have different hashCode for different objects', () {
        // Arrange
        final nutriments = {'proteins': 15.5, 'carbohydrates': 30.0};
        cartItemModel = CartItemModel(
          id: 'test-id-123',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: nutriments,
        );

        final differentModel = CartItemModel(
          id: 'different-id',
          productName: 'Test Product',
          brands: 'Test Brand',
          imageThumbUrl: 'https://example.com/thumb.jpg',
          quantity: 2,
          nutriments: nutriments,
        );

        // Act & Assert
        expect(cartItemModel.hashCode, isNot(equals(differentModel.hashCode)));
      });
    });

    group('MapEquals Helper Tests', () {
      test('should return true for identical maps', () {
        // Arrange
        final map1 = {'proteins': 15.5, 'carbohydrates': 30.0};
        final map2 = {'proteins': 15.5, 'carbohydrates': 30.0};
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: map1,
        );

        // Act & Assert
        expect(
          cartItemModel == cartItemModel.copyWith(nutriments: map2),
          isTrue,
        );
      });

      test('should return false for different maps', () {
        // Arrange
        final map1 = {'proteins': 15.5, 'carbohydrates': 30.0};
        final map2 = {'proteins': 20.0, 'carbohydrates': 30.0};
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: map1,
        );

        // Act & Assert
        expect(
          cartItemModel == cartItemModel.copyWith(nutriments: map2),
          isFalse,
        );
      });

      test('should return true for both null maps', () {
        // Arrange
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: {},
        );

        // Act & Assert
        expect(cartItemModel == cartItemModel.copyWith(nutriments: {}), isTrue);
      });

      test('should return false when one map is null and other is not', () {
        // Arrange
        final map1 = {'proteins': 15.5};
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: map1,
        );

        // Act & Assert
        expect(
          cartItemModel == cartItemModel.copyWith(nutriments: {}),
          isFalse,
        );
      });

      test('should return false for maps with different lengths', () {
        // Arrange
        final map1 = {'proteins': 15.5, 'carbohydrates': 30.0};
        final map2 = {'proteins': 15.5};
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: map1,
        );

        // Act & Assert
        expect(
          cartItemModel == cartItemModel.copyWith(nutriments: map2),
          isFalse,
        );
      });

      test('should return false for maps with different keys', () {
        // Arrange
        final map1 = {'proteins': 15.5, 'carbohydrates': 30.0};
        final map2 = {'proteins': 15.5, 'fat': 30.0};
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: map1,
        );

        // Act & Assert
        expect(
          cartItemModel == cartItemModel.copyWith(nutriments: map2),
          isFalse,
        );
      });

      test('should return false for maps with different values', () {
        // Arrange
        final map1 = {'proteins': 15.5, 'carbohydrates': 30.0};
        final map2 = {'proteins': 15.5, 'carbohydrates': 25.0};
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: map1,
        );

        // Act & Assert
        expect(
          cartItemModel == cartItemModel.copyWith(nutriments: map2),
          isFalse,
        );
      });

      test('should handle maps with same content but different instances', () {
        // Arrange
        final map1 = {'proteins': 15.5, 'carbohydrates': 30.0};
        final map2 = {'proteins': 15.5, 'carbohydrates': 30.0};
        cartItemModel = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: map1,
        );

        final modelWithMap2 = CartItemModel(
          id: 'test-id',
          productName: 'Test Product',
          quantity: 1,
          nutriments: map2,
        );

        // Act & Assert
        expect(cartItemModel == modelWithMap2, isTrue);
      });
    });
  });
}
