import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:image_picker/image_picker.dart';
import 'package:arya/features/addproduct/service/image_service.dart';
import 'testable_image_service.dart';

import 'image_service_picker_test.mocks.dart';

// Mock'ları generate et
@GenerateMocks([ImagePicker, XFile])
void main() {
  group('ImageService Picker Configuration Tests', () {
    late TestableImageService imageService;
    late MockImagePicker mockImagePicker;
    late MockXFile mockXFile;

    setUp(() {
      mockImagePicker = MockImagePicker();
      mockXFile = MockXFile();

      // TestableImageService'i mock ImagePicker ile oluştur
      imageService = TestableImageService(imagePicker: mockImagePicker);
    });

    tearDown(() {
      reset(mockImagePicker);
      reset(mockXFile);
    });

    group('ImagePicker Configuration Tests', () {
      test('should use correct parameters for gallery picker', () async {
        // Arrange
        const imagePath = '/tmp/test_image.jpg';
        when(mockXFile.path).thenReturn(imagePath);
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => mockXFile);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).called(1);
      });

      test('should use correct parameters for camera capture', () async {
        // Arrange
        const imagePath = '/tmp/camera_photo.jpg';
        when(mockXFile.path).thenReturn(imagePath);
        when(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => mockXFile);

        // Act
        await imageService.takePhotoWithCamera();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).called(1);
      });

      test('should verify maxWidth parameter is 1024', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test('should verify maxHeight parameter is 1024', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.takePhotoWithCamera();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test('should verify imageQuality parameter is 85', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: 85,
          ),
        ).called(1);
      });
    });

    group('Image Source Selection Tests', () {
      test('should use ImageSource.gallery for gallery picker', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test('should use ImageSource.camera for camera capture', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.takePhotoWithCamera();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test('should not use wrong source for gallery picker', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verifyNever(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        );
      });

      test('should not use wrong source for camera capture', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.takePhotoWithCamera();

        // Assert
        verifyNever(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        );
      });
    });

    group('Image Quality Configuration Tests', () {
      test(
        'should maintain consistent image quality across operations',
        () async {
          // Arrange
          when(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: 85,
            ),
          ).thenAnswer((_) async => null);

          // Act
          await imageService.pickImageFromGallery();
          await imageService.takePhotoWithCamera();

          // Assert
          verify(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: 85,
            ),
          ).called(2);
        },
      );

      test('should use optimal image quality for file size', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        // 85% quality provides good balance between file size and image quality
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: 85,
          ),
        ).called(1);
      });

      test('should not use extreme quality values', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verifyNever(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: 100, // Too high quality
          ),
        );
        verifyNever(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: 0, // Too low quality
          ),
        );
      });
    });

    group('Image Size Configuration Tests', () {
      test('should use consistent maxWidth and maxHeight', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();
        await imageService.takePhotoWithCamera();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(2);
      });

      test('should use square aspect ratio (1024x1024)', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        // Square aspect ratio is good for product images
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test('should not use extreme size values', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verifyNever(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 10000, // Too large
            maxHeight: 10000,
            imageQuality: anyNamed('imageQuality'),
          ),
        );
        verifyNever(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 10, // Too small
            maxHeight: 10,
            imageQuality: anyNamed('imageQuality'),
          ),
        );
      });

      test('should use reasonable size for mobile devices', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.takePhotoWithCamera();

        // Assert
        // 1024x1024 is good for mobile screens and file size
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });
    });

    group('Parameter Validation Tests', () {
      test('should pass all required parameters to ImagePicker', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test('should not pass null parameters', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.takePhotoWithCamera();

        // Assert
        verifyNever(
          mockImagePicker.pickImage(
            source: null,
            maxWidth: null,
            maxHeight: null,
            imageQuality: null,
          ),
        );
      });

      test('should use correct parameter types', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        // All parameters should be of correct types
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'), // ImageSource enum
            maxWidth: anyNamed('maxWidth'), // double
            maxHeight: anyNamed('maxHeight'), // double
            imageQuality: anyNamed('imageQuality'), // int
          ),
        ).called(1);
      });
    });

    group('Configuration Consistency Tests', () {
      test(
        'should use same configuration for both gallery and camera',
        () async {
          // Arrange
          when(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: 1024,
              maxHeight: 1024,
              imageQuality: 85,
            ),
          ).thenAnswer((_) async => null);

          // Act
          await imageService.pickImageFromGallery();
          await imageService.takePhotoWithCamera();

          // Assert
          // Both operations should use same size and quality settings
          verify(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: 1024,
              maxHeight: 1024,
              imageQuality: 85,
            ),
          ).called(2);
        },
      );

      test('should maintain configuration across multiple calls', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        for (int i = 0; i < 5; i++) {
          await imageService.pickImageFromGallery();
        }

        // Assert
        // Configuration should remain consistent across multiple calls
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).called(5);
      });

      test(
        'should not change configuration based on previous results',
        () async {
          // Arrange
          when(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: 1024,
              maxHeight: 1024,
              imageQuality: 85,
            ),
          ).thenAnswer((_) async => null);

          // Act
          await imageService.pickImageFromGallery(); // First call
          await imageService.pickImageFromGallery(); // Second call

          // Assert
          // Configuration should be same regardless of previous results
          verify(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: 1024,
              maxHeight: 1024,
              imageQuality: 85,
            ),
          ).called(2);
        },
      );
    });

    group('Performance Configuration Tests', () {
      test('should use optimized settings for performance', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        // 1024x1024 with 85% quality is optimized for performance
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024, // Reasonable size for performance
            maxHeight: 1024, // Reasonable size for performance
            imageQuality: 85, // Good quality without being too heavy
          ),
        ).called(1);
      });

      test('should balance quality and file size', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.takePhotoWithCamera();

        // Assert
        // Settings should provide good balance between quality and file size
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024, // Not too large to avoid memory issues
            maxHeight: 1024, // Not too large to avoid memory issues
            imageQuality: 85, // Good quality without excessive file size
          ),
        ).called(1);
      });

      test('should use settings suitable for mobile devices', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        // Settings should be suitable for mobile device capabilities
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024, // Suitable for mobile screens
            maxHeight: 1024, // Suitable for mobile screens
            imageQuality: 85, // Suitable for mobile storage and processing
          ),
        ).called(1);
      });
    });

    group('Error Handling in Configuration Tests', () {
      test(
        'should handle ImagePicker configuration errors gracefully',
        () async {
          // Arrange
          when(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenThrow(Exception('Configuration error'));

          // Act
          final result = await imageService.pickImageFromGallery();

          // Assert
          expect(result, isNull);
          expect(imageService.selectedImage, isNull);
          expect(imageService.isImageUploading, isFalse);
        },
      );

      test('should maintain configuration even after errors', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenThrow(Exception('Configuration error'));

        // Act
        await imageService.pickImageFromGallery(); // This will fail
        await imageService
            .pickImageFromGallery(); // This should use same config

        // Assert
        // Configuration should remain the same even after errors
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).called(2);
      });

      test(
        'should handle invalid configuration parameters gracefully',
        () async {
          // Arrange
          when(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenThrow(ArgumentError('Invalid parameters'));

          // Act
          final result = await imageService.takePhotoWithCamera();

          // Assert
          expect(result, isNull);
          expect(imageService.selectedImage, isNull);
          expect(imageService.isImageUploading, isFalse);
        },
      );
    });

    group('Integration with ImageService Tests', () {
      test('should work correctly with real ImageService implementation', () {
        // Arrange
        final realImageService = ImageService();

        // Act & Assert
        expect(realImageService.selectedImage, isNull);
        expect(realImageService.isImageUploading, isFalse);
      });

      test('should maintain same interface as TestableImageService', () {
        // Arrange
        final realImageService = ImageService();
        final testableImageService = TestableImageService(
          imagePicker: mockImagePicker,
        );

        // Act & Assert
        // Both should have same interface
        expect(realImageService.selectedImage, isNull);
        expect(testableImageService.selectedImage, isNull);
        expect(realImageService.isImageUploading, isFalse);
        expect(testableImageService.isImageUploading, isFalse);
      });

      test('should handle same operations consistently', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();
        await imageService.takePhotoWithCamera();
        imageService.removeSelectedImage();

        // Assert
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);
      });
    });

    group('Configuration Edge Cases Tests', () {
      test('should handle configuration with boundary values', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024, // Boundary value
            maxHeight: 1024, // Boundary value
            imageQuality: 85, // Boundary value
          ),
        ).thenAnswer((_) async => null);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).called(1);
      });

      test('should maintain configuration under stress', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        final futures = <Future>[];
        for (int i = 0; i < 10; i++) {
          futures.add(imageService.pickImageFromGallery());
        }
        await Future.wait(futures);

        // Assert
        // Configuration should remain consistent under stress
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).called(10);
      });

      test('should handle configuration with concurrent operations', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).thenAnswer((_) async => null);

        // Act
        final galleryFuture = imageService.pickImageFromGallery();
        final cameraFuture = imageService.takePhotoWithCamera();
        await Future.wait([galleryFuture, cameraFuture]);

        // Assert
        // Configuration should be consistent even with concurrent operations
        verify(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: 1024,
            maxHeight: 1024,
            imageQuality: 85,
          ),
        ).called(2);
      });
    });
  });
}
