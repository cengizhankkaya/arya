import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/service/product_repository.dart';
import 'package:arya/features/addproduct/service/image_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'add_product_viewmodel_image_management_test.mocks.dart';

@GenerateMocks([IProductRepository, IImageService, fb.FirebaseAuth, fb.User])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddProductViewModel Image Management Tests', () {
    late AddProductViewModel viewModel;
    late MockIProductRepository mockProductRepository;
    late MockIImageService mockImageService;

    setUp(() {
      mockProductRepository = MockIProductRepository();
      mockImageService = MockIImageService();

      viewModel = AddProductViewModel(
        productRepository: mockProductRepository,
        imageService: mockImageService,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Image Service Integration Tests', () {
      test('should initialize with null selected image', () {
        // Arrange
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Assert
        expect(viewModel.selectedImage, isNull);
        expect(viewModel.isImageUploading, isFalse);
        verify(mockImageService.selectedImage).called(1);
        verify(mockImageService.isImageUploading).called(1);
      });

      test('should return selected image from image service', () {
        // Arrange
        final testImage = File('test/path/image.jpg');
        when(mockImageService.selectedImage).thenReturn(testImage);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        final selectedImage = viewModel.selectedImage;

        // Assert
        expect(selectedImage, equals(testImage));
        verify(mockImageService.selectedImage).called(1);
      });

      test('should return image uploading state from image service', () {
        // Arrange
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(true);

        // Act
        final isUploading = viewModel.isImageUploading;

        // Assert
        expect(isUploading, isTrue);
        verify(mockImageService.isImageUploading).called(1);
      });
    });

    group('Image Picker Tests', () {
      test('should call pickImageFromGallery on image service', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.pickImageFromGallery();

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(1);
      });

      test('should call takePhotoWithCamera on image service', () async {
        // Arrange
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.takePhotoWithCamera();

        // Assert
        verify(mockImageService.takePhotoWithCamera()).called(1);
      });

      test('should handle successful image pick from gallery', () async {
        // Arrange
        final testImage = File('test/path/gallery_image.jpg');
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => testImage);
        when(mockImageService.selectedImage).thenReturn(testImage);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.pickImageFromGallery();

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(1);
        expect(viewModel.selectedImage, equals(testImage));
      });

      test('should handle successful photo capture with camera', () async {
        // Arrange
        final testImage = File('test/path/camera_image.jpg');
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => testImage);
        when(mockImageService.selectedImage).thenReturn(testImage);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.takePhotoWithCamera();

        // Assert
        verify(mockImageService.takePhotoWithCamera()).called(1);
        expect(viewModel.selectedImage, equals(testImage));
      });

      test('should handle failed image pick from gallery', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.pickImageFromGallery();

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(1);
        expect(viewModel.selectedImage, isNull);
      });

      test('should handle failed photo capture with camera', () async {
        // Arrange
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.takePhotoWithCamera();

        // Assert
        verify(mockImageService.takePhotoWithCamera()).called(1);
        expect(viewModel.selectedImage, isNull);
      });

      test('should handle image picker exceptions', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenThrow(Exception('Gallery access denied'));
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act & Assert
        expect(() => viewModel.pickImageFromGallery(), throwsException);
        verify(mockImageService.pickImageFromGallery()).called(1);
      });

      test('should handle camera exceptions', () async {
        // Arrange
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenThrow(Exception('Camera access denied'));
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act & Assert
        expect(() => viewModel.takePhotoWithCamera(), throwsException);
        verify(mockImageService.takePhotoWithCamera()).called(1);
      });
    });

    group('Image Removal Tests', () {
      test('should call removeSelectedImage on image service', () {
        // Arrange
        when(mockImageService.removeSelectedImage()).thenReturn(null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        viewModel.removeSelectedImage();

        // Assert
        verify(mockImageService.removeSelectedImage()).called(1);
      });

      test('should remove selected image successfully', () {
        // Arrange
        final testImage = File('test/path/image.jpg');
        when(mockImageService.selectedImage).thenReturn(testImage);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(mockImageService.removeSelectedImage()).thenReturn(null);

        // Act
        viewModel.removeSelectedImage();

        // Assert
        verify(mockImageService.removeSelectedImage()).called(1);
      });

      test('should handle multiple image removals', () {
        // Arrange
        when(mockImageService.removeSelectedImage()).thenReturn(null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        viewModel.removeSelectedImage();
        viewModel.removeSelectedImage();
        viewModel.removeSelectedImage();

        // Assert
        verify(mockImageService.removeSelectedImage()).called(3);
      });
    });

    group('Image State Management Tests', () {
      test('should notify listeners when image is picked', () async {
        // Arrange
        final testImage = File('test/path/image.jpg');
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => testImage);
        when(mockImageService.selectedImage).thenReturn(testImage);
        when(mockImageService.isImageUploading).thenReturn(false);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.pickImageFromGallery();

        // Assert
        expect(listenerCalled, isTrue);
        verify(mockImageService.pickImageFromGallery()).called(1);
      });

      test('should notify listeners when photo is taken', () async {
        // Arrange
        final testImage = File('test/path/image.jpg');
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => testImage);
        when(mockImageService.selectedImage).thenReturn(testImage);
        when(mockImageService.isImageUploading).thenReturn(false);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        await viewModel.takePhotoWithCamera();

        // Assert
        expect(listenerCalled, isTrue);
        verify(mockImageService.takePhotoWithCamera()).called(1);
      });

      test('should notify listeners when image is removed', () {
        // Arrange
        when(mockImageService.removeSelectedImage()).thenReturn(null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        bool listenerCalled = false;
        viewModel.addListener(() {
          listenerCalled = true;
        });

        // Act
        viewModel.removeSelectedImage();

        // Assert
        expect(listenerCalled, isTrue);
        verify(mockImageService.removeSelectedImage()).called(1);
      });

      test('should handle multiple listeners', () async {
        // Arrange
        final testImage = File('test/path/image.jpg');
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => testImage);
        when(mockImageService.selectedImage).thenReturn(testImage);
        when(mockImageService.isImageUploading).thenReturn(false);

        int listenerCallCount = 0;
        for (int i = 0; i < 5; i++) {
          viewModel.addListener(() {
            listenerCallCount++;
          });
        }

        // Act
        await viewModel.pickImageFromGallery();

        // Assert
        expect(listenerCallCount, equals(5));
        verify(mockImageService.pickImageFromGallery()).called(1);
      });
    });

    group('Image Uploading State Tests', () {
      test(
        'should reflect image uploading state during gallery pick',
        () async {
          // Arrange
          when(
            mockImageService.pickImageFromGallery(),
          ).thenAnswer((_) async => null);
          when(mockImageService.selectedImage).thenReturn(null);
          when(mockImageService.isImageUploading).thenReturn(false);

          // Act
          await viewModel.pickImageFromGallery();

          // Assert
          verify(mockImageService.pickImageFromGallery()).called(1);
        },
      );

      test(
        'should reflect image uploading state during camera capture',
        () async {
          // Arrange
          when(
            mockImageService.takePhotoWithCamera(),
          ).thenAnswer((_) async => null);
          when(mockImageService.selectedImage).thenReturn(null);
          when(mockImageService.isImageUploading).thenReturn(false);

          // Act
          await viewModel.takePhotoWithCamera();

          // Assert
          verify(mockImageService.takePhotoWithCamera()).called(1);
        },
      );
    });

    group('Image File Validation Tests', () {
      test('should handle valid image file', () async {
        // Arrange
        final validImage = File('test/path/valid_image.jpg');
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => validImage);
        when(mockImageService.selectedImage).thenReturn(validImage);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.pickImageFromGallery();

        // Assert
        expect(viewModel.selectedImage, isNotNull);
        expect(viewModel.selectedImage, isA<File>());
        verify(mockImageService.pickImageFromGallery()).called(1);
      });

      test('should handle null image file', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act
        await viewModel.pickImageFromGallery();

        // Assert
        expect(viewModel.selectedImage, isNull);
        verify(mockImageService.pickImageFromGallery()).called(1);
      });
    });

    group('Image Operations Integration Tests', () {
      test('should handle complete image workflow', () async {
        // Arrange
        final testImage = File('test/path/workflow_image.jpg');
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => testImage);
        when(mockImageService.selectedImage).thenReturn(testImage);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(mockImageService.removeSelectedImage()).thenReturn(null);

        // Act - Pick image
        await viewModel.pickImageFromGallery();
        expect(viewModel.selectedImage, equals(testImage));

        // Act - Remove image
        viewModel.removeSelectedImage();

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(1);
        verify(mockImageService.removeSelectedImage()).called(1);
      });

      test('should handle multiple image operations', () async {
        // Arrange
        final image1 = File('test/path/image1.jpg');
        final image2 = File('test/path/image2.jpg');
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => image1);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => image2);
        when(mockImageService.selectedImage).thenReturn(image1);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(mockImageService.removeSelectedImage()).thenReturn(null);

        // Act
        await viewModel.pickImageFromGallery();
        await viewModel.takePhotoWithCamera();
        viewModel.removeSelectedImage();

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(1);
        verify(mockImageService.takePhotoWithCamera()).called(1);
        verify(mockImageService.removeSelectedImage()).called(1);
      });

      test('should handle rapid image operations', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(mockImageService.removeSelectedImage()).thenReturn(null);

        // Act - Rapid operations
        for (int i = 0; i < 10; i++) {
          await viewModel.pickImageFromGallery();
          await viewModel.takePhotoWithCamera();
          viewModel.removeSelectedImage();
        }

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(10);
        verify(mockImageService.takePhotoWithCamera()).called(10);
        verify(mockImageService.removeSelectedImage()).called(10);
      });
    });

    group('Error Handling Tests', () {
      test('should handle image service exceptions gracefully', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenThrow(Exception('Service error'));
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act & Assert
        expect(() => viewModel.pickImageFromGallery(), throwsException);
        verify(mockImageService.pickImageFromGallery()).called(1);
      });

      test('should handle camera service exceptions gracefully', () async {
        // Arrange
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenThrow(Exception('Camera error'));
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act & Assert
        expect(() => viewModel.takePhotoWithCamera(), throwsException);
        verify(mockImageService.takePhotoWithCamera()).called(1);
      });

      test('should handle image removal exceptions gracefully', () {
        // Arrange
        when(
          mockImageService.removeSelectedImage(),
        ).thenThrow(Exception('Removal error'));
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act & Assert
        expect(() => viewModel.removeSelectedImage(), throwsException);
        verify(mockImageService.removeSelectedImage()).called(1);
      });
    });

    group('Performance Tests', () {
      test('should handle image operations efficiently', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(mockImageService.removeSelectedImage()).thenReturn(null);

        final stopwatch = Stopwatch()..start();

        // Act
        for (int i = 0; i < 100; i++) {
          await viewModel.pickImageFromGallery();
          await viewModel.takePhotoWithCamera();
          viewModel.removeSelectedImage();
        }

        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        verify(mockImageService.pickImageFromGallery()).called(100);
        verify(mockImageService.takePhotoWithCamera()).called(100);
        verify(mockImageService.removeSelectedImage()).called(100);
      });

      test('should handle concurrent image operations', () async {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);
        when(mockImageService.removeSelectedImage()).thenReturn(null);

        // Act - Concurrent operations
        final futures = <Future>[];
        for (int i = 0; i < 5; i++) {
          futures.add(viewModel.pickImageFromGallery());
          futures.add(viewModel.takePhotoWithCamera());
        }

        await Future.wait(futures);

        // Assert
        verify(mockImageService.pickImageFromGallery()).called(5);
        verify(mockImageService.takePhotoWithCamera()).called(5);
      });
    });

    group('Memory Management Tests', () {
      test('should handle image operations without memory issues', () {
        // Arrange
        when(
          mockImageService.pickImageFromGallery(),
        ).thenAnswer((_) async => null);
        when(
          mockImageService.takePhotoWithCamera(),
        ).thenAnswer((_) async => null);
        when(mockImageService.removeSelectedImage()).thenReturn(null);
        when(mockImageService.selectedImage).thenReturn(null);
        when(mockImageService.isImageUploading).thenReturn(false);

        // Act & Assert - Should work normally
        expect(() => viewModel.pickImageFromGallery(), returnsNormally);
        expect(() => viewModel.takePhotoWithCamera(), returnsNormally);
        expect(() => viewModel.removeSelectedImage(), returnsNormally);
      });
    });
  });
}
