import 'package:dio/dio.dart';

class OpenFoodFactsService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://world.openfoodfacts.org'));

  Future<List<dynamic>> searchProducts(String query, {String? country}) async {
    try {
      final params = {
        'search_terms': query,
        'search_simple': 1,
        'action': 'process',
        'json': 1,
      };
      if (country != null && country.isNotEmpty) {
        params['country'] = country;
      }
      final response = await _dio.get(
        '/cgi/search.pl',
        queryParameters: params,
      );
      return response.data['products'] ?? [];
    } catch (e) {
      throw Exception('Ürünler alınamadı: $e');
    }
  }
}
