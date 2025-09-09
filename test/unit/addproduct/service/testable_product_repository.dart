import 'package:arya/features/index.dart';
import 'package:openfoodfacts/openfoodfacts.dart' as off;
import 'package:dio/dio.dart';
import 'dart:io';

/// Testable version of ProductRepository that allows dependency injection
class TestableProductRepository implements IProductRepository {
  static const String _baseUrl = 'https://world.openfoodfacts.org';
  static const String _endpoint = '/cgi/product_jqm.pl';

  final Dio _dio;

  TestableProductRepository({required Dio dio}) : _dio = dio;

  @override
  Future<off.Status> saveProduct(
    AddProductModel product,
    String username,
    String password, {
    File? imageFile,
  }) async {
    // Form data hazırla
    final formData = FormData.fromMap({
      ...product.toApiData(),
      'user_id': username,
      'password': password,
      'action': 'process',
      'json': '1',
      'type': 'product',
    });

    try {
      final response = await _dio.post(
        _endpoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Origin': _baseUrl,
            'Referer': '$_baseUrl/',
          },
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print(
        '[TestableProductRepository] Response status: ${response.statusCode}',
      );
      print('[TestableProductRepository] Response data: ${response.data}');

      // Redirect'leri handle et
      if (response.statusCode != null &&
          response.statusCode! >= 300 &&
          response.statusCode! < 400) {
        final status = await _handleRedirect(response);
        print(
          '[TestableProductRepository] Redirect - Product save status: ${status.status}',
        );
        print(
          '[TestableProductRepository] Redirect - Image file provided: ${imageFile != null}',
        );

        if (status.status == 1 && imageFile != null) {
          print(
            '[TestableProductRepository] Starting image upload process (redirect)...',
          );
          try {
            await _uploadProductImage(
              barcode: product.barcode,
              username: username,
              password: password,
              imageFile: imageFile,
            );
            print(
              '[TestableProductRepository] Product and image saved successfully (redirect)',
            );
          } catch (e) {
            print(
              '[TestableProductRepository] Product saved but image upload failed (redirect): $e',
            );
            // Ürün kaydedildi ama resim yüklenemedi - kullanıcıya bilgi ver
            return off.Status(
              status: 1,
              statusVerbose: 'Product saved but image upload failed: $e',
            );
          }
        } else if (status.status == 1 && imageFile == null) {
          print(
            '[TestableProductRepository] Product saved successfully (redirect), no image to upload',
          );
        }
        return status;
      } else if (response.statusCode == 200) {
        final status = parseResponse(response.data);

        if (status.status == 1 && imageFile != null) {
          try {
            await _uploadProductImage(
              barcode: product.barcode,
              username: username,
              password: password,
              imageFile: imageFile,
            );
          } catch (e) {
            print(
              '[TestableProductRepository] Product saved but image upload failed: $e',
            );
            // Ürün kaydedildi ama resim yüklenemedi - kullanıcıya bilgi ver
            return off.Status(
              status: 1,
              statusVerbose: 'Product saved but image upload failed: $e',
            );
          }
        } else if (status.status == 1 && imageFile == null) {}
        return status;
      } else {
        return off.Status(
          status: -1,
          statusVerbose:
              'HTTP error: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return off.Status(
          status: -1,
          statusVerbose:
              'HTTP error: ${e.response?.statusCode} - ${e.response?.statusMessage}',
        );
      } else {
        return off.Status(
          status: -1,
          statusVerbose: 'Network error: ${e.message}',
        );
      }
    } catch (e) {
      return off.Status(status: -1, statusVerbose: 'Unexpected error: $e');
    }
  }

  Future<off.Status> _handleRedirect(Response response) async {
    final location = response.headers['location']?.first;
    if (location == null) {
      return off.Status(
        status: -1,
        statusVerbose:
            'Redirect error: ${response.statusCode} - no location header',
      );
    }
    try {
      final redirectResponse = await _dio.post(
        location,
        data: response.requestOptions.data,
        options: Options(
          headers: response.requestOptions.headers,
          followRedirects: false,
        ),
      );
      if (redirectResponse.statusCode == 200) {
        return parseResponse(redirectResponse.data);
      } else {
        return off.Status(
          status: -1,
          statusVerbose: 'Redirect failed: ${redirectResponse.statusCode}',
        );
      }
    } on DioException catch (e) {
      return off.Status(
        status: -1,
        statusVerbose: 'Redirect error: ${e.message}',
      );
    } catch (e) {
      return off.Status(status: -1, statusVerbose: 'Redirect error: $e');
    }
  }

  off.Status parseResponse(dynamic responseData) {
    try {
      if (responseData is Map<String, dynamic>) {
        final status = responseData['status'];
        final statusVerbose =
            responseData['status_verbose'] ?? 'Unknown status';

        if (status == 1) {
          return off.Status(status: 1, statusVerbose: statusVerbose);
        } else if (status == 0) {
          return off.Status(status: 0, statusVerbose: statusVerbose);
        } else {
          return off.Status(
            status: -1,
            statusVerbose: 'Unknown status: $status',
          );
        }
      } else {
        // Fallback için string parsing
        final responseBody = responseData.toString();
        if (responseBody.contains('"status":1')) {
          return off.Status(
            status: 1,
            statusVerbose: 'Product saved successfully',
          );
        } else if (responseBody.contains('"status":0')) {
          return off.Status(status: 0, statusVerbose: 'Product not saved');
        } else {
          return off.Status(status: -1, statusVerbose: 'Unknown response');
        }
      }
    } catch (e) {
      return off.Status(status: -1, statusVerbose: 'Parse error: $e');
    }
  }

  Future<void> _uploadProductImage({
    required String barcode,
    required String username,
    required String password,
    required File imageFile,
  }) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist: ${imageFile.path}');
      }

      final formData = FormData.fromMap({
        'code': barcode,
        'imagefield': 'front',
        'user_id': username,
        'password': password,
        'action': 'process',
        'imgupload_front': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'product_image.jpg',
        ),
      });

      final response = await _dio.post(
        '/cgi/product_image_upload.pl',
        data: formData,
        options: Options(
          headers: {
            'Origin': _baseUrl,
            'Referer': '$_baseUrl/',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Image upload failed with status: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Image upload failed: ${e.message}');
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }
}
