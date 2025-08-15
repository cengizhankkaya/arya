import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:arya/product/utility/storage/app_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddProductViewModel extends ChangeNotifier {
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
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController sodiumController = TextEditingController();
  final TextEditingController fiberController = TextEditingController();
  final TextEditingController sugarController = TextEditingController();
  final TextEditingController allergensController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();

  // Image picker
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isImageUploading = false;

  // State
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  File? get selectedImage => _selectedImage;
  bool get isImageUploading => _isImageUploading;

  // Resim seçme metodları
  Future<void> pickImageFromGallery() async {
    try {
      _setImageUploading(true);
      print('DEBUG: Galeriden resim seçme başlatılıyor...');

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      print('DEBUG: Galeri hatası: $e');
      // Hata mesajını gösterme, sadece log'da tut
    } finally {
      _setImageUploading(false);
    }
  }

  Future<void> takePhotoWithCamera() async {
    try {
      _setImageUploading(true);
      print('DEBUG: Kamera ile fotoğraf çekme başlatılıyor...');

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
    } catch (e) {
      print('DEBUG: Kamera hatası: $e');
      // Hata mesajını gösterme, sadece log'da tut
    } finally {
      _setImageUploading(false);
    }
  }

  void removeSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  void _setImageUploading(bool value) {
    _isImageUploading = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    // Resim hatalarını gösterme
    if (message.contains('resim') ||
        message.contains('Resim') ||
        message.contains('kamera') ||
        message.contains('galeri')) {
      print('DEBUG: Resim hatası (gösterilmiyor): $message');
      return;
    }

    _errorMessage = message;
    _successMessage = null;
    _setLoading(false);
    notifyListeners();
  }

  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    _setLoading(false);
    notifyListeners();
  }

  // Ürün ekleme
  Future<void> addProduct() async {
    if (!formKey.currentState!.validate()) return;

    _setLoading(true);

    // 1) Firebase oturumu kontrol et
    final firebaseUser = fb.FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      _setError('Lütfen önce giriş yapın.');
      return;
    }

    // 2) OFF kimlik bilgilerini al
    final offUsername = await AppPrefs.getOffUsername();
    final offPassword = await AppPrefs.getOffPassword();

    // Debug için
    print('DEBUG: Username: $offUsername');
    print('DEBUG: Password: ${offPassword != null ? "***" : "NULL"}');

    if (offUsername == null ||
        offPassword == null ||
        offUsername.isEmpty ||
        offPassword.isEmpty) {
      _setError(
        'Open Food Facts kullanıcı adı/şifresi bulunamadı. Lütfen ayarlardan ekleyin.',
      );
      return;
    }

    try {
      // Kendi HTTP isteğimizi yaparak User-Agent header'ını set edelim
      final result = await _saveProductToOpenFoodFacts(
        offUsername,
        offPassword,
        barcodeController.text.trim(),
        nameController.text.trim(),
        brandsController.text.trim(),
        categoriesController.text.trim(),
        quantityController.text.trim(),
        ingredientsController.text.trim(),
        imageUrlController.text.trim(),
        sodiumController.text.trim(),
        fiberController.text.trim(),
        sugarController.text.trim(),
        allergensController.text.trim(),
        descriptionController.text.trim(),
        tagsController.text.trim(),
      );

      if (result.status == 1) {
        _setSuccess("Ürün başarıyla eklendi!");
        clearForm();
      } else {
        _setError("Ürün eklenemedi: ${result.statusVerbose ?? result.status}");
      }
    } catch (e) {
      _setError("Hata oluştu: $e");
    }
  }

  // Open Food Facts'e ürün kaydetme - kendi HTTP isteğimizle
  Future<off.Status> _saveProductToOpenFoodFacts(
    String username,
    String password,
    String barcode,
    String productName,
    String brands,
    String categories,
    String quantity,
    String ingredients,
    String imageUrl,
    String sodium,
    String fiber,
    String sugar,
    String allergens,
    String description,
    String tags,
  ) async {
    final uri = Uri.parse('https://world.openfoodfacts.org/cgi/product_jqm.pl');

    // Form data formatında gönder
    final body = <String, String>{
      'code': barcode,
      'product_name': productName,
      'brands': brands,
      'categories': categories,
      'quantity': quantity,
      'ingredients_text': ingredients,
      'image_url': imageUrl,
      'nutriment_sodium': sodium,
      'nutriment_fiber': fiber,
      'nutriment_sugars': sugar,
      'allergens_tags': allergens,
      'generic_name': description,
      'labels_tags': tags,
      'user_id': username,
      'password': password,
      'action': 'process',
      'json': '1',
      'type': 'product',
    };

    // User-Agent header'ını set et
    final headers = <String, String>{
      'User-Agent': 'Arya-Flutter-App/1.0 (https://github.com/your-repo)',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json, text/html, */*',
      'Accept-Language': 'en-US,en;q=0.9',
      'Origin': 'https://world.openfoodfacts.org',
      'Referer': 'https://world.openfoodfacts.org/',
    };

    try {
      // HTTP client'ı redirect'leri takip edecek şekilde ayarla
      final client = http.Client();

      final request = http.Request('POST', uri);
      request.headers.addAll(headers);
      request.bodyFields = body;

      print('DEBUG: Sending request to: $uri');
      print('DEBUG: Headers: $headers');
      print('DEBUG: Body: $body');

      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response headers: ${response.headers}');
      print('DEBUG: Response body: ${response.body}');

      // Redirect'leri handle et
      if (response.statusCode >= 300 && response.statusCode < 400) {
        final location = response.headers['location'];
        if (location != null) {
          print('DEBUG: Following redirect to: $location');

          // Redirect URL'ini parse et ve yeni request yap
          final redirectUri = Uri.parse(location);
          final redirectRequest = http.Request('POST', redirectUri);
          redirectRequest.headers.addAll(headers);
          redirectRequest.bodyFields = body;

          final redirectResponse = await client.send(redirectRequest);
          final finalResponse = await http.Response.fromStream(
            redirectResponse,
          );

          print('DEBUG: Redirect response status: ${finalResponse.statusCode}');
          print('DEBUG: Redirect response body: ${finalResponse.body}');

          // Final response'u parse et
          if (finalResponse.statusCode == 200) {
            try {
              final jsonData = finalResponse.body;
              if (jsonData.contains('"status":1')) {
                return off.Status(
                  status: 1,
                  statusVerbose: 'Product saved successfully',
                );
              } else if (jsonData.contains('"status":0')) {
                return off.Status(
                  status: 0,
                  statusVerbose: 'Product not saved',
                );
              } else {
                return off.Status(
                  status: -1,
                  statusVerbose: 'Unknown response',
                );
              }
            } catch (e) {
              return off.Status(status: -1, statusVerbose: 'Parse error: $e');
            }
          } else {
            return off.Status(
              status: -1,
              statusVerbose: 'Redirect failed: ${finalResponse.statusCode}',
            );
          }
        } else {
          return off.Status(
            status: -1,
            statusVerbose:
                'Redirect error: ${response.statusCode} - no location header',
          );
        }
      } else if (response.statusCode == 200) {
        // Normal response'u parse et
        try {
          final jsonData = response.body;
          if (jsonData.contains('"status":1')) {
            return off.Status(
              status: 1,
              statusVerbose: 'Product saved successfully',
            );
          } else if (jsonData.contains('"status":0')) {
            return off.Status(status: 0, statusVerbose: 'Product not saved');
          } else {
            return off.Status(status: -1, statusVerbose: 'Unknown response');
          }
        } catch (e) {
          return off.Status(status: -1, statusVerbose: 'Parse error: $e');
        }
      } else {
        return off.Status(
          status: -1,
          statusVerbose:
              'HTTP error: ${response.statusCode} - ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('DEBUG: Exception occurred: $e');
      return off.Status(status: -1, statusVerbose: 'Network error: $e');
    }
  }

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
    imageUrlController.clear();
    sodiumController.clear();
    fiberController.clear();
    sugarController.clear();
    allergensController.clear();
    descriptionController.clear();
    tagsController.clear();
    removeSelectedImage();
    _errorMessage = null;
    _successMessage = null;
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
    imageUrlController.dispose();
    sodiumController.dispose();
    fiberController.dispose();
    sugarController.dispose();
    allergensController.dispose();
    descriptionController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  /// Ürünü veritabanına ekler
  ///
  /// [user] - OpenFoodFacts kullanıcı bilgileri
  /// [product] - Eklenecek ürün
  /// [country] - Ülke bilgisi (opsiyonel)
  /// [language] - Dil bilgisi (opsiyonel)
  ///
  /// Dil mekaniği hakkında detaylı bilgi için:
  /// https://github.com/openfoodfacts/openfoodfacts-dart/blob/master/DOCUMENTATION.md#about-languages-mechanics
  static Future<off.Status> saveProduct(
    off.User user,
    off.Product product, {
    off.UriProductHelper uriHelper = off.uriHelperFoodProd,
    off.OpenFoodFactsCountry? country,
    off.OpenFoodFactsLanguage? language,
  }) async {
    final Map<String, String> parameterMap = <String, String>{};
    parameterMap.addAll(user.toData());
    parameterMap.addAll(product.toServerData());

    if (language != null) {
      parameterMap['lc'] = language.offTag;
    }
    if (country != null) {
      parameterMap['cc'] = country.offTag;
    }

    var productUri = uriHelper.getPostUri(path: '/cgi/product_jqm2.pl');

    if (product.nutriments != null) {
      final Map<String, String> rawNutrients = product.nutriments!.toData();
      for (final MapEntry<String, String> entry in rawNutrients.entries) {
        String key = 'nutriment_${entry.key}';
        for (final option in off.PerSize.values) {
          final int pos = key.indexOf('_${option.offTag}');
          if (pos != -1) {
            key = key.substring(0, pos);
          }
        }
        parameterMap[key] = entry.value;
      }
    }

    parameterMap.remove('nutriments');

    final response = await off.HttpHelper().doPostRequest(
      productUri,
      parameterMap,
      user,
      uriHelper: uriHelper,
      addCredentialsToBody: true,
    );

    return off.Status.fromApiResponse(response.body);
  }
}
