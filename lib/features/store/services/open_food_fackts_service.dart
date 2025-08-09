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

  Future<List<dynamic>> searchProductsByCategory(
    String category, {
    String? country,
  }) async {
    try {
      final candidates = _candidateTagsForCategory(category);
      List<dynamic> products = [];

      for (final tag in candidates) {
        // 1) Try category endpoint (more reliable for known OFF tags)
        products = await _fetchCategoryEndpointProducts(tag, country: country);
        if (products.isNotEmpty) break;

        // 2) Try CGI search with tag
        final params = {
          'search_simple': 1,
          'action': 'process',
          'json': 1,
          'tagtype_0': 'categories',
          'tag_contains_0': 'contains',
          'tag_0': tag,
          'page_size': 100,
        };
        if (country != null && country.isNotEmpty) {
          params['country'] = country;
        }

        final response = await _dio.get(
          '/cgi/search.pl',
          queryParameters: params,
        );
        products = (response.data['products'] ?? []) as List<dynamic>;
        if (products.isNotEmpty) break;

        // Try with en:<tag>
        final responseEn = await _dio.get(
          '/cgi/search.pl',
          queryParameters: {...params, 'tag_0': 'en:$tag'},
        );
        products = (responseEn.data['products'] ?? []) as List<dynamic>;
        if (products.isNotEmpty) break;
      }

      if (products.isEmpty) {
        // Fallback: plain text search
        final fallbackQuery = category.replaceAll('&', ' ');
        products = await searchProducts(fallbackQuery, country: country);
      }

      return products;
    } catch (e) {
      throw Exception('Kategoriye göre ürünler alınamadı: $e');
    }
  }

  Future<List<dynamic>> _fetchCategoryEndpointProducts(
    String tag, {
    String? country,
  }) async {
    try {
      // Try without language prefix
      final resp = await _dio.get(
        '/category/$tag.json',
        queryParameters: {'page_size': 100, 'json': 1},
      );
      List<dynamic> products = (resp.data['products'] ?? []) as List<dynamic>;
      if (products.isEmpty) {
        // Try with en: prefix
        final respEn = await _dio.get(
          '/category/en:$tag.json',
          queryParameters: {'page_size': 100, 'json': 1},
        );
        products = (respEn.data['products'] ?? []) as List<dynamic>;
      }

      if (products.isEmpty) return products;

      if (country != null && country.isNotEmpty) {
        final countryTag = 'en:$country';
        products = products.where((p) {
          try {
            final tags =
                (p['countries_tags'] as List?)?.cast<String>() ??
                const <String>[];
            if (tags.contains(countryTag)) return true;
            // Fallback: check plain countries string
            final countries = (p['countries'] ?? '').toString().toLowerCase();
            return countries.contains(country.toLowerCase());
          } catch (_) {
            return true; // if unknown structure, keep item
          }
        }).toList();
      }
      return products;
    } catch (_) {
      return [];
    }
  }

  String _slugifyCategory(String input) {
    final lower = input.toLowerCase().trim();
    final replacedAnd = lower.replaceAll('&', 'and');
    final hyphenated = replacedAnd.replaceAll(RegExp('[^a-z0-9]+'), '-');
    final trimmed = hyphenated.replaceAll(RegExp(r'^-+|-+$'), '');
    return trimmed;
  }

  List<String> _candidateTagsForCategory(String displayName) {
    final slug = _slugifyCategory(displayName);
    // Hand-tuned mappings to OFF category tags
    final Map<String, List<String>> mapping = {
      // Only fruits for "Fruits & Vegetables"
      'fruits-and-vegetables': ['fruits', 'fresh-fruits'],
      'meat-and-fish': ['meats', 'fish-and-seafood', 'meat-and-fish'],
      'beverages': ['beverages'],
      'snacks': ['snacks'],
      'breakfast': ['breakfasts', 'breakfast-cereals', 'breakfast'],
      'dairy': ['dairies', 'dairy-products', 'milk-and-yogurt', 'dairy'],
    };
    return mapping[slug] ?? [slug];
  }
}
