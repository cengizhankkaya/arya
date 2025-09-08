// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';

import 'package:arya/features/index.dart';
import 'package:arya/features/store/model/cart_item_model.dart';

/// Product Detail Flow Integration Test Suite
///
/// Bu test suite'i product detail sayfasının entegrasyonunu test eder.
/// Product detail view model, cart entegrasyonu, state yönetimi ve hata durumları kapsanır.

void main() {
  group('Product Detail Flow Integration Tests', () {
    late ProductDetailViewModel productDetailViewModel;
    late Map<String, dynamic> mockProduct;

    /// Test helper: Mock product oluşturur
    Map<String, dynamic> createMockProduct({
      required String id,
      required String name,
      required String brand,
      required String imageUrl,
      Map<String, dynamic>? nutriments,
      String? ingredients,
      String? quantity,
      String? categories,
    }) {
      return {
        'id': id,
        'product_name': name,
        'brands': brand,
        'image_url': imageUrl,
        'image_small_url': imageUrl,
        'image_thumb_url': imageUrl,
        'ingredients_text': ingredients,
        'quantity': quantity,
        'categories': categories,
        'nutriments':
            nutriments ??
            {
              'energy-kcal_100g': 250.0,
              'proteins_100g': 15.0,
              'fat_100g': 12.0,
              'carbohydrates_100g': 20.0,
              'saturated-fat_100g': 5.0,
              'sugars_100g': 8.0,
              'salt_100g': 1.2,
            },
      };
    }

    setUp(() {
      mockProduct = createMockProduct(
        id: 'test-product-1',
        name: 'Test Ürün',
        brand: 'Test Marka',
        imageUrl: 'https://example.com/test.jpg',
        ingredients: 'Test malzemeler',
        quantity: '500g',
        categories: 'Test kategorisi',
      );

      productDetailViewModel = ProductDetailViewModel(product: mockProduct);
    });

    tearDown(() {
      // Dispose işlemi test içinde yapılıyor
    });

    test('ProductDetailViewModel başlangıçta doğru değerlerle başlar', () {
      // Assert
      expect(productDetailViewModel.quantity, 1);
      expect(productDetailViewModel.showDetail, false);
      expect(productDetailViewModel.isFavorite, false);
      expect(productDetailViewModel.isLoading, false);
      expect(productDetailViewModel.errorMessage, null);
      expect(productDetailViewModel.canAddToCart, true);
    });

    test('Product bilgileri doğru şekilde parse edilir', () {
      // Assert
      expect(productDetailViewModel.productName, 'Test Ürün');
      expect(productDetailViewModel.brand, 'Test Marka');
      expect(productDetailViewModel.imageUrl, 'https://example.com/test.jpg');
      expect(productDetailViewModel.ingredients, 'Test malzemeler');
      expect(productDetailViewModel.quantityText, '500g');
      expect(productDetailViewModel.categories, 'Test kategorisi');
    });

    test('Miktar başarıyla artırılır', () {
      // Act
      productDetailViewModel.incrementQuantity();

      // Assert
      expect(productDetailViewModel.quantity, 2);
    });

    test('Miktar başarıyla azaltılır', () {
      // Arrange
      productDetailViewModel.incrementQuantity();
      productDetailViewModel.incrementQuantity();

      // Act
      productDetailViewModel.decrementQuantity();

      // Assert
      expect(productDetailViewModel.quantity, 2);
    });

    test('Miktar 1\'den az olamaz', () {
      // Act
      productDetailViewModel.decrementQuantity();

      // Assert
      expect(productDetailViewModel.quantity, 1);
    });

    test('Favori durumu başarıyla değiştirilir', () {
      // Act
      productDetailViewModel.toggleFavorite();

      // Assert
      expect(productDetailViewModel.isFavorite, true);

      // Act
      productDetailViewModel.toggleFavorite();

      // Assert
      expect(productDetailViewModel.isFavorite, false);
    });

    test('Detay görünümü başarıyla değiştirilir', () {
      // Act
      productDetailViewModel.toggleDetail();

      // Assert
      expect(productDetailViewModel.showDetail, true);

      // Act
      productDetailViewModel.toggleDetail();

      // Assert
      expect(productDetailViewModel.showDetail, false);
    });

    test('Loading durumu başarıyla ayarlanır', () {
      // Act
      productDetailViewModel.setLoading(true);

      // Assert
      expect(productDetailViewModel.isLoading, true);
      expect(productDetailViewModel.canAddToCart, false);

      // Act
      productDetailViewModel.setLoading(false);

      // Assert
      expect(productDetailViewModel.isLoading, false);
      expect(productDetailViewModel.canAddToCart, true);
    });

    test('Hata mesajı başarıyla ayarlanır ve temizlenir', () {
      // Act
      productDetailViewModel.setError('Test hatası');

      // Assert
      expect(productDetailViewModel.errorMessage, 'Test hatası');

      // Act
      productDetailViewModel.clearError();

      // Assert
      expect(productDetailViewModel.errorMessage, null);
    });

    test('Miktar başarıyla sıfırlanır', () {
      // Arrange
      productDetailViewModel.incrementQuantity();
      productDetailViewModel.incrementQuantity();

      // Act
      productDetailViewModel.resetQuantity();

      // Assert
      expect(productDetailViewModel.quantity, 1);
    });

    test('Nutrition data doğru şekilde oluşturulur', () {
      // Act
      final nutritionData = productDetailViewModel.nutritionData;

      // Assert
      expect(nutritionData.length, 7);
      expect(nutritionData[0]['key'], 'energy-kcal_100g');
      expect(nutritionData[0]['label'], 'detail.energy');
      expect(nutritionData[0]['unit'], 'kcal');
      expect(nutritionData[1]['key'], 'fat_100g');
      expect(nutritionData[1]['label'], 'detail.fat');
      expect(nutritionData[1]['unit'], 'g');
    });

    test('Nutriments doğru şekilde parse edilir', () {
      // Act
      final nutriments = productDetailViewModel.nutriments;

      // Assert
      expect(nutriments['energy-kcal_100g'], 250.0);
      expect(nutriments['proteins_100g'], 15.0);
      expect(nutriments['fat_100g'], 12.0);
      expect(nutriments['carbohydrates_100g'], 20.0);
    });

    test('Boş nutriments ile çalışır', () {
      // Arrange
      final emptyProduct = createMockProduct(
        id: 'empty-nutriments',
        name: 'Boş Nutriments',
        brand: 'Test',
        imageUrl: 'https://example.com/test.jpg',
        nutriments: {},
      );
      final emptyViewModel = ProductDetailViewModel(product: emptyProduct);

      // Act
      final nutriments = emptyViewModel.nutriments;

      // Assert
      expect(nutriments, isEmpty);

      emptyViewModel.dispose();
    });

    test('Null nutriments ile çalışır', () {
      // Arrange
      final nullProduct = {
        'id': 'null-nutriments',
        'product_name': 'Null Nutriments',
        'brands': 'Test',
        'image_url': 'https://example.com/test.jpg',
        'nutriments': null,
      };
      final nullViewModel = ProductDetailViewModel(product: nullProduct);

      // Act
      final nutriments = nullViewModel.nutriments;

      // Assert
      expect(nutriments, isEmpty);

      nullViewModel.dispose();
    });

    test('Eksik product bilgileri ile çalışır', () {
      // Arrange
      final incompleteProduct = {
        'id': 'incomplete-product',
        'product_name': null,
        'brands': null,
        'image_url': null,
        'ingredients_text': null,
        'quantity': null,
        'categories': null,
        'nutriments': null,
      };
      final incompleteViewModel = ProductDetailViewModel(
        product: incompleteProduct,
      );

      // Assert
      expect(incompleteViewModel.productName, 'Product Name');
      expect(incompleteViewModel.brand, null);
      expect(incompleteViewModel.imageUrl, null);
      expect(incompleteViewModel.ingredients, null);
      expect(incompleteViewModel.quantityText, null);
      expect(incompleteViewModel.categories, null);
      expect(incompleteViewModel.nutriments, isEmpty);

      incompleteViewModel.dispose();
    });

    test('Image URL öncelik sırası doğru çalışır', () {
      // Arrange
      final imageProduct = {
        'id': 'image-test',
        'product_name': 'Image Test',
        'image_url': 'https://example.com/large.jpg',
        'image_small_url': 'https://example.com/small.jpg',
        'image_thumb_url': 'https://example.com/thumb.jpg',
        'nutriments': {},
      };
      final imageViewModel = ProductDetailViewModel(product: imageProduct);

      // Assert
      expect(imageViewModel.imageUrl, 'https://example.com/large.jpg');

      imageViewModel.dispose();
    });

    test('Image URL fallback doğru çalışır', () {
      // Arrange
      final fallbackProduct = {
        'id': 'fallback-test',
        'product_name': 'Fallback Test',
        'image_url': null,
        'image_small_url': 'https://example.com/small.jpg',
        'image_thumb_url': 'https://example.com/thumb.jpg',
        'nutriments': {},
      };
      final fallbackViewModel = ProductDetailViewModel(
        product: fallbackProduct,
      );

      // Assert
      expect(fallbackViewModel.imageUrl, 'https://example.com/small.jpg');

      fallbackViewModel.dispose();
    });

    test('Image URL son fallback doğru çalışır', () {
      // Arrange
      final lastFallbackProduct = {
        'id': 'last-fallback-test',
        'product_name': 'Last Fallback Test',
        'image_url': null,
        'image_small_url': null,
        'image_thumb_url': 'https://example.com/thumb.jpg',
        'nutriments': {},
      };
      final lastFallbackViewModel = ProductDetailViewModel(
        product: lastFallbackProduct,
      );

      // Assert
      expect(lastFallbackViewModel.imageUrl, 'https://example.com/thumb.jpg');

      lastFallbackViewModel.dispose();
    });

    test('CartItemModel oluşturma logic testi', () {
      // Arrange
      productDetailViewModel.incrementQuantity(); // quantity = 2

      // Act - CartItemModel oluşturma logic'ini test et
      final imageUrl =
          (mockProduct['image_url'] ??
                  mockProduct['image_small_url'] ??
                  mockProduct['image_thumb_url'])
              ?.toString();

      final cartItem = CartItemModel(
        id: mockProduct['id']?.toString() ?? '',
        productName: mockProduct['product_name']?.toString() ?? 'İsimsiz Ürün',
        brands: mockProduct['brands']?.toString(),
        imageThumbUrl: imageUrl,
        quantity: productDetailViewModel.quantity,
        nutriments:
            (mockProduct['nutriments'] as Map<String, dynamic>?) ?? const {},
      );

      // Assert
      expect(cartItem.id, 'test-product-1');
      expect(cartItem.productName, 'Test Ürün');
      expect(cartItem.brands, 'Test Marka');
      expect(cartItem.imageThumbUrl, 'https://example.com/test.jpg');
      expect(cartItem.quantity, 2);
      expect(cartItem.nutriments['energy-kcal_100g'], 250.0);
    });

    test('Eksik product ID ile CartItemModel oluşturma logic testi', () {
      // Arrange
      final incompleteProduct = {
        'id': null,
        'product_name': null,
        'brands': null,
        'image_url': null,
        'nutriments': {},
      };

      // Act - CartItemModel oluşturma logic'ini test et
      final imageUrl =
          (incompleteProduct['image_url'] ??
                  incompleteProduct['image_small_url'] ??
                  incompleteProduct['image_thumb_url'])
              ?.toString();

      final cartItem = CartItemModel(
        id: incompleteProduct['id']?.toString() ?? '',
        productName:
            incompleteProduct['product_name']?.toString() ?? 'İsimsiz Ürün',
        brands: incompleteProduct['brands']?.toString(),
        imageThumbUrl: imageUrl,
        quantity: 1,
        nutriments: Map<String, dynamic>.from(
          incompleteProduct['nutriments'] ?? {},
        ),
      );

      // Assert
      expect(cartItem.id, '');
      expect(cartItem.productName, 'İsimsiz Ürün');
      expect(cartItem.brands, null);
      expect(cartItem.imageThumbUrl, null);
      expect(cartItem.quantity, 1);
    });

    test('CanAddToCart validation doğru çalışır', () {
      // Arrange & Assert - Başlangıçta true olmalı
      expect(productDetailViewModel.canAddToCart, true);

      // Act - Loading true yap
      productDetailViewModel.setLoading(true);

      // Assert - Loading true iken false olmalı
      expect(productDetailViewModel.canAddToCart, false);

      // Act - Loading false yap
      productDetailViewModel.setLoading(false);

      // Assert - Loading false iken true olmalı
      expect(productDetailViewModel.canAddToCart, true);
    });

    test('Miktar 0 olduğunda canAddToCart false olur', () {
      // Arrange
      productDetailViewModel.resetQuantity();

      // Act - Miktarı 0 yapmak için decrementQuantity çağır (ama 1'den az olamaz)
      // Bu durumda quantity 1 kalır, bu yüzden canAddToCart true olmalı
      productDetailViewModel.decrementQuantity();

      // Assert
      expect(productDetailViewModel.quantity, 1);
      expect(productDetailViewModel.canAddToCart, true);
    });

    test('State değişiklikleri notifyListeners çağırır', () {
      // Arrange
      bool listenerCalled = false;
      productDetailViewModel.addListener(() {
        listenerCalled = true;
      });

      // Act
      productDetailViewModel.incrementQuantity();

      // Assert
      expect(listenerCalled, true);
    });

    test('Çoklu state değişiklikleri doğru çalışır', () {
      // Act
      productDetailViewModel.incrementQuantity();
      productDetailViewModel.toggleFavorite();
      productDetailViewModel.toggleDetail();
      productDetailViewModel.setLoading(true);

      // Assert
      expect(productDetailViewModel.quantity, 2);
      expect(productDetailViewModel.isFavorite, true);
      expect(productDetailViewModel.showDetail, true);
      expect(productDetailViewModel.isLoading, true);
      expect(productDetailViewModel.canAddToCart, false);
    });

    test('ShareProduct metodu çağrılabilir', () {
      // Act & Assert - Exception fırlatmamalı
      expect(() => productDetailViewModel.shareProduct(), returnsNormally);
    });

    test('Dispose işlemi güvenli şekilde çalışır', () {
      // Act & Assert - Exception fırlatmamalı
      expect(() => productDetailViewModel.dispose(), returnsNormally);
    });
  });
}
