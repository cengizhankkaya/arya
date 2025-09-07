import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:arya/features/store/services/open_food_fackts_service.dart';

import 'open_food_facts_service_test.mocks.dart';

@GenerateMocks([Dio, Response])
void main() {
  group('OpenFoodFactsService Tests', () {
    late OpenFoodFactsService service;
    late MockDio mockDio;
    late MockResponse<Map<String, dynamic>> mockResponse;

    setUp(() {
      mockDio = MockDio();
      mockResponse = MockResponse<Map<String, dynamic>>();
      service = OpenFoodFactsService(dio: mockDio);
    });

    tearDown(() {
      // Clean up
    });

    group('Constructor Tests', () {
      test('should create OpenFoodFactsService with default Dio instance', () {
        // Act
        final service = OpenFoodFactsService();

        // Assert
        expect(service, isNotNull);
      });
    });

    group('searchProducts Tests', () {
      test('should search products successfully with basic query', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'product-1',
            'product_name': 'Test Product 1',
            'brands': 'Test Brand',
            'nutriments': {'proteins_100g': 10.0},
          },
          {
            'id': 'product-2',
            'product_name': 'Test Product 2',
            'brands': 'Test Brand 2',
            'nutriments': {'proteins_100g': 15.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts('test query');

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, equals(2));
        expect(result[0]['product_name'], equals('Test Product 1'));
        expect(result[1]['product_name'], equals('Test Product 2'));
      });

      test('should search products with country parameter', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'product-1',
            'product_name': 'Turkish Product',
            'brands': 'Turkish Brand',
            'nutriments': {'proteins_100g': 10.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts(
          'test query',
          country: 'turkey',
        );

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, equals(1));
        expect(result[0]['product_name'], equals('Turkish Product'));
      });

      test('should search products with pagination parameters', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'product-1',
            'product_name': 'Test Product 1',
            'brands': 'Test Brand',
            'nutriments': {'proteins_100g': 10.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts(
          'test query',
          page: 2,
          pageSize: 10,
        );

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, equals(1));
      });

      test('should return empty list when no products found', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts('nonexistent query');

        // Assert
        expect(result, isEmpty);
      });

      test('should return empty list when products key is missing', () async {
        // Arrange
        when(mockResponse.data).thenReturn({});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts('test query');

        // Assert
        expect(result, isEmpty);
      });

      test('should handle empty query', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'product-1',
            'product_name': 'Random Product',
            'brands': 'Random Brand',
            'nutriments': {'proteins_100g': 10.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts('');

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, equals(1));
      });

      test('should handle whitespace query', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'product-1',
            'product_name': 'Random Product',
            'brands': 'Random Brand',
            'nutriments': {'proteins_100g': 10.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts('   ');

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, equals(1));
      });

      test('should handle DioException', () async {
        // Arrange
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/cgi/search.pl'),
            message: 'Network error',
          ),
        );

        // Act & Assert
        expect(
          () => service.searchProducts('test query'),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle timeout exception', () async {
        // Arrange
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/cgi/search.pl'),
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timeout',
          ),
        );

        // Act & Assert
        expect(
          () => service.searchProducts('test query'),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle server error', () async {
        // Arrange
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/cgi/search.pl'),
            response: Response(
              requestOptions: RequestOptions(path: '/cgi/search.pl'),
              statusCode: 500,
              data: {'error': 'Internal server error'},
            ),
            message: 'Server error',
          ),
        );

        // Act & Assert
        expect(
          () => service.searchProducts('test query'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('searchProductsByCategory Tests', () {
      test('should search products by protein category', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'protein-product-1',
            'product_name': 'High Protein Product',
            'brands': 'Protein Brand',
            'nutriments': {'proteins_100g': 25.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory('protein');

        // Assert
        expect(result, isA<List<dynamic>>());
        // Private metodlar birden fazla API çağrısı yapabilir, bu yüzden exact count beklemeyelim
        expect(result.length, greaterThanOrEqualTo(1));
        expect(result[0]['product_name'], equals('High Protein Product'));
      });

      test('should search products by carbohydrate category', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'carb-product-1',
            'product_name': 'High Carb Product',
            'brands': 'Carb Brand',
            'nutriments': {'carbohydrates_100g': 50.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory('karbonhidrat');

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, greaterThanOrEqualTo(1));
        expect(result[0]['product_name'], equals('High Carb Product'));
      });

      test('should search products by fat category', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'fat-product-1',
            'product_name': 'High Fat Product',
            'brands': 'Fat Brand',
            'nutriments': {'fat_100g': 30.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory('yağ');

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, greaterThanOrEqualTo(1));
        expect(result[0]['product_name'], equals('High Fat Product'));
      });

      test('should search products by vitamin category', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'vitamin-product-1',
            'product_name': 'High Vitamin Product',
            'brands': 'Vitamin Brand',
            'nutriments': {'vitamin-c_100g': 100.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory('vitamin');

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, greaterThanOrEqualTo(1));
        expect(result[0]['product_name'], equals('High Vitamin Product'));
      });

      test('should search products by fiber category', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'fiber-product-1',
            'product_name': 'High Fiber Product',
            'brands': 'Fiber Brand',
            'nutriments': {'fiber_100g': 15.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory('lif');

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, greaterThanOrEqualTo(1));
        expect(result[0]['product_name'], equals('High Fiber Product'));
      });

      test('should search products by generic category', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'generic-product-1',
            'product_name': 'Generic Product',
            'brands': 'Generic Brand',
            'nutriments': {'proteins_100g': 10.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory('beverages');

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, equals(1));
        expect(result[0]['product_name'], equals('Generic Product'));
      });

      test('should handle empty category', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory('');

        // Assert
        expect(result, isEmpty);
      });

      test('should handle category search with country parameter', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'local-product-1',
            'product_name': 'Local Product',
            'brands': 'Local Brand',
            'nutriments': {'proteins_100g': 10.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory(
          'generic-category', // Generic category kullan ki private metodlar çağrılmasın
          country: 'turkey',
        );

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, greaterThanOrEqualTo(1));
        expect(result[0]['product_name'], equals('Local Product'));
      });

      test('should handle category search with pagination', () async {
        // Arrange
        final mockProducts = [
          {
            'id': 'page2-product-1',
            'product_name': 'Page 2 Product',
            'brands': 'Page 2 Brand',
            'nutriments': {'proteins_100g': 10.0},
          },
        ];

        when(mockResponse.data).thenReturn({'products': mockProducts});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProductsByCategory(
          'generic-category', // Generic category kullan ki private metodlar çağrılmasın
          page: 2,
          pageSize: 10,
        );

        // Assert
        expect(result, isA<List<dynamic>>());
        expect(result.length, greaterThanOrEqualTo(1));
        expect(result[0]['product_name'], equals('Page 2 Product'));
      });

      test('should handle category search error', () async {
        // Arrange
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/cgi/search.pl'),
            message: 'Category search failed',
          ),
        );

        // Act & Assert
        expect(
          () => service.searchProductsByCategory('generic-category'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very long search query', () async {
        // Arrange
        final longQuery = 'a' * 1000;
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts(longQuery);

        // Assert
        expect(result, isEmpty);
      });

      test('should handle special characters in query', () async {
        // Arrange
        final specialQuery = 'test@#\$%^&*()_+{}|:"<>?[]\\\\;\',./';
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts(specialQuery);

        // Assert
        expect(result, isEmpty);
      });

      test('should handle very large page numbers', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts(
          'test',
          page: 999999,
          pageSize: 1000,
        );

        // Assert
        expect(result, isEmpty);
      });

      test('should handle zero page size', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts(
          'test',
          page: 1,
          pageSize: 0,
        );

        // Assert
        expect(result, isEmpty);
      });

      test('should handle negative page number', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts(
          'test',
          page: -1,
          pageSize: 20,
        );

        // Assert
        expect(result, isEmpty);
      });

      test('should handle null country parameter', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts('test', country: null);

        // Assert
        expect(result, isEmpty);
      });

      test('should handle empty country parameter', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': []});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final result = await service.searchProducts('test', country: '');

        // Assert
        expect(result, isEmpty);
      });
    });

    group('Response Data Validation Tests', () {
      test('should handle malformed response data', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': 'invalid json'});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(() => service.searchProducts('test'), throwsA(isA<Exception>()));
      });

      test('should handle null response data', () async {
        // Arrange
        when(mockResponse.data).thenReturn(null);
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(() => service.searchProducts('test'), throwsA(isA<Exception>()));
      });

      test('should handle products as non-list', () async {
        // Arrange
        when(mockResponse.data).thenReturn({'products': 'not a list'});
        when(
          mockDio.get(any, queryParameters: anyNamed('queryParameters')),
        ).thenAnswer((_) async => mockResponse);

        // Act & Assert
        expect(() => service.searchProducts('test'), throwsA(isA<Exception>()));
      });
    });
  });
}
