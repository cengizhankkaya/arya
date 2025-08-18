import 'package:flutter/material.dart';

mixin FormControllersMixin on ChangeNotifier {
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController brandsController = TextEditingController();
  final TextEditingController categoriesController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController energyController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController sodiumController = TextEditingController();
  final TextEditingController fiberController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();
  final TextEditingController allergensController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  void clearForm() {
    barcodeController.clear();
    nameController.clear();
    brandsController.clear();
    categoriesController.clear();
    quantityController.clear();
    energyController.clear();
    fatController.clear();
    carbsController.clear();
    proteinController.clear();
    ingredientsController.clear();
    sodiumController.clear();
    fiberController.clear();
    sugarController.clear();
    allergensController.clear();
    descriptionController.clear();
    tagsController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    nameController.dispose();
    brandsController.dispose();
    categoriesController.dispose();
    quantityController.dispose();
    energyController.dispose();
    fatController.dispose();
    carbsController.dispose();
    proteinController.dispose();
    ingredientsController.dispose();
    sodiumController.dispose();
    fiberController.dispose();
    sugarController.dispose();
    allergensController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    super.dispose();
  }
}
