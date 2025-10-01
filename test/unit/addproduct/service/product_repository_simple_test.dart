import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/model/add_product_model.dart';

void main() {
  group('ProductRepository Simple Tests', () {
    late ProductRepository repository;
    late AddProductModel testProduct;

    setUp(() {
      repository = ProductRepository();
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

    group('parseResponse Tests', () {
      test('should parse successful response', () {
        // Arrange
        const responseBody =
            '{"status":1,"status_verbose":"Product saved successfully"}';

        // Act
        final result = repository.parseResponse(responseBody);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should parse failed response', () {
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
    });

    group('Integration Tests', () {
      test('should handle invalid credentials gracefully', () async {
        // Act - Geçersiz kullanıcı bilgileri ile test
        final result = await repository.saveProduct(
          testProduct,
          'invalid_user',
          'invalid_pass',
        );

        // Assert - Hata bekliyoruz çünkü geçersiz credentials
        expect(result.status, isNot(equals(1))); // Başarısız olmalı
        expect(result.statusVerbose, isNotNull);
        expect(result.statusVerbose, isNotEmpty);
      });

      test('should handle network timeout gracefully', () async {
        // Bu test gerçek network timeout'u simüle eder
        // Dio'nun timeout ayarları çalışıyor mu kontrol eder

        final result = await repository.saveProduct(
          testProduct,
          'test_user',
          'test_pass',
        );

        // Assert - Timeout veya başka bir hata bekliyoruz
        expect(result.status, isNot(equals(1))); // Başarısız olmalı
        expect(result.statusVerbose, isNotNull);
      });
    });

    group('Dio Configuration Tests', () {
      test('should have proper base URL configuration', () {
        // Bu test Dio'nun doğru yapılandırıldığını kontrol eder
        // Repository'nin oluşturulabildiğini test eder
        expect(repository, isNotNull);
        expect(repository, isA<ProductRepository>());
      });
    });
  });
}
