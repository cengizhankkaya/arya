import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';

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
    if (AddProductModel.validateBarcode(barcodeController.text) != null ||
        AddProductModel.validateName(nameController.text) != null ||
        AddProductModel.validateBrands(brandsController.text) != null ||
        AddProductModel.validateCategories(categoriesController.text) != null ||
        AddProductModel.validateQuantity(quantityController.text) != null ||
        AddProductModel.validateIngredients(ingredientsController.text) !=
            null) {
      return false;
    }

    return true;
  }

  // Main business logic
  Future<void> addProduct() async {
    if (!validateForm()) {
      setError('add_product.validation.fill_required_fields'.tr());
      return;
    }

    setLoading(true);

    try {
      // 1) Firebase oturumu kontrol et
      final firebaseUser = fb.FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        setError('add_product.validation.login_first'.tr());
        return;
      }

      // 2) OFF kimlik bilgilerini al
      final offUsername = await AppPrefs.getOffUsername();
      final offPassword = await AppPrefs.getOffPassword();

      if (offUsername == null ||
          offPassword == null ||
          offUsername.isEmpty ||
          offPassword.isEmpty) {
        setError('add_product.validation.off_credentials_not_found'.tr());
        return;
      }

      // 3) Product model oluştur
      final product = AddProductModel.fromForm(
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
        setSuccess("add_product.validation.product_added_success".tr());
        _resetForm();
      } else {
        setError(
          "add_product.validation.product_add_failed".tr(
            args: [result.statusVerbose ?? result.status.toString()],
          ),
        );
      }
    } catch (e) {
      setError(
        "add_product.validation.error_occurred".tr(args: [e.toString()]),
      );
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
