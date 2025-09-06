import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/model/add_product_model.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'dart:io';

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

      // Repository'yi mock Dio ile oluştur
      repository = ProductRepository();
      // Private field'a erişim için reflection kullanabiliriz veya
      // Repository'yi dependency injection ile değiştirebiliriz
    });

    tearDown(() {
      reset(mockDio);
      reset(mockResponse);
      reset(mockRequestOptions);
    });

    group('saveProduct Tests', () {
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

      test('should save product successfully with 200 response', () async {
        // Arrange
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.data).thenReturn(
          '{"status":1,"status_verbose":"Product saved successfully"}',
        );
        when(
          mockDio.post(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.saveProduct(
          testProduct,
          'testuser',
          'testpass',
        );

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, contains('Product saved successfully'));
      });

      test('should handle redirect response (3xx)', () async {
        // Arrange
        when(mockResponse.statusCode).thenReturn(302);
        when(mockResponse.headers).thenReturn(
          Headers.fromMap({
            'location': ['https://world.openfoodfacts.org/redirect-url'],
          }),
        );
        when(mockResponse.requestOptions).thenReturn(mockRequestOptions);
        when(mockRequestOptions.data).thenReturn(FormData.fromMap({}));
        when(mockRequestOptions.headers).thenReturn({});

        final redirectResponse = MockResponse();
        when(redirectResponse.statusCode).thenReturn(200);
        when(redirectResponse.data).thenReturn(
          '{"status":1,"status_verbose":"Product saved successfully"}',
        );

        when(
          mockDio.post(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        when(
          mockDio.post(
            'https://world.openfoodfacts.org/redirect-url',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => redirectResponse);

        // Act
        final result = await repository.saveProduct(
          testProduct,
          'testuser',
          'testpass',
        );

        // Assert
        expect(result.status, equals(1));
      });

      test('should handle HTTP error response', () async {
        // Arrange
        when(mockResponse.statusCode).thenReturn(400);
        when(mockResponse.statusMessage).thenReturn('Bad Request');
        when(
          mockDio.post(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await repository.saveProduct(
          testProduct,
          'testuser',
          'testpass',
        );

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, contains('HTTP error: 400'));
      });

      test('should handle DioException', () async {
        // Arrange
        final dioException = DioException(
          requestOptions: mockRequestOptions,
          response: mockResponse,
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
        );

        when(
          mockDio.post(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenThrow(dioException);

        // Act
        final result = await repository.saveProduct(
          testProduct,
          'testuser',
          'testpass',
        );

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, contains('Network error'));
      });

      test('should handle unexpected exception', () async {
        // Arrange
        when(
          mockDio.post(
            any,
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        // Act
        final result = await repository.saveProduct(
          testProduct,
          'testuser',
          'testpass',
        );

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, contains('Unexpected error'));
      });
    });

    group('_parseResponse Tests', () {
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
        expect(result.statusVerbose, contains('Parse error'));
      });
    });

    group('Integration Tests', () {
      test('should work with real Dio instance (integration test)', () async {
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
      });
    });
  });
}
