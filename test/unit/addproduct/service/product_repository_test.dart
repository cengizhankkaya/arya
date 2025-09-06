import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/model/add_product_model.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([Dio, Response, RequestOptions])
void main() {
  group('ProductRepository Tests', () {
    late ProductRepository repository;
    late MockDio mockDio;
    late MockResponse mockResponse;
    late MockRequestOptions mockRequestOptions;

    setUp(() {
      mockDio = MockDio();
      mockResponse = MockResponse();
      mockRequestOptions = MockRequestOptions();

      // MockRequestOptions için eksik stub'ları ekle
      when(mockRequestOptions.sourceStackTrace).thenReturn(StackTrace.current);
      when(mockRequestOptions.data).thenReturn(null);
      when(mockRequestOptions.headers).thenReturn({});

      // Repository'yi oluştur
      repository = ProductRepository();
      // Not: ProductRepository private Dio field kullandığı için
      // mock'ları doğrudan inject edemiyoruz. Bu testler integration test olarak çalışacak.
    });

    tearDown(() {
      reset(mockDio);
      reset(mockResponse);
      reset(mockRequestOptions);
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
