import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:arya/product/utility/storage/app_prefs.dart';
import 'dart:io';
import '../model/product_model.dart';
import '../service/product_repository.dart';
import '../service/image_service.dart';
import 'mixins/form_state_mixin.dart';
import 'mixins/form_controllers_mixin.dart';

class AddProductViewModel extends ChangeNotifier
    with FormStateMixin, FormControllersMixin {
  final IProductRepository _productRepository;
  final IImageService _imageService;

  AddProductViewModel({
    IProductRepository? productRepository,
    IImageService? imageService,
  }) : _productRepository = productRepository ?? ProductRepository(),
       _imageService = imageService ?? ImageService();

  // Image management getters
  File? get selectedImage => _imageService.selectedImage;
  bool get isImageUploading => _imageService.isImageUploading;

  // Image management methods
  Future<void> pickImageFromGallery() async {
    await _imageService.pickImageFromGallery();
    notifyListeners();
  }

  Future<void> takePhotoWithCamera() async {
    await _imageService.takePhotoWithCamera();
    notifyListeners();
  }

  void removeSelectedImage() {
    _imageService.removeSelectedImage();
    notifyListeners();
  }

  // Form validation
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Custom validation
    if (ProductModel.validateBarcode(barcodeController.text) != null ||
        ProductModel.validateName(nameController.text) != null ||
        ProductModel.validateBrands(brandsController.text) != null ||
        ProductModel.validateCategories(categoriesController.text) != null ||
        ProductModel.validateQuantity(quantityController.text) != null ||
        ProductModel.validateIngredients(ingredientsController.text) != null) {
      return false;
    }

    return true;
  }

  // Main business logic
  Future<void> addProduct() async {
    if (!validateForm()) {
      setError('Lütfen tüm gerekli alanları doldurun.');
      return;
    }

    setLoading(true);

    try {
      // 1) Firebase oturumu kontrol et
      final firebaseUser = fb.FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        setError('Lütfen önce giriş yapın.');
        return;
      }

      // 2) OFF kimlik bilgilerini al
      final offUsername = await AppPrefs.getOffUsername();
      final offPassword = await AppPrefs.getOffPassword();

      if (offUsername == null ||
          offPassword == null ||
          offUsername.isEmpty ||
          offPassword.isEmpty) {
        setError(
          'Open Food Facts kullanıcı adı/şifresi bulunamadı. Lütfen ayarlardan ekleyin.',
        );
        return;
      }

      // 3) Product model oluştur
      final product = ProductModel.fromForm(
        barcode: barcodeController.text,
        name: nameController.text,
        brands: brandsController.text,
        categories: categoriesController.text,
        quantity: quantityController.text,
        energy: energyController.text,
        fat: fatController.text,
        carbs: carbsController.text,
        protein: proteinController.text,
        ingredients: ingredientsController.text,
        sodium: sodiumController.text,
        fiber: fiberController.text,
        sugar: sugarController.text,
        allergens: allergensController.text,
        description: descriptionController.text,
        tags: tagsController.text,
      );

      // 4) Repository üzerinden ürünü kaydet (varsa resimle birlikte)
      final result = await _productRepository.saveProduct(
        product,
        offUsername,
        offPassword,
        imageFile: selectedImage,
      );

      if (result.status == 1) {
        setSuccess("Ürün başarıyla eklendi!");
        _resetForm();
      } else {
        setError("Ürün eklenemedi: ${result.statusVerbose ?? result.status}");
      }
    } catch (e) {
      setError("Hata oluştu: $e");
    }
  }

  void _resetForm() {
    clearForm();
    removeSelectedImage();
    clearMessages();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
