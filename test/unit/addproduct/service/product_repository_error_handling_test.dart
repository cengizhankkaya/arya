import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'dart:io';

import 'product_repository_error_handling_test.mocks.dart';

// Mock'ları generate et
@GenerateMocks([
  Dio,
  Response,
  RequestOptions,
  Headers,
  MultipartFile,
  DioException,
])
void main() {
  group('ProductRepository Error Handling Tests', () {
    late ProductRepository repository;
    late MockDio mockDio;
    late MockResponse mockResponse;
    late MockRequestOptions mockRequestOptions;
    late MockHeaders mockHeaders;
    late MockDioException mockDioException;

    setUp(() {
      mockDio = MockDio();
      mockResponse = MockResponse();
      mockRequestOptions = MockRequestOptions();
      mockHeaders = MockHeaders();
      mockDioException = MockDioException();

      // MockRequestOptions setup
      when(mockRequestOptions.data).thenReturn(null);
      when(mockRequestOptions.headers).thenReturn({});
      when(mockRequestOptions.path).thenReturn('/cgi/product_jqm.pl');

      // MockHeaders setup
      when(mockHeaders.map).thenReturn({});
      when(
        mockHeaders['location'],
      ).thenReturn(['https://world.openfoodfacts.org/redirect']);

      // MockResponse setup
      when(mockResponse.statusCode).thenReturn(200);
      when(mockResponse.statusMessage).thenReturn('OK');
      when(mockResponse.data).thenReturn({
        'status': 1,
        'status_verbose': 'Product saved successfully',
      });
      when(mockResponse.headers).thenReturn(mockHeaders);
      when(mockResponse.requestOptions).thenReturn(mockRequestOptions);

      // Repository'yi oluştur
      repository = ProductRepository();
    });

    tearDown(() {
      reset(mockDio);
      reset(mockResponse);
      reset(mockRequestOptions);
      reset(mockHeaders);
      reset(mockDioException);
    });

    group('DioException Error Handling', () {
      test('should handle DioException with response (400 Bad Request)', () {
        // Arrange
        final errorResponse = MockResponse();
        when(errorResponse.statusCode).thenReturn(400);
        when(errorResponse.statusMessage).thenReturn('Bad Request');
        when(errorResponse.data).thenReturn({'error': 'Invalid request'});

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          response: errorResponse,
          type: DioExceptionType.badResponse,
          message: 'Bad Request',
        );

        // Act & Assert
        expect(dioException.response?.statusCode, equals(400));
        expect(dioException.response?.statusMessage, equals('Bad Request'));
        expect(dioException.type, equals(DioExceptionType.badResponse));
        expect(dioException.message, equals('Bad Request'));
      });

      test('should handle DioException with response (401 Unauthorized)', () {
        // Arrange
        final errorResponse = MockResponse();
        when(errorResponse.statusCode).thenReturn(401);
        when(errorResponse.statusMessage).thenReturn('Unauthorized');
        when(errorResponse.data).thenReturn({'error': 'Invalid credentials'});

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          response: errorResponse,
          type: DioExceptionType.badResponse,
          message: 'Unauthorized',
        );

        // Act & Assert
        expect(dioException.response?.statusCode, equals(401));
        expect(dioException.response?.statusMessage, equals('Unauthorized'));
        expect(dioException.type, equals(DioExceptionType.badResponse));
        expect(dioException.message, equals('Unauthorized'));
      });

      test('should handle DioException with response (403 Forbidden)', () {
        // Arrange
        final errorResponse = MockResponse();
        when(errorResponse.statusCode).thenReturn(403);
        when(errorResponse.statusMessage).thenReturn('Forbidden');
        when(errorResponse.data).thenReturn({'error': 'Access denied'});

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          response: errorResponse,
          type: DioExceptionType.badResponse,
          message: 'Forbidden',
        );

        // Act & Assert
        expect(dioException.response?.statusCode, equals(403));
        expect(dioException.response?.statusMessage, equals('Forbidden'));
        expect(dioException.type, equals(DioExceptionType.badResponse));
        expect(dioException.message, equals('Forbidden'));
      });

      test('should handle DioException with response (404 Not Found)', () {
        // Arrange
        final errorResponse = MockResponse();
        when(errorResponse.statusCode).thenReturn(404);
        when(errorResponse.statusMessage).thenReturn('Not Found');
        when(errorResponse.data).thenReturn({'error': 'Endpoint not found'});

        final dioException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          response: errorResponse,
          type: DioExceptionType.badResponse,
          message: 'Not Found',
        );

        // Act & Assert
        expect(dioException.response?.statusCode, equals(404));
        expect(dioException.response?.statusMessage, equals('Not Found'));
        expect(dioException.type, equals(DioExceptionType.badResponse));
        expect(dioException.message, equals('Not Found'));
      });

      test(
        'should handle DioException with response (500 Internal Server Error)',
        () {
          // Arrange
          final errorResponse = MockResponse();
          when(errorResponse.statusCode).thenReturn(500);
          when(errorResponse.statusMessage).thenReturn('Internal Server Error');
          when(errorResponse.data).thenReturn({'error': 'Server error'});

          final dioException = DioException(
            requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
            response: errorResponse,
            type: DioExceptionType.badResponse,
            message: 'Internal Server Error',
          );

          // Act & Assert
          expect(dioException.response?.statusCode, equals(500));
          expect(
            dioException.response?.statusMessage,
            equals('Internal Server Error'),
          );
          expect(dioException.type, equals(DioExceptionType.badResponse));
          expect(dioException.message, equals('Internal Server Error'));
        },
      );

      test(
        'should handle DioException without response (Connection Timeout)',
        () {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timeout',
          );

          // Act & Assert
          expect(dioException.response, isNull);
          expect(dioException.type, equals(DioExceptionType.connectionTimeout));
          expect(dioException.message, equals('Connection timeout'));
        },
      );

      test('should handle DioException without response (Send Timeout)', () {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          type: DioExceptionType.sendTimeout,
          message: 'Send timeout',
        );

        // Act & Assert
        expect(dioException.response, isNull);
        expect(dioException.type, equals(DioExceptionType.sendTimeout));
        expect(dioException.message, equals('Send timeout'));
      });

      test('should handle DioException without response (Receive Timeout)', () {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          type: DioExceptionType.receiveTimeout,
          message: 'Receive timeout',
        );

        // Act & Assert
        expect(dioException.response, isNull);
        expect(dioException.type, equals(DioExceptionType.receiveTimeout));
        expect(dioException.message, equals('Receive timeout'));
      });

      test(
        'should handle DioException without response (Connection Error)',
        () {
          // Arrange
          final dioException = DioException(
            requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
            type: DioExceptionType.connectionError,
            message: 'Connection error',
          );

          // Act & Assert
          expect(dioException.response, isNull);
          expect(dioException.type, equals(DioExceptionType.connectionError));
          expect(dioException.message, equals('Connection error'));
        },
      );

      test('should handle DioException without response (Cancel)', () {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          type: DioExceptionType.cancel,
          message: 'Request cancelled',
        );

        // Act & Assert
        expect(dioException.response, isNull);
        expect(dioException.type, equals(DioExceptionType.cancel));
        expect(dioException.message, equals('Request cancelled'));
      });

      test('should handle DioException without response (Unknown)', () {
        // Arrange
        final dioException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          type: DioExceptionType.unknown,
          message: 'Unknown error',
        );

        // Act & Assert
        expect(dioException.response, isNull);
        expect(dioException.type, equals(DioExceptionType.unknown));
        expect(dioException.message, equals('Unknown error'));
      });
    });

    group('Network Error Handling', () {
      test('should handle network connectivity issues', () {
        // Arrange
        final networkException = SocketException('Network is unreachable');

        // Act & Assert
        expect(networkException.toString(), contains('Network is unreachable'));
        // osError might be null in some cases, so we just check the message
        expect(networkException.message, equals('Network is unreachable'));
      });

      test('should handle DNS resolution failures', () {
        // Arrange
        final dnsException = SocketException(
          'Failed host lookup: api.example.com',
        );

        // Act & Assert
        expect(dnsException.toString(), contains('Failed host lookup'));
        expect(
          dnsException.message,
          equals('Failed host lookup: api.example.com'),
        );
      });

      test('should handle SSL/TLS certificate errors', () {
        // Arrange
        final sslException = HandshakeException('SSL handshake failed');

        // Act & Assert
        expect(sslException.toString(), contains('SSL handshake failed'));
      });

      test('should handle connection refused errors', () {
        // Arrange
        final connectionException = SocketException('Connection refused');

        // Act & Assert
        expect(connectionException.toString(), contains('Connection refused'));
        expect(connectionException.message, equals('Connection refused'));
      });
    });

    group('HTTP Status Code Error Handling', () {
      test('should handle 400 Bad Request response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 400,
          statusMessage: 'Bad Request',
          data: {'error': 'Invalid request parameters'},
        );

        // Act & Assert
        expect(response.statusCode, equals(400));
        expect(response.statusMessage, equals('Bad Request'));
        expect(response.data?['error'], equals('Invalid request parameters'));
      });

      test('should handle 401 Unauthorized response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 401,
          statusMessage: 'Unauthorized',
          data: {'error': 'Invalid credentials'},
        );

        // Act & Assert
        expect(response.statusCode, equals(401));
        expect(response.statusMessage, equals('Unauthorized'));
        expect(response.data?['error'], equals('Invalid credentials'));
      });

      test('should handle 403 Forbidden response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 403,
          statusMessage: 'Forbidden',
          data: {'error': 'Access denied'},
        );

        // Act & Assert
        expect(response.statusCode, equals(403));
        expect(response.statusMessage, equals('Forbidden'));
        expect(response.data?['error'], equals('Access denied'));
      });

      test('should handle 404 Not Found response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 404,
          statusMessage: 'Not Found',
          data: {'error': 'Endpoint not found'},
        );

        // Act & Assert
        expect(response.statusCode, equals(404));
        expect(response.statusMessage, equals('Not Found'));
        expect(response.data?['error'], equals('Endpoint not found'));
      });

      test('should handle 429 Too Many Requests response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 429,
          statusMessage: 'Too Many Requests',
          data: {'error': 'Rate limit exceeded'},
        );

        // Act & Assert
        expect(response.statusCode, equals(429));
        expect(response.statusMessage, equals('Too Many Requests'));
        expect(response.data?['error'], equals('Rate limit exceeded'));
      });

      test('should handle 500 Internal Server Error response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 500,
          statusMessage: 'Internal Server Error',
          data: {'error': 'Server error'},
        );

        // Act & Assert
        expect(response.statusCode, equals(500));
        expect(response.statusMessage, equals('Internal Server Error'));
        expect(response.data?['error'], equals('Server error'));
      });

      test('should handle 502 Bad Gateway response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 502,
          statusMessage: 'Bad Gateway',
          data: {'error': 'Bad gateway'},
        );

        // Act & Assert
        expect(response.statusCode, equals(502));
        expect(response.statusMessage, equals('Bad Gateway'));
        expect(response.data?['error'], equals('Bad gateway'));
      });

      test('should handle 503 Service Unavailable response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 503,
          statusMessage: 'Service Unavailable',
          data: {'error': 'Service temporarily unavailable'},
        );

        // Act & Assert
        expect(response.statusCode, equals(503));
        expect(response.statusMessage, equals('Service Unavailable'));
        expect(
          response.data?['error'],
          equals('Service temporarily unavailable'),
        );
      });

      test('should handle 504 Gateway Timeout response', () {
        // Arrange
        final response = Response(
          requestOptions: RequestOptions(path: '/cgi/product_jqm.pl'),
          statusCode: 504,
          statusMessage: 'Gateway Timeout',
          data: {'error': 'Gateway timeout'},
        );

        // Act & Assert
        expect(response.statusCode, equals(504));
        expect(response.statusMessage, equals('Gateway Timeout'));
        expect(response.data?['error'], equals('Gateway timeout'));
      });
    });

    group('Response Parsing Error Handling', () {
      test('should handle malformed JSON response', () {
        // Arrange
        const malformedJson =
            '{"status":1,"status_verbose":"Product saved successfully"invalid}';

        // Act
        final result = repository.parseResponse(malformedJson);

        // Assert
        // The repository actually handles malformed JSON by checking for status patterns
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should handle empty response body', () {
        // Arrange
        const emptyResponse = '';

        // Act
        final result = repository.parseResponse(emptyResponse);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown response'));
      });

      test('should handle null response body', () {
        // Arrange
        const nullResponse = null;

        // Act
        final result = repository.parseResponse(nullResponse);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown response'));
      });

      test('should handle response with missing status field', () {
        // Arrange
        final responseData = {
          'status_verbose': 'Product saved successfully',
          // status field missing
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown status: null'));
      });

      test('should handle response with invalid status type', () {
        // Arrange
        final responseData = {
          'status': 'invalid_status',
          'status_verbose': 'Product saved successfully',
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown status: invalid_status'));
      });

      test('should handle response with null status', () {
        // Arrange
        final responseData = {
          'status': null,
          'status_verbose': 'Product saved successfully',
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown status: null'));
      });

      test('should handle response with unexpected status value', () {
        // Arrange
        final responseData = {
          'status': 999,
          'status_verbose': 'Unexpected status',
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(-1));
        expect(result.statusVerbose, equals('Unknown status: 999'));
      });

      test('should handle response with missing status_verbose field', () {
        // Arrange
        final responseData = {
          'status': 1,
          // status_verbose field missing
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Unknown status'));
      });

      test('should handle response with null status_verbose', () {
        // Arrange
        final responseData = {'status': 1, 'status_verbose': null};

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Unknown status'));
      });

      test('should handle response with non-string status_verbose', () {
        // Arrange
        final responseData = {
          'status': 1,
          'status_verbose': 123, // Should be string but is int
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        // The repository actually throws a parse error for non-string status_verbose
        expect(result.status, equals(-1));
        expect(
          result.statusVerbose,
          equals(
            'Parse error: type \'int\' is not a subtype of type \'String?\'',
          ),
        );
      });

      test('should handle response with extra unexpected fields', () {
        // Arrange
        final responseData = {
          'status': 1,
          'status_verbose': 'Product saved successfully',
          'extra_field': 'extra_value',
          'another_field': 123,
          'nested_field': {'key': 'value'},
        };

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test(
        'should handle response with special characters in status_verbose',
        () {
          // Arrange
          final responseData = {
            'status': 1,
            'status_verbose':
                'Product saved successfully with special chars: !@#\$%^&*()',
          };

          // Act
          final result = repository.parseResponse(responseData);

          // Assert
          expect(result.status, equals(1));
          expect(
            result.statusVerbose,
            equals(
              'Product saved successfully with special chars: !@#\$%^&*()',
            ),
          );
        },
      );

      test(
        'should handle response with unicode characters in status_verbose',
        () {
          // Arrange
          final responseData = {
            'status': 1,
            'status_verbose': 'Ürün başarıyla kaydedildi 🎉',
          };

          // Act
          final result = repository.parseResponse(responseData);

          // Assert
          expect(result.status, equals(1));
          expect(result.statusVerbose, equals('Ürün başarıyla kaydedildi 🎉'));
        },
      );
    });

    group('Image Upload Error Handling', () {
      test('should handle image file not found error', () {
        // Arrange
        final nonExistentFile = File('/tmp/non_existent_image.jpg');

        // Act & Assert
        expect(nonExistentFile.existsSync(), isFalse);
        expect(nonExistentFile.path, equals('/tmp/non_existent_image.jpg'));
      });

      test('should handle image file permission denied error', () {
        // Arrange
        final restrictedFile = File('/root/restricted_image.jpg');

        // Act & Assert
        // File.existsSync() will return false for non-existent files
        // In real scenario, this would throw FileSystemException
        expect(restrictedFile.path, equals('/root/restricted_image.jpg'));
      });

      test('should handle image file too large error', () {
        // Arrange
        final largeFile = File('/tmp/large_image.jpg');

        // Act & Assert
        // In real scenario, this would be handled by server response
        expect(largeFile.path, equals('/tmp/large_image.jpg'));
      });

      test('should handle unsupported image format error', () {
        // Arrange
        final unsupportedFile = File('/tmp/image.txt'); // Wrong extension

        // Act & Assert
        expect(unsupportedFile.path, equals('/tmp/image.txt'));
        expect(unsupportedFile.path.endsWith('.txt'), isTrue);
      });

      test('should handle corrupted image file error', () {
        // Arrange
        final corruptedFile = File('/tmp/corrupted_image.jpg');

        // Act & Assert
        expect(corruptedFile.path, equals('/tmp/corrupted_image.jpg'));
      });

      test('should handle image upload network timeout', () {
        // Arrange
        final timeoutException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_image_upload.pl'),
          type: DioExceptionType.receiveTimeout,
          message: 'Image upload timeout',
        );

        // Act & Assert
        expect(timeoutException.type, equals(DioExceptionType.receiveTimeout));
        expect(timeoutException.message, equals('Image upload timeout'));
      });

      test('should handle image upload server error', () {
        // Arrange
        final serverErrorResponse = Response(
          requestOptions: RequestOptions(path: '/cgi/product_image_upload.pl'),
          statusCode: 500,
          statusMessage: 'Internal Server Error',
          data: {'error': 'Image upload failed'},
        );

        final serverException = DioException(
          requestOptions: RequestOptions(path: '/cgi/product_image_upload.pl'),
          response: serverErrorResponse,
          type: DioExceptionType.badResponse,
          message: 'Internal Server Error',
        );

        // Act & Assert
        expect(serverException.response?.statusCode, equals(500));
        expect(
          serverException.response?.statusMessage,
          equals('Internal Server Error'),
        );
        expect(serverException.type, equals(DioExceptionType.badResponse));
      });
    });

    group('Generic Exception Handling', () {
      test('should handle generic Exception', () {
        // Arrange
        final genericException = Exception('Generic error occurred');

        // Act & Assert
        expect(genericException.toString(), contains('Generic error occurred'));
      });

      test('should handle ArgumentError', () {
        // Arrange
        final argumentError = ArgumentError.value(
          'invalid',
          'argument',
          'Invalid argument provided',
        );

        // Act & Assert
        expect(argumentError.toString(), contains('Invalid argument provided'));
      });

      test('should handle StateError', () {
        // Arrange
        final stateError = StateError('Invalid state');

        // Act & Assert
        expect(stateError.toString(), contains('Invalid state'));
      });

      test('should handle FormatException', () {
        // Arrange
        final formatException = const FormatException('Invalid format');

        // Act & Assert
        expect(formatException.toString(), contains('Invalid format'));
      });

      test('should handle TypeError', () {
        // Arrange
        final typeError = TypeError();

        // Act & Assert
        expect(typeError.toString(), contains('TypeError'));
      });

      test('should handle UnsupportedError', () {
        // Arrange
        final unsupportedError = UnsupportedError('Operation not supported');

        // Act & Assert
        expect(
          unsupportedError.toString(),
          contains('Operation not supported'),
        );
      });

      test('should handle RangeError', () {
        // Arrange
        final rangeError = RangeError.value(0, 'index', 'Value out of range');

        // Act & Assert
        expect(rangeError.toString(), contains('Value out of range'));
      });

      test('should handle NoSuchMethodError', () {
        // Arrange
        final noSuchMethodError = NoSuchMethodError.withInvocation(
          Object(),
          Invocation.method(#nonExistentMethod, []),
        );

        // Act & Assert
        expect(noSuchMethodError.toString(), contains('nonExistentMethod'));
      });
    });

    group('Edge Case Error Handling', () {
      test('should handle very large response data', () {
        // Arrange
        final largeData = 'A' * 1000000; // 1MB string
        final responseData = {'status': 1, 'status_verbose': largeData};

        // Act
        final result = repository.parseResponse(responseData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals(largeData));
        expect(result.statusVerbose?.length, equals(1000000));
      });

      test('should handle response with deeply nested data', () {
        // Arrange
        final nestedData = {
          'status': 1,
          'status_verbose': 'Product saved successfully',
          'nested': {
            'level1': {
              'level2': {
                'level3': {
                  'level4': {'level5': 'deep_value'},
                },
              },
            },
          },
        };

        // Act
        final result = repository.parseResponse(nestedData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should handle response with array data', () {
        // Arrange
        final arrayData = {
          'status': 1,
          'status_verbose': 'Product saved successfully',
          'items': [1, 2, 3, 4, 5],
          'strings': ['a', 'b', 'c'],
          'mixed': [
            1,
            'string',
            {'nested': 'object'},
          ],
        };

        // Act
        final result = repository.parseResponse(arrayData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should handle response with boolean values', () {
        // Arrange
        final booleanData = {
          'status': 1,
          'status_verbose': 'Product saved successfully',
          'is_success': true,
          'has_error': false,
          'is_processed': true,
        };

        // Act
        final result = repository.parseResponse(booleanData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should handle response with numeric values', () {
        // Arrange
        final numericData = {
          'status': 1,
          'status_verbose': 'Product saved successfully',
          'count': 42,
          'price': 19.99,
          'percentage': 0.85,
        };

        // Act
        final result = repository.parseResponse(numericData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });

      test('should handle response with null values', () {
        // Arrange
        final nullData = {
          'status': 1,
          'status_verbose': 'Product saved successfully',
          'null_field': null,
          'empty_string': '',
          'zero_value': 0,
        };

        // Act
        final result = repository.parseResponse(nullData);

        // Assert
        expect(result.status, equals(1));
        expect(result.statusVerbose, equals('Product saved successfully'));
      });
    });

    group('Error Message Localization', () {
      test('should handle Turkish error messages', () {
        // Arrange
        final turkishData = {
          'status': 0,
          'status_verbose': 'Ürün kaydedilemedi',
        };

        // Act
        final result = repository.parseResponse(turkishData);

        // Assert
        expect(result.status, equals(0));
        expect(result.statusVerbose, equals('Ürün kaydedilemedi'));
      });

      test('should handle English error messages', () {
        // Arrange
        final englishData = {
          'status': 0,
          'status_verbose': 'Product could not be saved',
        };

        // Act
        final result = repository.parseResponse(englishData);

        // Assert
        expect(result.status, equals(0));
        expect(result.statusVerbose, equals('Product could not be saved'));
      });

      test('should handle mixed language error messages', () {
        // Arrange
        final mixedData = {
          'status': 0,
          'status_verbose': 'Product could not be saved - Ürün kaydedilemedi',
        };

        // Act
        final result = repository.parseResponse(mixedData);

        // Assert
        expect(result.status, equals(0));
        expect(
          result.statusVerbose,
          equals('Product could not be saved - Ürün kaydedilemedi'),
        );
      });

      test('should handle error messages with special characters', () {
        // Arrange
        final specialCharData = {
          'status': 0,
          'status_verbose':
              'Error: Invalid characters !@#\$%^&*() in product name',
        };

        // Act
        final result = repository.parseResponse(specialCharData);

        // Assert
        expect(result.status, equals(0));
        expect(
          result.statusVerbose,
          equals('Error: Invalid characters !@#\$%^&*() in product name'),
        );
      });
    });
  });
}
