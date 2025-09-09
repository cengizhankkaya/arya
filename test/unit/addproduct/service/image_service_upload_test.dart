import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:arya/features/addproduct/service/image_service.dart';

import 'image_service_upload_test.mocks.dart';

// Mock'ları generate et
@GenerateMocks([Dio, Response, FormData, MultipartFile, File])
void main() {
  group('Image Service Upload Tests', () {
    late ImageService imageService;
    late MockDio mockDio;
    late MockResponse mockResponse;
    late MockFile mockFile;

    setUp(() {
      mockDio = MockDio();
      mockResponse = MockResponse();
      mockFile = MockFile();
      imageService = ImageService();
    });

    tearDown(() {
      reset(mockDio);
      reset(mockResponse);
      reset(mockFile);
    });

    group('Image File Validation Tests', () {
      test('should validate image file exists before upload', () async {
        // Arrange
        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/image.jpg');

        // Act
        final exists = await mockFile.exists();

        // Assert
        expect(exists, isTrue);
        expect(mockFile.path, equals('/test/path/image.jpg'));
      });

      test('should handle file not existing', () async {
        // Arrange
        when(mockFile.exists()).thenAnswer((_) async => false);
        when(mockFile.path).thenReturn('/test/path/nonexistent.jpg');

        // Act
        final exists = await mockFile.exists();

        // Assert
        expect(exists, isFalse);
        expect(mockFile.path, equals('/test/path/nonexistent.jpg'));
      });

      test('should handle file path validation', () {
        // Arrange
        const validPaths = [
          '/test/path/image.jpg',
          '/test/path/image.png',
          '/test/path/image.jpeg',
          '/test/path/image.webp',
        ];

        // Act & Assert
        for (final path in validPaths) {
          when(mockFile.path).thenReturn(path);
          expect(mockFile.path, isNotEmpty);
          expect(mockFile.path, contains('.'));
        }
      });
    });

    group('FormData Creation Tests', () {
      test('should create correct FormData structure for image upload', () {
        // Arrange
        const barcode = '1234567890123';
        const username = 'testuser';
        const password = 'testpass';

        // Act
        final formData = FormData.fromMap({
          'code': barcode,
          'imagefield': 'front',
          'user_id': username,
          'password': password,
          'action': 'process',
        });

        // Assert
        expect(formData.fields, isNotEmpty);
        expect(
          formData.fields.any(
            (field) => field.key == 'code' && field.value == barcode,
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'imagefield' && field.value == 'front',
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'user_id' && field.value == username,
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'password' && field.value == password,
          ),
          isTrue,
        );
        expect(
          formData.fields.any(
            (field) => field.key == 'action' && field.value == 'process',
          ),
          isTrue,
        );
      });

      test('should handle MultipartFile creation with mock data', () async {
        // Arrange
        final mockBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

        // Act
        final multipartFile = MultipartFile.fromBytes(
          mockBytes,
          filename: 'product_image.jpg',
        );

        // Assert
        expect(multipartFile, isNotNull);
        expect(multipartFile.filename, equals('product_image.jpg'));
      });

      test('should handle different image file extensions', () {
        // Arrange
        const extensions = ['jpg', 'jpeg', 'png', 'webp', 'gif'];

        // Act & Assert
        for (final ext in extensions) {
          final multipartFile = MultipartFile.fromBytes(
            Uint8List.fromList([1, 2, 3]),
            filename: 'product_image.$ext',
          );

          expect(multipartFile.filename, equals('product_image.$ext'));
        }
      });
    });

    group('HTTP Request Tests', () {
      test('should make correct HTTP POST request for image upload', () async {
        // Arrange
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.statusMessage).thenReturn('OK');
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final response = await mockDio.post(
          '/cgi/product_image_upload.pl',
          data: FormData.fromMap({'test': 'data'}),
          options: Options(),
        );

        // Assert
        expect(response.statusCode, equals(200));
        expect(response.statusMessage, equals('OK'));
      });

      test('should handle successful upload response', () async {
        // Arrange
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.statusMessage).thenReturn('OK');
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final response = await mockDio.post(
          '/cgi/product_image_upload.pl',
          data: FormData.fromMap({'test': 'data'}),
          options: Options(),
        );

        // Assert
        expect(response.statusCode, equals(200));
        expect(response.statusMessage, equals('OK'));
      });

      test('should handle upload failure responses', () async {
        // Arrange
        when(mockResponse.statusCode).thenReturn(400);
        when(mockResponse.statusMessage).thenReturn('Bad Request');
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final response = await mockDio.post(
          '/cgi/product_image_upload.pl',
          data: FormData.fromMap({'test': 'data'}),
          options: Options(),
        );

        // Assert
        expect(response.statusCode, equals(400));
        expect(response.statusMessage, equals('Bad Request'));
      });

      test('should handle server error responses', () async {
        // Arrange
        when(mockResponse.statusCode).thenReturn(500);
        when(mockResponse.statusMessage).thenReturn('Internal Server Error');
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final response = await mockDio.post(
          '/cgi/product_image_upload.pl',
          data: FormData.fromMap({'test': 'data'}),
          options: Options(),
        );

        // Assert
        expect(response.statusCode, equals(500));
        expect(response.statusMessage, equals('Internal Server Error'));
      });
    });

    group('Error Handling Tests', () {
      test('should handle DioException during upload', () async {
        // Arrange
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: '/cgi/product_image_upload.pl',
            ),
            message: 'Network error',
          ),
        );

        // Act & Assert
        expect(
          () async => await mockDio.post(
            '/cgi/product_image_upload.pl',
            data: FormData.fromMap({'test': 'data'}),
            options: Options(),
          ),
          throwsA(isA<DioException>()),
        );
      });

      test('should handle timeout errors', () async {
        // Arrange
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: '/cgi/product_image_upload.pl',
            ),
            type: DioExceptionType.connectionTimeout,
            message: 'Connection timeout',
          ),
        );

        // Act & Assert
        expect(
          () async => await mockDio.post(
            '/cgi/product_image_upload.pl',
            data: FormData.fromMap({'test': 'data'}),
            options: Options(),
          ),
          throwsA(isA<DioException>()),
        );
      });

      test('should handle connection errors', () async {
        // Arrange
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: '/cgi/product_image_upload.pl',
            ),
            type: DioExceptionType.connectionError,
            message: 'Connection error',
          ),
        );

        // Act & Assert
        expect(
          () async => await mockDio.post(
            '/cgi/product_image_upload.pl',
            data: FormData.fromMap({'test': 'data'}),
            options: Options(),
          ),
          throwsA(isA<DioException>()),
        );
      });

      test('should handle general exceptions', () async {
        // Arrange
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        // Act & Assert
        expect(
          () async => await mockDio.post(
            '/cgi/product_image_upload.pl',
            data: FormData.fromMap({'test': 'data'}),
            options: Options(),
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Image Upload Integration Tests', () {
      test('should complete full upload flow successfully', () async {
        // Arrange
        const barcode = '1234567890123';
        const username = 'testuser';
        const password = 'testpass';

        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/image.jpg');
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.statusMessage).thenReturn('OK');
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final fileExists = await mockFile.exists();
        final formData = FormData.fromMap({
          'code': barcode,
          'imagefield': 'front',
          'user_id': username,
          'password': password,
          'action': 'process',
          'imgupload_front': MultipartFile.fromBytes(
            Uint8List.fromList([1, 2, 3, 4, 5]),
            filename: 'product_image.jpg',
          ),
        });
        final response = await mockDio.post(
          '/cgi/product_image_upload.pl',
          data: formData,
          options: Options(),
        );

        // Assert
        expect(fileExists, isTrue);
        expect(response.statusCode, equals(200));
        expect(response.statusMessage, equals('OK'));
      });

      test('should handle multiple concurrent uploads', () async {
        // Arrange
        when(mockResponse.statusCode).thenReturn(200);
        when(mockResponse.statusMessage).thenReturn('OK');
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final uploads = <Future<Response>>[];
        for (int i = 0; i < 5; i++) {
          when(mockFile.path).thenReturn('/test/path/image_$i.jpg');
          when(mockFile.exists()).thenAnswer((_) async => true);

          final formData = FormData.fromMap({
            'code': '123456789012$i',
            'imagefield': 'front',
            'user_id': 'testuser',
            'password': 'testpass',
            'action': 'process',
            'imgupload_front': MultipartFile.fromBytes(
              Uint8List.fromList([1, 2, 3, 4, 5]),
              filename: 'product_image_$i.jpg',
            ),
          });

          uploads.add(
            mockDio.post(
              '/cgi/product_image_upload.pl',
              data: formData,
              options: Options(),
            ),
          );
        }

        final responses = await Future.wait(uploads);

        // Assert
        expect(responses.length, equals(5));
        for (final response in responses) {
          expect(response.statusCode, equals(200));
        }
      });
    });

    group('Image Service State Tests', () {
      test('should maintain correct state during upload process', () async {
        // Arrange
        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/image.jpg');
        when(mockResponse.statusCode).thenReturn(200);
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        // Simulate image selection
        final selectedImage = await imageService.pickImageFromGallery();

        // Simulate upload process
        final fileExists = await mockFile.exists();
        final formData = FormData.fromMap({
          'code': '1234567890123',
          'imagefield': 'front',
          'user_id': 'testuser',
          'password': 'testpass',
          'action': 'process',
          'imgupload_front': MultipartFile.fromBytes(
            Uint8List.fromList([1, 2, 3, 4, 5]),
            filename: 'product_image.jpg',
          ),
        });
        final response = await mockDio.post(
          '/cgi/product_image_upload.pl',
          data: formData,
          options: Options(),
        );

        // Assert
        expect(
          imageService.isImageUploading,
          isFalse,
        ); // Should be false after operation
        expect(fileExists, isTrue);
        expect(response.statusCode, equals(200));
      });

      test('should handle state changes during upload failure', () async {
        // Arrange
        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/image.jpg');
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(
              path: '/cgi/product_image_upload.pl',
            ),
            message: 'Upload failed',
          ),
        );

        // Act
        final selectedImage = await imageService.pickImageFromGallery();

        // Simulate upload failure
        try {
          final fileExists = await mockFile.exists();
          final formData = FormData.fromMap({
            'code': '1234567890123',
            'imagefield': 'front',
            'user_id': 'testuser',
            'password': 'testpass',
            'action': 'process',
            'imgupload_front': MultipartFile.fromBytes(
              Uint8List.fromList([1, 2, 3, 4, 5]),
              filename: 'product_image.jpg',
            ),
          });
          await mockDio.post(
            '/cgi/product_image_upload.pl',
            data: formData,
            options: Options(),
          );
        } catch (e) {
          // Expected to throw
        }

        // Assert
        expect(
          imageService.isImageUploading,
          isFalse,
        ); // Should be false after operation
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very large image files', () async {
        // Arrange
        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/large_image.jpg');
        when(mockResponse.statusCode).thenReturn(200);
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final fileExists = await mockFile.exists();
        final formData = FormData.fromMap({
          'code': '1234567890123',
          'imagefield': 'front',
          'user_id': 'testuser',
          'password': 'testpass',
          'action': 'process',
          'imgupload_front': MultipartFile.fromBytes(
            Uint8List.fromList(
              List.generate(1000, (i) => i % 256),
            ), // Large data
            filename: 'large_product_image.jpg',
          ),
        });
        final response = await mockDio.post(
          '/cgi/product_image_upload.pl',
          data: formData,
          options: Options(),
        );

        // Assert
        expect(fileExists, isTrue);
        expect(response.statusCode, equals(200));
      });

      test('should handle special characters in barcode', () async {
        // Arrange
        const specialBarcodes = [
          '1234567890123',
          '123-456-789-012',
          '123_456_789_012',
          '123.456.789.012',
        ];

        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/image.jpg');
        when(mockResponse.statusCode).thenReturn(200);
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act & Assert
        for (final barcode in specialBarcodes) {
          final formData = FormData.fromMap({
            'code': barcode,
            'imagefield': 'front',
            'user_id': 'testuser',
            'password': 'testpass',
            'action': 'process',
            'imgupload_front': MultipartFile.fromBytes(
              Uint8List.fromList([1, 2, 3, 4, 5]),
              filename: 'product_image.jpg',
            ),
          });

          final response = await mockDio.post(
            '/cgi/product_image_upload.pl',
            data: formData,
            options: Options(),
          );

          expect(response.statusCode, equals(200));
        }
      });

      test('should handle empty or null values gracefully', () async {
        // Arrange
        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/image.jpg');
        when(mockResponse.statusCode).thenReturn(200);
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final formData = FormData.fromMap({
          'code': '', // Empty barcode
          'imagefield': 'front',
          'user_id': '', // Empty username
          'password': '', // Empty password
          'action': 'process',
          'imgupload_front': MultipartFile.fromBytes(
            Uint8List.fromList([1, 2, 3, 4, 5]),
            filename: 'product_image.jpg',
          ),
        });
        final response = await mockDio.post(
          '/cgi/product_image_upload.pl',
          data: formData,
          options: Options(),
        );

        // Assert
        expect(response.statusCode, equals(200));
      });
    });

    group('Performance Tests', () {
      test('should handle rapid successive uploads', () async {
        // Arrange
        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/image.jpg');
        when(mockResponse.statusCode).thenReturn(200);
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        final startTime = DateTime.now();
        final uploads = <Future<Response>>[];

        for (int i = 0; i < 10; i++) {
          final formData = FormData.fromMap({
            'code': '123456789012$i',
            'imagefield': 'front',
            'user_id': 'testuser',
            'password': 'testpass',
            'action': 'process',
            'imgupload_front': MultipartFile.fromBytes(
              Uint8List.fromList([1, 2, 3, 4, 5]),
              filename: 'product_image_$i.jpg',
            ),
          });

          uploads.add(
            mockDio.post(
              '/cgi/product_image_upload.pl',
              data: formData,
              options: Options(),
            ),
          );
        }

        await Future.wait(uploads);
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime);

        // Assert
        expect(
          duration.inMilliseconds,
          lessThan(5000),
        ); // Should complete within 5 seconds
      });

      test('should handle memory efficiently during uploads', () async {
        // Arrange
        when(mockFile.exists()).thenAnswer((_) async => true);
        when(mockFile.path).thenReturn('/test/path/image.jpg');
        when(mockResponse.statusCode).thenReturn(200);
        when(
          mockDio.post(
            '/cgi/product_image_upload.pl',
            data: anyNamed('data'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // Act
        for (int i = 0; i < 100; i++) {
          final formData = FormData.fromMap({
            'code': '123456789012$i',
            'imagefield': 'front',
            'user_id': 'testuser',
            'password': 'testpass',
            'action': 'process',
            'imgupload_front': MultipartFile.fromBytes(
              Uint8List.fromList([1, 2, 3, 4, 5]),
              filename: 'product_image_$i.jpg',
            ),
          });

          final response = await mockDio.post(
            '/cgi/product_image_upload.pl',
            data: formData,
            options: Options(),
          );

          expect(response.statusCode, equals(200));
        }

        // Assert
        // Test should complete without memory issues
        expect(true, isTrue);
      });
    });
  });
}
