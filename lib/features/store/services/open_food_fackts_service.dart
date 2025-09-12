import 'package:dio/dio.dart';

class OpenFoodFactsService {
  final Dio _dio;

  OpenFoodFactsService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://world.openfoodfacts.org',
              headers: {
                'User-Agent':
                    'Arya-Flutter-App/1.0 (https://github.com/your-repo)',
              },
            ),
          );

  Future<List<dynamic>> searchProducts(
    String query, {
    String? country,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final params = {
        'search_terms': query,
        'search_simple': 1,
        'action': 'process',
        'json': 1,
        'page': page,
        'page_size': pageSize,
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
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      // Özel olarak protein oranı yüksek ürünleri ara
      if (category.toLowerCase().contains('protein') ||
          category.toLowerCase().contains('yüksek')) {
        return await _searchHighProteinProducts(
          country: country,
          page: page,
          pageSize: pageSize,
        );
      }

      // Özel olarak karbonhidrat oranı yüksek ürünleri ara
      if (category.toLowerCase().contains('karbonhidrat') ||
          category.toLowerCase().contains('carbohydrate')) {
        return await _searchHighCarbohydrateProducts(
          country: country,
          page: page,
          pageSize: pageSize,
        );
      }

      // Özel olarak yağ oranı yüksek ürünleri ara
      if (category.toLowerCase().contains('yağ') ||
          category.toLowerCase().contains('fat')) {
        return await _searchHighFatProducts(
          country: country,
          page: page,
          pageSize: pageSize,
        );
      }

      // Özel olarak vitamin/mineral oranı yüksek ürünleri ara
      if (category.toLowerCase().contains('vitamin') ||
          category.toLowerCase().contains('mineral')) {
        return await _searchHighVitaminsMineralsProducts(
          country: country,
          page: page,
          pageSize: pageSize,
        );
      }

      // Özel olarak lif oranı yüksek ürünleri ara
      if (category.toLowerCase().contains('lif') ||
          category.toLowerCase().contains('fiber')) {
        return await _searchHighFiberProducts(
          country: country,
          page: page,
          pageSize: pageSize,
        );
      }

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
          'page': page,
          'page_size': pageSize,
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

  Future<List<dynamic>> _searchHighFiberProducts({
    String? country,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      List<dynamic> allProducts = [];

      // 1. Önce lif açısından zengin kategorileri dene
      final fiberCategories = [
        'whole-grains',
        'legumes',
        'vegetables',
        'fruits',
        'nuts',
        'seeds',
        'breakfast-cereals',
        'breads',
        'pasta',
        'rice',
        'oats',
        'quinoa',
        'barley',
        'rye',
        'wheat',
      ];

      for (final category in fiberCategories) {
        try {
          final categoryProducts = await _fetchCategoryEndpointProducts(
            category,
            country: country,
          );
          allProducts.addAll(categoryProducts);
          if (allProducts.length >= pageSize * 3)
            break; // Daha fazla ürün topla
        } catch (_) {
          continue;
        }
      }

      // 2. Lif oranı yüksek ürünleri filtrele ve sırala
      final highFiberProducts = allProducts.where((product) {
        try {
          final nutriments = product['nutriments'] as Map<String, dynamic>?;
          if (nutriments != null) {
            final fiber = nutriments['fiber'] ?? nutriments['fiber_100g'];
            if (fiber != null) {
              final fiberValue = double.tryParse(fiber.toString());
              return fiberValue != null &&
                  fiberValue >= 3.0; // 100g'da en az 3g lif
            }
          }
          return false;
        } catch (_) {
          return false;
        }
      }).toList();

      // 3. Lif oranına göre sırala (yüksekten düşüğe)
      highFiberProducts.sort((a, b) {
        try {
          final aNutriments = a['nutriments'] as Map<String, dynamic>?;
          final bNutriments = b['nutriments'] as Map<String, dynamic>?;

          final aFiber = aNutriments?['fiber'] ?? aNutriments?['fiber_100g'];
          final bFiber = bNutriments?['fiber'] ?? bNutriments?['fiber_100g'];

          final aValue = double.tryParse(aFiber?.toString() ?? '0') ?? 0.0;
          final bValue = double.tryParse(bFiber?.toString() ?? '0') ?? 0.0;

          return bValue.compareTo(aValue); // Yüksekten düşüğe sırala
        } catch (_) {
          return 0;
        }
      });

      // 4. Sayfalama için ürünleri döndür
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= highFiberProducts.length) {
        return [];
      }

      return highFiberProducts.sublist(
        startIndex,
        endIndex > highFiberProducts.length
            ? highFiberProducts.length
            : endIndex,
      );
    } catch (e) {
      throw Exception('Lif oranı yüksek ürünler alınamadı: $e');
    }
  }

  Future<List<dynamic>> _searchHighVitaminsMineralsProducts({
    String? country,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      List<dynamic> allProducts = [];

      // 1. Önce vitamin/mineral açısından zengin kategorileri dene
      final vitaminMineralCategories = [
        'fruits',
        'vegetables',
        'fresh-fruits',
        'fresh-vegetables',
        'legumes',
        'nuts',
        'seeds',
        'whole-grains',
        'dairy',
        'fish-and-seafood',
        'eggs',
        'herbs',
        'spices',
      ];

      for (final category in vitaminMineralCategories) {
        try {
          final categoryProducts = await _fetchCategoryEndpointProducts(
            category,
            country: country,
          );
          allProducts.addAll(categoryProducts);
          if (allProducts.length >= pageSize * 3)
            break; // Daha fazla ürün topla
        } catch (_) {
          continue;
        }
      }

      // 2. Vitamin/mineral oranı yüksek ürünleri filtrele ve sırala
      final highVitaminsMineralsProducts = allProducts.where((product) {
        try {
          final nutriments = product['nutriments'] as Map<String, dynamic>?;
          if (nutriments != null) {
            // Vitamin ve mineral değerlerini kontrol et
            final vitaminC =
                nutriments['vitamin-c'] ?? nutriments['vitamin-c_100g'];
            final vitaminA =
                nutriments['vitamin-a'] ?? nutriments['vitamin-a_100g'];
            final vitaminD =
                nutriments['vitamin-d'] ?? nutriments['vitamin-d_100g'];
            final vitaminE =
                nutriments['vitamin-e'] ?? nutriments['vitamin-e_100g'];
            final calcium = nutriments['calcium'] ?? nutriments['calcium_100g'];
            final iron = nutriments['iron'] ?? nutriments['iron_100g'];
            final magnesium =
                nutriments['magnesium'] ?? nutriments['magnesium_100g'];
            final potassium =
                nutriments['potassium'] ?? nutriments['potassium_100g'];
            final zinc = nutriments['zinc'] ?? nutriments['zinc_100g'];

            // En az bir vitamin veya mineral değeri yüksek olmalı
            final hasHighVitamins = [vitaminC, vitaminA, vitaminD, vitaminE]
                .any((v) {
                  if (v != null) {
                    final value = double.tryParse(v.toString());
                    return value != null && value > 0;
                  }
                  return false;
                });

            final hasHighMinerals = [calcium, iron, magnesium, potassium, zinc]
                .any((m) {
                  if (m != null) {
                    final value = double.tryParse(m.toString());
                    return value != null && value > 0;
                  }
                  return false;
                });

            return hasHighVitamins || hasHighMinerals;
          }
          return false;
        } catch (_) {
          return false;
        }
      }).toList();

      // 3. Vitamin/mineral içeriğine göre sırala
      highVitaminsMineralsProducts.sort((a, b) {
        try {
          final aNutriments = a['nutriments'] as Map<String, dynamic>?;
          final bNutriments = b['nutriments'] as Map<String, dynamic>?;

          if (aNutriments == null || bNutriments == null) return 0;

          // Toplam vitamin/mineral skorunu hesapla
          final aScore = _calculateVitaminMineralScore(aNutriments);
          final bScore = _calculateVitaminMineralScore(bNutriments);

          return bScore.compareTo(aScore); // Yüksekten düşüğe sırala
        } catch (_) {
          return 0;
        }
      });

      // 4. Sayfalama için ürünleri döndür
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= highVitaminsMineralsProducts.length) {
        return [];
      }

      return highVitaminsMineralsProducts.sublist(
        startIndex,
        endIndex > highVitaminsMineralsProducts.length
            ? highVitaminsMineralsProducts.length
            : endIndex,
      );
    } catch (e) {
      throw Exception('Vitamin/mineral oranı yüksek ürünler alınamadı: $e');
    }
  }

  double _calculateVitaminMineralScore(Map<String, dynamic> nutriments) {
    double score = 0.0;

    // Vitamin skorları
    final vitamins = [
      'vitamin-c',
      'vitamin-a',
      'vitamin-d',
      'vitamin-e',
      'vitamin-b1',
      'vitamin-b2',
      'vitamin-b6',
      'vitamin-b12',
    ];
    for (final vitamin in vitamins) {
      final value = nutriments[vitamin] ?? nutriments['${vitamin}_100g'];
      if (value != null) {
        final numValue = double.tryParse(value.toString()) ?? 0.0;
        score += numValue;
      }
    }

    // Mineral skorları
    final minerals = [
      'calcium',
      'iron',
      'magnesium',
      'potassium',
      'zinc',
      'selenium',
      'copper',
      'manganese',
    ];
    for (final mineral in minerals) {
      final value = nutriments[mineral] ?? nutriments['${mineral}_100g'];
      if (value != null) {
        final numValue = double.tryParse(value.toString()) ?? 0.0;
        score += numValue;
      }
    }

    return score;
  }

  Future<List<dynamic>> _searchHighFatProducts({
    String? country,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      List<dynamic> allProducts = [];

      // 1. Önce yağ açısından zengin kategorileri dene
      final fatCategories = [
        'oils',
        'nuts',
        'seeds',
        'dairy',
        'meats',
        'fish-and-seafood',
        'chocolate',
        'cookies',
        'pastries',
        'fried-foods',
      ];

      for (final category in fatCategories) {
        try {
          final categoryProducts = await _fetchCategoryEndpointProducts(
            category,
            country: country,
          );
          allProducts.addAll(categoryProducts);
          if (allProducts.length >= pageSize * 3)
            break; // Daha fazla ürün topla
        } catch (_) {
          continue;
        }
      }

      // 2. Yağ oranı yüksek ürünleri filtrele ve sırala
      final highFatProducts = allProducts.where((product) {
        try {
          final nutriments = product['nutriments'] as Map<String, dynamic>?;
          if (nutriments != null) {
            final fat = nutriments['fat'] ?? nutriments['fat_100g'];
            if (fat != null) {
              final fatValue = double.tryParse(fat.toString());
              return fatValue != null &&
                  fatValue >= 15.0; // 100g'da en az 15g yağ
            }
          }
          return false;
        } catch (_) {
          return false;
        }
      }).toList();

      // 3. Yağ oranına göre sırala (yüksekten düşüğe)
      highFatProducts.sort((a, b) {
        try {
          final aNutriments = a['nutriments'] as Map<String, dynamic>?;
          final bNutriments = b['nutriments'] as Map<String, dynamic>?;

          final aFat = aNutriments?['fat'] ?? aNutriments?['fat_100g'];
          final bFat = bNutriments?['fat'] ?? bNutriments?['fat_100g'];

          final aValue = double.tryParse(aFat?.toString() ?? '0') ?? 0.0;
          final bValue = double.tryParse(bFat?.toString() ?? '0') ?? 0.0;

          return bValue.compareTo(aValue); // Yüksekten düşüğe sırala
        } catch (_) {
          return 0;
        }
      });

      // 4. Sayfalama için ürünleri döndür
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= highFatProducts.length) {
        return [];
      }

      return highFatProducts.sublist(
        startIndex,
        endIndex > highFatProducts.length ? highFatProducts.length : endIndex,
      );
    } catch (e) {
      throw Exception('Yağ oranı yüksek ürünler alınamadı: $e');
    }
  }

  Future<List<dynamic>> _searchHighCarbohydrateProducts({
    String? country,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      List<dynamic> allProducts = [];

      // 1. Önce karbonhidrat açısından zengin kategorileri dene
      final carbohydrateCategories = [
        'breakfasts',
        'breakfast-cereals',
        'snacks',
        'beverages',
        'fruits',
        'grains',
        'breads',
        'pasta',
        'rice',
      ];

      for (final category in carbohydrateCategories) {
        try {
          final categoryProducts = await _fetchCategoryEndpointProducts(
            category,
            country: country,
          );
          allProducts.addAll(categoryProducts);
          if (allProducts.length >= pageSize * 3)
            break; // Daha fazla ürün topla
        } catch (_) {
          continue;
        }
      }

      // 2. Karbonhidrat oranı yüksek ürünleri filtrele ve sırala
      final highCarbohydrateProducts = allProducts.where((product) {
        try {
          final nutriments = product['nutriments'] as Map<String, dynamic>?;
          if (nutriments != null) {
            final carbohydrates =
                nutriments['carbohydrates'] ?? nutriments['carbohydrates_100g'];
            if (carbohydrates != null) {
              final carbohydrateValue = double.tryParse(
                carbohydrates.toString(),
              );
              return carbohydrateValue != null &&
                  carbohydrateValue >= 15.0; // 100g'da en az 15g karbonhidrat
            }
          }
          return false;
        } catch (_) {
          return false;
        }
      }).toList();

      // 3. Karbonhidrat oranına göre sırala (yüksekten düşüğe)
      highCarbohydrateProducts.sort((a, b) {
        try {
          final aNutriments = a['nutriments'] as Map<String, dynamic>?;
          final bNutriments = b['nutriments'] as Map<String, dynamic>?;

          final aCarbohydrates =
              aNutriments?['carbohydrates'] ??
              aNutriments?['carbohydrates_100g'];
          final bCarbohydrates =
              bNutriments?['carbohydrates'] ??
              bNutriments?['carbohydrates_100g'];

          final aValue =
              double.tryParse(aCarbohydrates?.toString() ?? '0') ?? 0.0;
          final bValue =
              double.tryParse(bCarbohydrates?.toString() ?? '0') ?? 0.0;

          return bValue.compareTo(aValue); // Yüksekten düşüğe sırala
        } catch (_) {
          return 0;
        }
      });

      // 4. Sayfalama için ürünleri döndür
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= highCarbohydrateProducts.length) {
        return [];
      }

      return highCarbohydrateProducts.sublist(
        startIndex,
        endIndex > highCarbohydrateProducts.length
            ? highCarbohydrateProducts.length
            : endIndex,
      );
    } catch (e) {
      throw Exception('Karbonhidrat oranı yüksek ürünler alınamadı: $e');
    }
  }

  Future<List<dynamic>> _searchHighProteinProducts({
    String? country,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      List<dynamic> allProducts = [];

      // 1. Önce protein açısından zengin kategorileri dene
      final proteinCategories = [
        'meats',
        'fish-and-seafood',
        'eggs',
        'legumes',
        'nuts',
        'dairy',
      ];

      for (final category in proteinCategories) {
        try {
          final categoryProducts = await _fetchCategoryEndpointProducts(
            category,
            country: country,
          );
          allProducts.addAll(categoryProducts);
          if (allProducts.length >= pageSize * 3)
            break; // Daha fazla ürün topla
        } catch (_) {
          continue;
        }
      }

      // 2. Protein oranı yüksek ürünleri filtrele ve sırala
      final highProteinProducts = allProducts.where((product) {
        try {
          final nutriments = product['nutriments'] as Map<String, dynamic>?;
          if (nutriments != null) {
            final proteins =
                nutriments['proteins'] ?? nutriments['proteins_100g'];
            if (proteins != null) {
              final proteinValue = double.tryParse(proteins.toString());
              return proteinValue != null &&
                  proteinValue >= 6.0; // 100g'da en az 6g protein
            }
          }
          return false;
        } catch (_) {
          return false;
        }
      }).toList();

      // 3. Protein oranına göre sırala (yüksekten düşüğe)
      highProteinProducts.sort((a, b) {
        try {
          final aNutriments = a['nutriments'] as Map<String, dynamic>?;
          final bNutriments = b['nutriments'] as Map<String, dynamic>?;

          final aProteins =
              aNutriments?['proteins'] ?? aNutriments?['proteins_100g'];
          final bProteins =
              bNutriments?['proteins'] ?? bNutriments?['proteins_100g'];

          final aValue = double.tryParse(aProteins?.toString() ?? '0') ?? 0.0;
          final bValue = double.tryParse(bProteins?.toString() ?? '0') ?? 0.0;

          return bValue.compareTo(aValue); // Yüksekten düşüğe sırala
        } catch (_) {
          return 0;
        }
      });

      // 4. Sayfalama için ürünleri döndür
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= highProteinProducts.length) {
        return [];
      }

      return highProteinProducts.sublist(
        startIndex,
        endIndex > highProteinProducts.length
            ? highProteinProducts.length
            : endIndex,
      );
    } catch (e) {
      throw Exception('Protein oranı yüksek ürünler alınamadı: $e');
    }
  }

  Future<List<dynamic>> _fetchCategoryEndpointProducts(
    String tag, {
    String? country,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      // Try without language prefix
      final resp = await _dio.get(
        '/category/$tag.json',
        queryParameters: {'page': page, 'page_size': pageSize, 'json': 1},
      );
      List<dynamic> products = (resp.data['products'] ?? []) as List<dynamic>;
      if (products.isEmpty) {
        // Try with en: prefix
        final respEn = await _dio.get(
          '/category/en:$tag.json',
          queryParameters: {'page': page, 'page_size': pageSize, 'json': 1},
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

  /// Barkod numarasına göre ürün arama
  Future<Map<String, dynamic>?> searchProductByBarcode(String barcode) async {
    try {
      // Barkod numarasını temizle (sadece rakamlar)
      final cleanBarcode = barcode.replaceAll(RegExp(r'[^0-9]'), '');

      if (cleanBarcode.isEmpty) {
        throw Exception('Geçersiz barkod numarası');
      }

      final response = await _dio.get(
        '/api/v0/product/$cleanBarcode.json',
        queryParameters: {'json': 1},
      );

      final data = response.data;
      if (data['status'] == 1 && data['product'] != null) {
        return data['product'] as Map<String, dynamic>;
      } else {
        return null; // Ürün bulunamadı
      }
    } catch (e) {
      throw Exception('Barkod ile ürün aranırken hata oluştu: $e');
    }
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
      'high-protein': ['high-protein', 'protein-rich', 'protein-foods'],
      'high-carbohydrate': [
        'high-carbohydrate',
        'carbohydrate-rich',
        'carbohydrate-foods',
      ],
      'high-fat': ['high-fat', 'fat-rich', 'fat-foods'],
      'high-vitamins-minerals': [
        'high-vitamins',
        'vitamin-rich',
        'mineral-rich',
        'nutrient-rich',
      ],
      'high-fiber': [
        'high-fiber',
        'fiber-rich',
        'whole-grains',
        'legumes',
        'vegetables',
      ],
    };
    return mapping[slug] ?? [slug];
  }
}
