import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/model/add_product_model.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([Dio, Response, RequestOptions, Headers])
void main() {
  group('ProductRepository Tests', () {
    late ProductRepository repository;
    late MockDio mockDio;
    late MockResponse mockResponse;
    late MockRequestOptions mockRequestOptions;
    late MockHeaders mockHeaders;

    setUp(() {
      mockDio = MockDio();
      mockResponse = MockResponse();
      mockRequestOptions = MockRequestOptions();
      mockHeaders = MockHeaders();

      // MockRequestOptions için eksik stub'ları ekle
      when(mockRequestOptions.data).thenReturn(null);
      when(mockRequestOptions.headers).thenReturn({});

      // MockHeaders için stub'ları ekle
      when(mockHeaders.map).thenReturn({});
      when(
        mockHeaders['location'],
      ).thenReturn(['https://example.com/redirect']);

      // Repository'yi oluştur
      repository = ProductRepository();
      // Not: ProductRepository private Dio field kullandığı için
      // mock'ları doğrudan inject edemiyoruz. Bu testler integration test olarak çalışacak.
    });

    tearDown(() {
      reset(mockDio);
      reset(mockResponse);
      reset(mockRequestOptions);
      reset(mockHeaders);
    });

    group('AddProductModel Tests', () {
      test('should create valid AddProductModel from form data', () {
        // Arrange & Act
        final product = AddProductModel.fromForm(
          barcode: '1234567890123',
          name: 'Test Product',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '250.0',
          fat: '10.0',
          carbs: '30.0',
          protein: '15.0',
          ingredients: 'Test ingredients',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'None',
          description: 'Test product description',
          tags: 'test,product',
        );

        // Assert
        expect(product.barcode, equals('1234567890123'));
        expect(product.name, equals('Test Product'));
        expect(product.brands, equals('Test Brand'));
        expect(product.categories, equals('Test Category'));
        expect(product.quantity, equals('100g'));
        expect(product.energy, equals('250.0'));
        expect(product.fat, equals('10.0'));
        expect(product.carbs, equals('30.0'));
        expect(product.protein, equals('15.0'));
        expect(product.ingredients, equals('Test ingredients'));
        expect(product.sodium, equals('0.5'));
        expect(product.fiber, equals('2.0'));
        expect(product.sugar, equals('5.0'));
        expect(product.allergens, equals('None'));
        expect(product.description, equals('Test product description'));
        expect(product.tags, equals('test,product'));
      });

      test('should trim whitespace from form data', () {
        // Arrange & Act
        final product = AddProductModel.fromForm(
          barcode: '  1234567890123  ',
          name: '  Test Product  ',
          brands: '  Test Brand  ',
          categories: '  Test Category  ',
          quantity: '  100g  ',
          energy: '  250.0  ',
          fat: '  10.0  ',
          carbs: '  30.0  ',
          protein: '  15.0  ',
          ingredients: '  Test ingredients  ',
          sodium: '  0.5  ',
          fiber: '  2.0  ',
          sugar: '  5.0  ',
          allergens: '  None  ',
          description: '  Test product description  ',
          tags: '  test,product  ',
        );

        // Assert
        expect(product.barcode, equals('1234567890123'));
        expect(product.name, equals('Test Product'));
        expect(product.brands, equals('Test Brand'));
        expect(product.categories, equals('Test Category'));
        expect(product.quantity, equals('100g'));
        expect(product.energy, equals('250.0'));
        expect(product.fat, equals('10.0'));
        expect(product.carbs, equals('30.0'));
        expect(product.protein, equals('15.0'));
        expect(product.ingredients, equals('Test ingredients'));
        expect(product.sodium, equals('0.5'));
        expect(product.fiber, equals('2.0'));
        expect(product.sugar, equals('5.0'));
        expect(product.allergens, equals('None'));
        expect(product.description, equals('Test product description'));
        expect(product.tags, equals('test,product'));
      });

      test('should convert to API data correctly', () {
        // Arrange
        final product = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Product',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '250.0',
          fat: '10.0',
          carbs: '30.0',
          protein: '15.0',
          ingredients: 'Test ingredients',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'None',
          description: 'Test product description',
          tags: 'test,product',
        );

        // Act
        final apiData = product.toApiData();

        // Assert
        expect(apiData['code'], equals('1234567890123'));
        expect(apiData['product_name'], equals('Test Product'));
        expect(apiData['brands'], equals('Test Brand'));
        expect(apiData['categories'], equals('Test Category'));
        expect(apiData['quantity'], equals('100g'));
        expect(apiData['ingredients_text'], equals('Test ingredients'));
        expect(apiData['nutriment_fiber'], equals('2.0'));
        expect(apiData['nutriment_sugars'], equals('5.0'));
        expect(apiData['allergens_tags'], equals('None'));
        expect(apiData['generic_name'], equals('Test product description'));
        expect(apiData['labels_tags'], equals('test,product'));
        expect(apiData['nutriment_energy-kcal'], equals('250.0'));
        expect(apiData['nutriment_energy-kcal_unit'], equals('kcal'));
        expect(apiData['nutriment_fat'], equals('10.0'));
        expect(apiData['nutriment_fat_unit'], equals('g'));
        expect(apiData['nutriment_carbohydrates'], equals('30.0'));
        expect(apiData['nutriment_carbohydrates_unit'], equals('g'));
        expect(apiData['nutriment_proteins'], equals('15.0'));
        expect(apiData['nutriment_proteins_unit'], equals('g'));
        expect(apiData['nutriment_salt'], equals('0.5'));
        expect(apiData['nutriment_salt_unit'], equals('g'));
      });

      test('should handle empty optional fields in API data', () {
        // Arrange
        final product = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Product',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '',
          fat: '',
          carbs: '',
          protein: '',
          ingredients: 'Test ingredients',
          sodium: '',
          fiber: '',
          sugar: '',
          allergens: '',
          description: '',
          tags: '',
        );

        // Act
        final apiData = product.toApiData();

        // Assert
        expect(apiData['code'], equals('1234567890123'));
        expect(apiData['product_name'], equals('Test Product'));
        expect(apiData['brands'], equals('Test Brand'));
        expect(apiData['categories'], equals('Test Category'));
        expect(apiData['quantity'], equals('100g'));
        expect(apiData['ingredients_text'], equals('Test ingredients'));
        expect(apiData['nutriment_fiber'], equals(''));
        expect(apiData['nutriment_sugars'], equals(''));
        expect(apiData['allergens_tags'], equals(''));
        expect(apiData['generic_name'], equals(''));
        expect(apiData['labels_tags'], equals(''));

        // Optional fields should not be present when empty
        expect(apiData.containsKey('nutriment_energy-kcal'), isFalse);
        expect(apiData.containsKey('nutriment_fat'), isFalse);
        expect(apiData.containsKey('nutriment_carbohydrates'), isFalse);
        expect(apiData.containsKey('nutriment_proteins'), isFalse);
        expect(apiData.containsKey('nutriment_salt'), isFalse);
      });

      group('Validation Tests', () {
        test('should validate barcode correctly', () {
          expect(
            AddProductModel.validateBarcode(null),
            equals('Barkod gerekli'),
          );
          expect(AddProductModel.validateBarcode(''), equals('Barkod gerekli'));
          expect(
            AddProductModel.validateBarcode('123'),
            equals('Barkod en az 8 karakter olmalı'),
          );
          expect(AddProductModel.validateBarcode('12345678'), isNull);
          expect(AddProductModel.validateBarcode('1234567890123'), isNull);
        });

        test('should validate name correctly', () {
          expect(
            AddProductModel.validateName(null),
            equals('Ürün adı gerekli'),
          );
          expect(AddProductModel.validateName(''), equals('Ürün adı gerekli'));
          expect(
            AddProductModel.validateName('A'),
            equals('Ürün adı en az 2 karakter olmalı'),
          );
          expect(AddProductModel.validateName('AB'), isNull);
          expect(AddProductModel.validateName('Test Product'), isNull);
        });

        test('should validate brands correctly', () {
          expect(
            AddProductModel.validateBrands(null),
            equals('Marka bilgisi gerekli'),
          );
          expect(
            AddProductModel.validateBrands(''),
            equals('Marka bilgisi gerekli'),
          );
          expect(AddProductModel.validateBrands('Test Brand'), isNull);
        });

        test('should validate categories correctly', () {
          expect(
            AddProductModel.validateCategories(null),
            equals('Kategori bilgisi gerekli'),
          );
          expect(
            AddProductModel.validateCategories(''),
            equals('Kategori bilgisi gerekli'),
          );
          expect(AddProductModel.validateCategories('Test Category'), isNull);
        });

        test('should validate quantity correctly', () {
          expect(
            AddProductModel.validateQuantity(null),
            equals('Miktar bilgisi gerekli'),
          );
          expect(
            AddProductModel.validateQuantity(''),
            equals('Miktar bilgisi gerekli'),
          );
          expect(AddProductModel.validateQuantity('100g'), isNull);
        });

        test('should validate ingredients correctly', () {
          expect(
            AddProductModel.validateIngredients(null),
            equals('İçerik bilgisi gerekli'),
          );
          expect(
            AddProductModel.validateIngredients(''),
            equals('İçerik bilgisi gerekli'),
          );
          expect(
            AddProductModel.validateIngredients('Test ingredients'),
            isNull,
          );
        });
      });

      test('should create copy with updated fields', () {
        // Arrange
        final original = AddProductModel(
          barcode: '1234567890123',
          name: 'Original Product',
          brands: 'Original Brand',
          categories: 'Original Category',
          quantity: '100g',
          energy: '250.0',
          fat: '10.0',
          carbs: '30.0',
          protein: '15.0',
          ingredients: 'Original ingredients',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'None',
          description: 'Original description',
          tags: 'original,product',
        );

        // Act
        final updated = original.copyWith(
          name: 'Updated Product',
          brands: 'Updated Brand',
          energy: '300.0',
        );

        // Assert
        expect(updated.barcode, equals('1234567890123')); // Unchanged
        expect(updated.name, equals('Updated Product')); // Changed
        expect(updated.brands, equals('Updated Brand')); // Changed
        expect(updated.categories, equals('Original Category')); // Unchanged
        expect(updated.quantity, equals('100g')); // Unchanged
        expect(updated.energy, equals('300.0')); // Changed
        expect(updated.fat, equals('10.0')); // Unchanged
        expect(updated.carbs, equals('30.0')); // Unchanged
        expect(updated.protein, equals('15.0')); // Unchanged
        expect(
          updated.ingredients,
          equals('Original ingredients'),
        ); // Unchanged
        expect(updated.sodium, equals('0.5')); // Unchanged
        expect(updated.fiber, equals('2.0')); // Unchanged
        expect(updated.sugar, equals('5.0')); // Unchanged
        expect(updated.allergens, equals('None')); // Unchanged
        expect(
          updated.description,
          equals('Original description'),
        ); // Unchanged
        expect(updated.tags, equals('original,product')); // Unchanged
      });
    });

    group('saveProduct Tests (Integration)', () {
      late AddProductModel testProduct;

      setUp(() {
        testProduct = AddProductModel(
          name: 'Test Product',
          barcode: '1234567890123',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '250.0',
          fat: '10.0',
          carbs: '30.0',
          protein: '15.0',
          ingredients: 'Test ingredients',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'None',
          description: 'Test product description',
          tags: 'test,product',
        );
      });

      test(
        'should handle network errors gracefully',
        () async {
          // Bu test gerçek network çağrısı yapar ve hata durumlarını test eder
          // Geçersiz credentials ile test ediyoruz

          // Act
          final result = await repository.saveProduct(
            testProduct,
            'invalid_user',
            'invalid_pass',
          );

          // Assert - Network hatası veya authentication hatası bekliyoruz
          expect(result.status, isNot(equals(1))); // Başarısız olmalı
          expect(result.statusVerbose, isNotNull);
          expect(result.statusVerbose, isNotEmpty);
        },
        skip: 'Network bağımlı test - sadece gerektiğinde çalıştır',
      );
    });

    group('parseResponse Tests', () {
      test('should parse successful response from Map', () {
        // Arrange
        final responseData = {
          'status': 1,
          'status_verbose': 'Product saved successfully',
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should parse failed response from Map', () {
        // Arrange
        final responseData = {
          'status': 0,
          'status_verbose': 'Product not saved',
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(0));
        expect(result.statusVerbose, equals('Product not saved'));
      });

      test('should parse successful response from string', () {
        // Arrange
        const responseBody =
            '{"status":1,"status_verbose":"Product saved successfully"}';

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should parse failed response from string', () {
        // Arrange
        const responseBody =
            '{"status":0,"status_verbose":"Product not saved"}';

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(0));
        expect(result.statusVerbose, equals('Product not saved'));
      });

      test('should handle unknown response format', () {
        // Arrange
        const responseBody = '{"unknown":"format"}';

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown response'));
      });

      test('should handle malformed JSON', () {
        // Arrange
        const responseBody = 'invalid json';

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown response'));
      });

      test('should handle unknown status value', () {
        // Arrange
        final responseData = {
          'status': 999,
          'status_verbose': 'Unknown status',
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown status: 999'));
      });

      test('should handle null status_verbose in Map', () {
        // Arrange
        final responseData = {'status': 1, 'status_verbose': null};

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Unknown status'));
      });

      test('should handle missing status_verbose in Map', () {
        // Arrange
        final responseData = {'status': 0};

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(0));
        expect(result.statusVerbose, equals('Unknown status'));
      });

      test('should handle empty string response', () {
        // Arrange
        const responseBody = '';

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown response'));
      });

      test('should handle null response', () {
        // Arrange
        const responseBody = null;

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown response'));
      });

      test('should handle response with extra fields', () {
        // Arrange
        final responseData = {
          'status': 1,
          'status_verbose': 'Product saved successfully',
          'extra_field': 'extra_value',
          'another_field': 123,
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should handle string response with extra content', () {
        // Arrange
        const responseBody =
            '{"status":1,"status_verbose":"Product saved successfully","extra":"data"}';

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should handle string response with status 0 and extra content', () {
        // Arrange
        const responseBody =
            '{"status":0,"status_verbose":"Product not saved","error":"details"}';

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(0));
        expect(result.statusVerbose, equals('Product not saved'));
      });
    });

    group('Error Handling Tests', () {
      test('should handle DioException with response', () {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400,
            statusMessage: 'Bad Request',
          ),
        );

        // Act & Assert - Bu test sadece exception tipini kontrol eder
        expect(dioException.response?.statusCode, equals(400));
        expect(dioException.response?.statusMessage, equals('Bad Request'));
      });

      test('should handle DioException without response', () {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/test'),
          message: 'Network error',
        );

        // Act & Assert - Bu test sadece exception tipini kontrol eder
        expect(dioException.response, isNull);
        expect(dioException.message, equals('Network error'));
      });

      test('should handle generic exception', () {
        // Arrange
        final exception = Exception('Generic error');

        // Act & Assert - Bu test sadece exception tipini kontrol eder
        expect(exception.toString(), contains('Generic error'));
      });
    });

    group('FormData Tests', () {
      test('should create FormData with correct structure', () {
        // Arrange
        final product = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Product',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '250.0',
          fat: '10.0',
          carbs: '30.0',
          protein: '15.0',
          ingredients: 'Test ingredients',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'None',
          description: 'Test product description',
          tags: 'test,product',
        );

        // Act
        final formData = FormData.fromMap({
          ...product.toApiData(),
          'user_id': 'test_user',
          'password': 'test_pass',
          'action': 'process',
          'json': '1',
          'type': 'product',
        });

        // Assert
        expect(formData.fields, isNotEmpty);
        expect(
          formData.fields.any(
            (field) => field.key == 'code' && field.value == '1234567890123',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) =>
                field.key == 'product_name' && field.value == 'Test Product',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'brands' && field.value == 'Test Brand',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) =>
                field.key == 'categories' && field.value == 'Test Category',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'quantity' && field.value == '100g',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) =>
                field.key == 'ingredients_text' &&
                field.value == 'Test ingredients',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'user_id' && field.value == 'test_user',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'password' && field.value == 'test_pass',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'action' && field.value == 'process',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'json' && field.value == '1',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'type' && field.value == 'product',
          ),
          isTrue,
        );
      });

      test('should handle empty optional fields in FormData', () {
        // Arrange
        final product = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Product',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '',
          fat: '',
          carbs: '',
          protein: '',
          ingredients: 'Test ingredients',
          sodium: '',
          fiber: '',
          sugar: '',
          allergens: '',
          description: '',
          tags: '',
        );

        // Act
        final formData = FormData.fromMap({
          ...product.toApiData(),
          'user_id': 'test_user',
          'password': 'test_pass',
          'action': 'process',
          'json': '1',
          'type': 'product',
        });

        // Assert
        expect(formData.fields, isNotEmpty);
        expect(
          formData.fields.any(
            (field) => field.key == 'code' && field.value == '1234567890123',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) =>
                field.key == 'product_name' && field.value == 'Test Product',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'brands' && field.value == 'Test Brand',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) =>
                field.key == 'categories' && field.value == 'Test Category',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'quantity' && field.value == '100g',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) =>
                field.key == 'ingredients_text' &&
                field.value == 'Test ingredients',
          ),
          isTrue,
        );

        // Empty fields should still be present but with empty values
        expect(
          formData.fields.any(
            (field) => field.key == 'nutriment_fiber' && field.value == '',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'nutriment_sugars' && field.value == '',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'allergens_tags' && field.value == '',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'generic_name' && field.value == '',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'labels_tags' && field.value == '',
          ),
          isTrue,
        );
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very long product name', () {
        // Arrange
        final longName = 'A' * 1000; // 1000 karakter uzunluğunda isim
        final product = AddProductModel(
          barcode: '1234567890123',
          name: longName,
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '250.0',
          fat: '10.0',
          carbs: '30.0',
          protein: '15.0',
          ingredients: 'Test ingredients',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'None',
          description: 'Test product description',
          tags: 'test,product',
        );

        // Act
        final apiData = product.toApiData();

        // Assert
        expect(apiData['product_name'], equals(longName));
        expect(apiData['product_name']?.length, equals(1000));
      });

      test('should handle special characters in product data', () {
        // Arrange
        final product = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Product with Special Chars: !@#\$%^&*()',
          brands: 'Brand with "quotes" and \'apostrophes\'',
          categories: 'Category with émojis 🍎🥕',
          quantity: '100g',
          energy: '250.0',
          fat: '10.0',
          carbs: '30.0',
          protein: '15.0',
          ingredients: 'Ingredients with <tags> and & symbols',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'Allergens with unicode: αβγδε',
          description: 'Description with newlines\nand tabs\t',
          tags: 'tags,with,commas,and;special;chars',
        );

        // Act
        final apiData = product.toApiData();

        // Assert
        expect(
          apiData['product_name'],
          equals('Test Product with Special Chars: !@#\$%^&*()'),
        );
        expect(
          apiData['brands'],
          equals('Brand with "quotes" and \'apostrophes\''),
        );
        expect(apiData['categories'], equals('Category with émojis 🍎🥕'));
        expect(
          apiData['ingredients_text'],
          equals('Ingredients with <tags> and & symbols'),
        );
        expect(
          apiData['allergens_tags'],
          equals('Allergens with unicode: αβγδε'),
        );
        expect(
          apiData['generic_name'],
          equals('Description with newlines\nand tabs\t'),
        );
        expect(
          apiData['labels_tags'],
          equals('tags,with,commas,and;special;chars'),
        );
      });

      test('should handle numeric values as strings', () {
        // Arrange
        final product = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Product',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '250.5',
          fat: '10.25',
          carbs: '30.75',
          protein: '15.0',
          ingredients: 'Test ingredients',
          sodium: '0.125',
          fiber: '2.5',
          sugar: '5.75',
          allergens: 'None',
          description: 'Test product description',
          tags: 'test,product',
        );

        // Act
        final apiData = product.toApiData();

        // Assert
        expect(apiData['nutriment_energy-kcal'], equals('250.5'));
        expect(apiData['nutriment_fat'], equals('10.25'));
        expect(apiData['nutriment_carbohydrates'], equals('30.75'));
        expect(apiData['nutriment_proteins'], equals('15.0'));
        expect(apiData['nutriment_salt'], equals('0.125'));
        expect(apiData['nutriment_fiber'], equals('2.5'));
        expect(apiData['nutriment_sugars'], equals('5.75'));
      });

      test('should handle empty barcode edge case', () {
        // Arrange
        final product = AddProductModel(
          barcode: '',
          name: 'Test Product',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '250.0',
          fat: '10.0',
          carbs: '30.0',
          protein: '15.0',
          ingredients: 'Test ingredients',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'None',
          description: 'Test product description',
          tags: 'test,product',
        );

        // Act
        final apiData = product.toApiData();

        // Assert
        expect(apiData['code'], equals(''));
      });

      test('should handle whitespace-only fields', () {
        // Arrange
        final product = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Product',
          brands: 'Test Brand',
          categories: 'Test Category',
          quantity: '100g',
          energy: '   ',
          fat: '\t\t',
          carbs: '\n\n',
          protein: '   \t\n   ',
          ingredients: 'Test ingredients',
          sodium: '0.5',
          fiber: '2.0',
          sugar: '5.0',
          allergens: 'None',
          description: 'Test product description',
          tags: 'test,product',
        );

        // Act
        final apiData = product.toApiData();

        // Assert
        expect(apiData['nutriment_energy-kcal'], equals('   '));
        expect(apiData['nutriment_fat'], equals('\t\t'));
        expect(apiData['nutriment_carbohydrates'], equals('\n\n'));
        expect(apiData['nutriment_proteins'], equals('   \t\n   '));
      });
    });

    group('Integration Tests', () {
      test(
        'should work with real Dio instance (integration test)',
        () async {
          // Bu test gerçek Dio instance'ı kullanır
          // Sadece development ortamında çalıştırın
          final realRepository = ProductRepository();
          final testProduct = AddProductModel(
            name: 'Test Integration Product',
            barcode: '9999999999999', // Geçersiz barkod
            brands: 'Test Brand',
            categories: 'Test Category',
            quantity: '100g',
            energy: '250.0',
            fat: '10.0',
            carbs: '30.0',
            protein: '15.0',
            ingredients: 'Test ingredients',
            sodium: '0.5',
            fiber: '2.0',
            sugar: '5.0',
            allergens: 'None',
            description: 'Test product description',
            tags: 'test,product',
          );

          // Act - Gerçek API'ye istek gönder
          final result = await realRepository.saveProduct(
            testProduct,
            'invalid_user', // Geçersiz kullanıcı
            'invalid_pass', // Geçersiz şifre
          );

          // Assert - Hata bekliyoruz çünkü geçersiz credentials
          expect(result.status, isNot(equals(1))); // Başarısız olmalı
          expect(result.statusVerbose, isNotNull);
        },
        skip: 'Network bağımlı integration test - sadece gerektiğinde çalıştır',
      );
    });
  });
}
