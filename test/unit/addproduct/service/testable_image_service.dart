import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:arya/features/addproduct/service/image_service.dart';

/// Testable version of ImageService that allows dependency injection
class TestableImageService implements IImageService {
  final ImagePicker _imagePicker;
  File? _selectedImage;
  bool _isImageUploading = false;

  TestableImageService({required ImagePicker imagePicker})
    : _imagePicker = imagePicker;

  @override
  File? get selectedImage => _selectedImage;

  @override
  bool get isImageUploading => _isImageUploading;

  @override
  Future<File?> pickImageFromGallery() async {
    try {
      _setImageUploading(true);
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        return _selectedImage;
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setImageUploading(false);
    }
  }

  @override
  Future<File?> takePhotoWithCamera() async {
    try {
      _setImageUploading(true);
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        return _selectedImage;
      }
      return null;
    } catch (e) {
      return null;
    } finally {
      _setImageUploading(false);
    }
  }

  @override
  void removeSelectedImage() {
    _selectedImage = null;
  }

  void _setImageUploading(bool value) {
    _isImageUploading = value;
  }
}
