import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class IImageService {
  Future<File?> pickImageFromGallery();
  Future<File?> takePhotoWithCamera();
  void removeSelectedImage();
  File? get selectedImage;
  bool get isImageUploading;
}

class ImageService implements IImageService {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isImageUploading = false;

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
