import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:image_picker/image_picker.dart';
import 'testable_image_service.dart';

import 'image_service_mock_test.mocks.dart';

// Mock'ları generate et
@GenerateMocks([ImagePicker, XFile])
void main() {
  group('TestableImageService Mock Tests', () {
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

    group('Initial State Tests', () {
      test('should have no selected image initially', () {
        // Act & Assert
        expect(imageService.selectedImage, isNull);
      });

      test('should not be uploading initially', () {
        // Act & Assert
        expect(imageService.isImageUploading, isFalse);
      });
    });

    group('Gallery Image Picker Tests', () {
      test(
        'should return selected image when gallery picker succeeds',
        () async {
          // Arrange
          const imagePath = '/tmp/test_image.jpg';
          when(mockXFile.path).thenReturn(imagePath);
          when(
            mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenAnswer((_) async => mockXFile);

          // Act
          final result = await imageService.pickImageFromGallery();

          // Assert
          expect(result, isNotNull);
          expect(result?.path, equals(imagePath));
          expect(imageService.selectedImage, isNotNull);
          expect(imageService.selectedImage?.path, equals(imagePath));
          expect(imageService.isImageUploading, isFalse);

          // Verify mock interactions
          verify(
            mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).called(1);
          verify(mockXFile.path).called(1);
        },
      );

      test('should return null when gallery picker returns null', () async {
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
        final result = await imageService.pickImageFromGallery();

        // Assert
        expect(result, isNull);
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);

        // Verify mock interactions
        verify(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test('should handle gallery picker exceptions gracefully', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenThrow(Exception('Gallery picker failed'));

        // Act
        final result = await imageService.pickImageFromGallery();

        // Assert
        expect(result, isNull);
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);

        // Verify mock interactions
        verify(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test(
        'should set uploading state correctly during gallery picker',
        () async {
          // Arrange
          const imagePath = '/tmp/test_image.jpg';
          when(mockXFile.path).thenReturn(imagePath);
          when(
            mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenAnswer((_) async {
            // Simulate delay to test uploading state
            await Future.delayed(const Duration(milliseconds: 100));
            return mockXFile;
          });

          // Act
          final future = imageService.pickImageFromGallery();

          // Assert - should be uploading initially
          expect(imageService.isImageUploading, isTrue);

          final result = await future;

          // Assert - should not be uploading after completion
          expect(result, isNotNull);
          expect(imageService.isImageUploading, isFalse);
        },
      );
    });

    group('Camera Photo Capture Tests', () {
      test(
        'should return selected image when camera capture succeeds',
        () async {
          // Arrange
          const imagePath = '/tmp/camera_photo.jpg';
          when(mockXFile.path).thenReturn(imagePath);
          when(
            mockImagePicker.pickImage(
              source: ImageSource.camera,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenAnswer((_) async => mockXFile);

          // Act
          final result = await imageService.takePhotoWithCamera();

          // Assert
          expect(result, isNotNull);
          expect(result?.path, equals(imagePath));
          expect(imageService.selectedImage, isNotNull);
          expect(imageService.selectedImage?.path, equals(imagePath));
          expect(imageService.isImageUploading, isFalse);

          // Verify mock interactions
          verify(
            mockImagePicker.pickImage(
              source: ImageSource.camera,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).called(1);
          verify(mockXFile.path).called(1);
        },
      );

      test('should return null when camera capture returns null', () async {
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
        final result = await imageService.takePhotoWithCamera();

        // Assert
        expect(result, isNull);
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);

        // Verify mock interactions
        verify(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test('should handle camera capture exceptions gracefully', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenThrow(Exception('Camera capture failed'));

        // Act
        final result = await imageService.takePhotoWithCamera();

        // Assert
        expect(result, isNull);
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);

        // Verify mock interactions
        verify(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).called(1);
      });

      test(
        'should set uploading state correctly during camera capture',
        () async {
          // Arrange
          const imagePath = '/tmp/camera_photo.jpg';
          when(mockXFile.path).thenReturn(imagePath);
          when(
            mockImagePicker.pickImage(
              source: ImageSource.camera,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenAnswer((_) async {
            // Simulate delay to test uploading state
            await Future.delayed(const Duration(milliseconds: 100));
            return mockXFile;
          });

          // Act
          final future = imageService.takePhotoWithCamera();

          // Assert - should be uploading initially
          expect(imageService.isImageUploading, isTrue);

          final result = await future;

          // Assert - should not be uploading after completion
          expect(result, isNotNull);
          expect(imageService.isImageUploading, isFalse);
        },
      );
    });

    group('Image Removal Tests', () {
      test('should remove selected image successfully', () async {
        // Arrange
        const imagePath = '/tmp/test_image.jpg';
        when(mockXFile.path).thenReturn(imagePath);
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => mockXFile);

        // First select an image
        await imageService.pickImageFromGallery();
        expect(imageService.selectedImage, isNotNull);

        // Act
        imageService.removeSelectedImage();

        // Assert
        expect(imageService.selectedImage, isNull);
      });

      test('should handle removal when no image is selected', () {
        // Arrange
        // No image selected initially

        // Act
        imageService.removeSelectedImage();

        // Assert
        expect(imageService.selectedImage, isNull);
      });

      test('should handle multiple removal calls', () async {
        // Arrange
        const imagePath = '/tmp/test_image.jpg';
        when(mockXFile.path).thenReturn(imagePath);
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => mockXFile);

        // First select an image
        await imageService.pickImageFromGallery();

        // Act
        imageService.removeSelectedImage();
        imageService.removeSelectedImage();
        imageService.removeSelectedImage();

        // Assert
        expect(imageService.selectedImage, isNull);
      });
    });

    group('State Management Tests', () {
      test(
        'should maintain consistent state during image operations',
        () async {
          // Arrange
          const imagePath = '/tmp/test_image.jpg';
          when(mockXFile.path).thenReturn(imagePath);
          when(
            mockImagePicker.pickImage(
              source: anyNamed('source'),
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenAnswer((_) async => mockXFile);

          // Act & Assert
          expect(imageService.selectedImage, isNull);
          expect(imageService.isImageUploading, isFalse);

          // Gallery picker
          await imageService.pickImageFromGallery();
          expect(imageService.selectedImage, isNotNull);
          expect(imageService.isImageUploading, isFalse);

          // Camera capture
          await imageService.takePhotoWithCamera();
          expect(imageService.selectedImage, isNotNull);
          expect(imageService.isImageUploading, isFalse);

          // Remove
          imageService.removeSelectedImage();
          expect(imageService.selectedImage, isNull);
          expect(imageService.isImageUploading, isFalse);
        },
      );

      test('should handle rapid successive operations', () async {
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
        final futures = [
          imageService.pickImageFromGallery(),
          imageService.takePhotoWithCamera(),
          imageService.pickImageFromGallery(),
          imageService.takePhotoWithCamera(),
        ];

        await Future.wait(futures);

        // Assert
        expect(imageService.isImageUploading, isFalse);
        expect(imageService.selectedImage, isNull);
      });

      test('should handle mixed operations sequence', () async {
        // Arrange
        const imagePath = '/tmp/test_image.jpg';
        when(mockXFile.path).thenReturn(imagePath);
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => mockXFile);

        // Act
        await imageService.pickImageFromGallery();
        expect(imageService.selectedImage, isNotNull);

        imageService.removeSelectedImage();
        expect(imageService.selectedImage, isNull);

        await imageService.takePhotoWithCamera();
        expect(imageService.selectedImage, isNotNull);

        imageService.removeSelectedImage();
        expect(imageService.selectedImage, isNull);

        await imageService.pickImageFromGallery();
        expect(imageService.selectedImage, isNotNull);

        // Assert
        expect(imageService.isImageUploading, isFalse);
      });
    });

    group('Error Handling Tests', () {
      test('should handle ImagePicker exceptions in gallery picker', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenThrow(Exception('Gallery picker failed'));

        // Act
        final result = await imageService.pickImageFromGallery();

        // Assert
        expect(result, isNull);
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);
      });

      test('should handle ImagePicker exceptions in camera capture', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.camera,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenThrow(Exception('Camera capture failed'));

        // Act
        final result = await imageService.takePhotoWithCamera();

        // Assert
        expect(result, isNull);
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);
      });

      test('should handle different types of exceptions', () async {
        // Arrange
        final exceptions = [
          Exception('Generic exception'),
          ArgumentError('Invalid argument'),
          StateError('Invalid state'),
          FormatException('Format error'),
        ];

        for (final exception in exceptions) {
          when(
            mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenThrow(exception);

          // Act
          final result = await imageService.pickImageFromGallery();

          // Assert
          expect(result, isNull);
          expect(imageService.selectedImage, isNull);
          expect(imageService.isImageUploading, isFalse);

          // Reset mock for next iteration
          reset(mockImagePicker);
        }
      });

      test('should handle timeout exceptions', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenThrow(Exception('Timeout'));

        // Act
        final result = await imageService.pickImageFromGallery();

        // Assert
        expect(result, isNull);
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);
      });

      test('should handle permission denied exceptions', () async {
        // Arrange
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenThrow(Exception('Permission denied'));

        // Act
        final result = await imageService.pickImageFromGallery();

        // Assert
        expect(result, isNull);
        expect(imageService.selectedImage, isNull);
        expect(imageService.isImageUploading, isFalse);
      });
    });

    group('Concurrent Operations Tests', () {
      test('should handle concurrent gallery and camera operations', () async {
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
        final galleryFuture = imageService.pickImageFromGallery();
        final cameraFuture = imageService.takePhotoWithCamera();

        await Future.wait([galleryFuture, cameraFuture]);

        // Assert
        expect(imageService.isImageUploading, isFalse);
      });

      test('should handle concurrent operations with removal', () async {
        // Arrange
        const imagePath = '/tmp/test_image.jpg';
        when(mockXFile.path).thenReturn(imagePath);
        when(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => mockXFile);

        // Act
        final galleryFuture = imageService.pickImageFromGallery();
        imageService.removeSelectedImage();
        final cameraFuture = imageService.takePhotoWithCamera();

        await Future.wait([galleryFuture, cameraFuture]);

        // Assert
        expect(imageService.isImageUploading, isFalse);
      });

      test('should handle rapid state changes', () async {
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
        for (int i = 0; i < 10; i++) {
          await imageService.pickImageFromGallery();
          imageService.removeSelectedImage();
          await imageService.takePhotoWithCamera();
          imageService.removeSelectedImage();
        }

        // Assert
        expect(imageService.isImageUploading, isFalse);
        expect(imageService.selectedImage, isNull);
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty image path gracefully', () async {
        // Arrange
        when(mockXFile.path).thenReturn('');
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => mockXFile);

        // Act
        final result = await imageService.pickImageFromGallery();

        // Assert
        expect(result, isNotNull);
        expect(result?.path, equals(''));
        expect(imageService.selectedImage?.path, equals(''));
        expect(imageService.isImageUploading, isFalse);
      });

      test('should handle empty image path gracefully', () async {
        // Arrange
        when(mockXFile.path).thenReturn('');
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => mockXFile);

        // Act
        final result = await imageService.pickImageFromGallery();

        // Assert
        expect(result, isNotNull);
        expect(result?.path, equals(''));
        expect(imageService.selectedImage?.path, equals(''));
        expect(imageService.isImageUploading, isFalse);
      });

      test('should handle very long image path gracefully', () async {
        // Arrange
        final longPath = 'A' * 1000;
        when(mockXFile.path).thenReturn(longPath);
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => mockXFile);

        // Act
        final result = await imageService.pickImageFromGallery();

        // Assert
        expect(result, isNotNull);
        expect(result?.path, equals(longPath));
        expect(imageService.selectedImage?.path, equals(longPath));
        expect(imageService.isImageUploading, isFalse);
      });

      test(
        'should handle special characters in image path gracefully',
        () async {
          // Arrange
          const specialPath =
              '/tmp/test_image_with_special_chars_!@#\$%^&*().jpg';
          when(mockXFile.path).thenReturn(specialPath);
          when(
            mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenAnswer((_) async => mockXFile);

          // Act
          final result = await imageService.pickImageFromGallery();

          // Assert
          expect(result, isNotNull);
          expect(result?.path, equals(specialPath));
          expect(imageService.selectedImage?.path, equals(specialPath));
          expect(imageService.isImageUploading, isFalse);
        },
      );

      test(
        'should handle unicode characters in image path gracefully',
        () async {
          // Arrange
          const unicodePath = '/tmp/test_image_with_unicode_🎉.jpg';
          when(mockXFile.path).thenReturn(unicodePath);
          when(
            mockImagePicker.pickImage(
              source: ImageSource.gallery,
              maxWidth: anyNamed('maxWidth'),
              maxHeight: anyNamed('maxHeight'),
              imageQuality: anyNamed('imageQuality'),
            ),
          ).thenAnswer((_) async => mockXFile);

          // Act
          final result = await imageService.pickImageFromGallery();

          // Assert
          expect(result, isNotNull);
          expect(result?.path, equals(unicodePath));
          expect(imageService.selectedImage?.path, equals(unicodePath));
          expect(imageService.isImageUploading, isFalse);
        },
      );
    });

    group('Memory Management Tests', () {
      test('should not leak memory during operations', () async {
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
        for (int i = 0; i < 100; i++) {
          await imageService.pickImageFromGallery();
          imageService.removeSelectedImage();
          await imageService.takePhotoWithCamera();
          imageService.removeSelectedImage();
        }

        // Assert
        expect(imageService.isImageUploading, isFalse);
        expect(imageService.selectedImage, isNull);
      });

      test('should handle large number of operations', () async {
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
        final futures = <Future>[];
        for (int i = 0; i < 50; i++) {
          futures.add(imageService.pickImageFromGallery());
          futures.add(imageService.takePhotoWithCamera());
        }

        await Future.wait(futures);

        // Assert
        expect(imageService.isImageUploading, isFalse);
      });
    });

    group('Mock Verification Tests', () {
      test(
        'should call ImagePicker with correct parameters for gallery',
        () async {
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
        },
      );

      test(
        'should call ImagePicker with correct parameters for camera',
        () async {
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
        },
      );

      test('should not call ImagePicker when removing image', () {
        // Act
        imageService.removeSelectedImage();

        // Assert
        verifyNever(
          mockImagePicker.pickImage(
            source: anyNamed('source'),
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        );
      });

      test('should call XFile.path when image is selected', () async {
        // Arrange
        const imagePath = '/tmp/test_image.jpg';
        when(mockXFile.path).thenReturn(imagePath);
        when(
          mockImagePicker.pickImage(
            source: ImageSource.gallery,
            maxWidth: anyNamed('maxWidth'),
            maxHeight: anyNamed('maxHeight'),
            imageQuality: anyNamed('imageQuality'),
          ),
        ).thenAnswer((_) async => mockXFile);

        // Act
        await imageService.pickImageFromGallery();

        // Assert
        verify(mockXFile.path).called(1);
      });
    });
  });
}
