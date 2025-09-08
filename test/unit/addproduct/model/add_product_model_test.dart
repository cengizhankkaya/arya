import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:arya/features/addproduct/model/add_product_model.dart';

// Mock sınıfları için annotation
@GenerateMocks([])
void main() {
  group('AddProductModel', () {
    late AddProductModel productModel;

    setUp(() {
      // Test için temel bir model oluştur
      productModel = AddProductModel(
        id: 'test-id-123',
        barcode: '1234567890123',
        name: 'Test Ürün',
        brands: 'Test Marka',
        categories: 'Test Kategori',
        quantity: '100g',
        energy: '250',
        fat: '10',
        carbs: '30',
        protein: '5',
        ingredients: 'Test içerikler',
        sodium: '0.5',
        fiber: '2',
        sugar: '5',
        allergens: 'Gluten',
        description: 'Test ürün açıklaması',
        tags: 'test,ürün',
      );
    });

    group('Constructor', () {
      test('tüm parametrelerle model oluşturulabilir', () {
        expect(productModel.id, 'test-id-123');
        expect(productModel.barcode, '1234567890123');
        expect(productModel.name, 'Test Ürün');
        expect(productModel.brands, 'Test Marka');
        expect(productModel.categories, 'Test Kategori');
        expect(productModel.quantity, '100g');
        expect(productModel.energy, '250');
        expect(productModel.fat, '10');
        expect(productModel.carbs, '30');
        expect(productModel.protein, '5');
        expect(productModel.ingredients, 'Test içerikler');
        expect(productModel.sodium, '0.5');
        expect(productModel.fiber, '2');
        expect(productModel.sugar, '5');
        expect(productModel.allergens, 'Gluten');
        expect(productModel.description, 'Test ürün açıklaması');
        expect(productModel.tags, 'test,ürün');
      });

      test('id olmadan model oluşturulabilir', () {
        final modelWithoutId = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Ürün',
          brands: 'Test Marka',
          categories: 'Test Kategori',
          quantity: '100g',
          energy: '250',
          fat: '10',
          carbs: '30',
          protein: '5',
          ingredients: 'Test içerikler',
          sodium: '0.5',
          fiber: '2',
          sugar: '5',
          allergens: 'Gluten',
          description: 'Test ürün açıklaması',
          tags: 'test,ürün',
        );

        expect(modelWithoutId.id, isNull);
        expect(modelWithoutId.barcode, '1234567890123');
      });
    });

    group('Validation Methods', () {
      group('validateBarcode', () {
        test('geçerli barkod için null döner', () {
          expect(AddProductModel.validateBarcode('12345678'), isNull);
          expect(AddProductModel.validateBarcode('1234567890123'), isNull);
        });

        test('null barkod için hata mesajı döner', () {
          expect(AddProductModel.validateBarcode(null), 'Barkod gerekli');
        });

        test('boş barkod için hata mesajı döner', () {
          expect(AddProductModel.validateBarcode(''), 'Barkod gerekli');
        });

        test('8 karakterden kısa barkod için hata mesajı döner', () {
          expect(
            AddProductModel.validateBarcode('1234567'),
            'Barkod en az 8 karakter olmalı',
          );
        });
      });

      group('validateName', () {
        test('geçerli isim için null döner', () {
          expect(AddProductModel.validateName('Test Ürün'), isNull);
          expect(AddProductModel.validateName('AB'), isNull);
        });

        test('null isim için hata mesajı döner', () {
          expect(AddProductModel.validateName(null), 'Ürün adı gerekli');
        });

        test('boş isim için hata mesajı döner', () {
          expect(AddProductModel.validateName(''), 'Ürün adı gerekli');
        });

        test('2 karakterden kısa isim için hata mesajı döner', () {
          expect(
            AddProductModel.validateName('A'),
            'Ürün adı en az 2 karakter olmalı',
          );
        });
      });

      group('validateBrands', () {
        test('geçerli marka için null döner', () {
          expect(AddProductModel.validateBrands('Test Marka'), isNull);
        });

        test('null marka için hata mesajı döner', () {
          expect(AddProductModel.validateBrands(null), 'Marka bilgisi gerekli');
        });

        test('boş marka için hata mesajı döner', () {
          expect(AddProductModel.validateBrands(''), 'Marka bilgisi gerekli');
        });
      });

      group('validateCategories', () {
        test('geçerli kategori için null döner', () {
          expect(AddProductModel.validateCategories('Test Kategori'), isNull);
        });

        test('null kategori için hata mesajı döner', () {
          expect(
            AddProductModel.validateCategories(null),
            'Kategori bilgisi gerekli',
          );
        });

        test('boş kategori için hata mesajı döner', () {
          expect(
            AddProductModel.validateCategories(''),
            'Kategori bilgisi gerekli',
          );
        });
      });

      group('validateQuantity', () {
        test('geçerli miktar için null döner', () {
          expect(AddProductModel.validateQuantity('100g'), isNull);
        });

        test('null miktar için hata mesajı döner', () {
          expect(
            AddProductModel.validateQuantity(null),
            'Miktar bilgisi gerekli',
          );
        });

        test('boş miktar için hata mesajı döner', () {
          expect(
            AddProductModel.validateQuantity(''),
            'Miktar bilgisi gerekli',
          );
        });
      });

      group('validateIngredients', () {
        test('geçerli içerik için null döner', () {
          expect(AddProductModel.validateIngredients('Test içerikler'), isNull);
        });

        test('null içerik için hata mesajı döner', () {
          expect(
            AddProductModel.validateIngredients(null),
            'İçerik bilgisi gerekli',
          );
        });

        test('boş içerik için hata mesajı döner', () {
          expect(
            AddProductModel.validateIngredients(''),
            'İçerik bilgisi gerekli',
          );
        });
      });
    });

    group('fromForm Factory', () {
      test('tüm parametrelerle form modeli oluşturur', () {
        final formModel = AddProductModel.fromForm(
          barcode: ' 1234567890123 ',
          name: ' Test Ürün ',
          brands: ' Test Marka ',
          categories: ' Test Kategori ',
          quantity: ' 100g ',
          energy: ' 250 ',
          fat: ' 10 ',
          carbs: ' 30 ',
          protein: ' 5 ',
          ingredients: ' Test içerikler ',
          sodium: ' 0.5 ',
          fiber: ' 2 ',
          sugar: ' 5 ',
          allergens: ' Gluten ',
          description: ' Test açıklama ',
          tags: ' test,ürün ',
        );

        expect(formModel.barcode, '1234567890123');
        expect(formModel.name, 'Test Ürün');
        expect(formModel.brands, 'Test Marka');
        expect(formModel.categories, 'Test Kategori');
        expect(formModel.quantity, '100g');
        expect(formModel.energy, '250');
        expect(formModel.fat, '10');
        expect(formModel.carbs, '30');
        expect(formModel.protein, '5');
        expect(formModel.ingredients, 'Test içerikler');
        expect(formModel.sodium, '0.5');
        expect(formModel.fiber, '2');
        expect(formModel.sugar, '5');
        expect(formModel.allergens, 'Gluten');
        expect(formModel.description, 'Test açıklama');
        expect(formModel.tags, 'test,ürün');
      });

      test('varsayılan değerlerle form modeli oluşturur', () {
        final formModel = AddProductModel.fromForm(
          barcode: '1234567890123',
          name: 'Test Ürün',
          brands: 'Test Marka',
          categories: 'Test Kategori',
          quantity: '100g',
          ingredients: 'Test içerikler',
        );

        expect(formModel.energy, '');
        expect(formModel.fat, '');
        expect(formModel.carbs, '');
        expect(formModel.protein, '');
        expect(formModel.sodium, '');
        expect(formModel.fiber, '');
        expect(formModel.sugar, '');
        expect(formModel.allergens, '');
        expect(formModel.description, '');
        expect(formModel.tags, '');
      });
    });

    group('toApiData', () {
      test('tüm alanlar dolu olduğunda API verisi oluşturur', () {
        final apiData = productModel.toApiData();

        expect(apiData['code'], '1234567890123');
        expect(apiData['product_name'], 'Test Ürün');
        expect(apiData['brands'], 'Test Marka');
        expect(apiData['categories'], 'Test Kategori');
        expect(apiData['quantity'], '100g');
        expect(apiData['ingredients_text'], 'Test içerikler');
        expect(apiData['nutriment_fiber'], '2');
        expect(apiData['nutriment_sugars'], '5');
        expect(apiData['allergens_tags'], 'Gluten');
        expect(apiData['generic_name'], 'Test ürün açıklaması');
        expect(apiData['labels_tags'], 'test,ürün');
        expect(apiData['nutriment_energy-kcal'], '250');
        expect(apiData['nutriment_energy-kcal_unit'], 'kcal');
        expect(apiData['nutriment_fat'], '10');
        expect(apiData['nutriment_fat_unit'], 'g');
        expect(apiData['nutriment_carbohydrates'], '30');
        expect(apiData['nutriment_carbohydrates_unit'], 'g');
        expect(apiData['nutriment_proteins'], '5');
        expect(apiData['nutriment_proteins_unit'], 'g');
        expect(apiData['nutriment_salt'], '0.5');
        expect(apiData['nutriment_salt_unit'], 'g');
      });

      test('boş besin değerleri API verisine dahil edilmez', () {
        final emptyModel = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Ürün',
          brands: 'Test Marka',
          categories: 'Test Kategori',
          quantity: '100g',
          energy: '',
          fat: '',
          carbs: '',
          protein: '',
          ingredients: 'Test içerikler',
          sodium: '',
          fiber: '',
          sugar: '',
          allergens: '',
          description: '',
          tags: '',
        );

        final apiData = emptyModel.toApiData();

        expect(apiData.containsKey('nutriment_energy-kcal'), isFalse);
        expect(apiData.containsKey('nutriment_fat'), isFalse);
        expect(apiData.containsKey('nutriment_carbohydrates'), isFalse);
        expect(apiData.containsKey('nutriment_proteins'), isFalse);
        expect(apiData.containsKey('nutriment_salt'), isFalse);
      });
    });

    group('copyWith', () {
      test('belirli alanları günceller', () {
        final updatedModel = productModel.copyWith(
          name: 'Güncellenmiş Ürün',
          energy: '300',
          fat: '15',
        );

        expect(updatedModel.name, 'Güncellenmiş Ürün');
        expect(updatedModel.energy, '300');
        expect(updatedModel.fat, '15');
        expect(updatedModel.barcode, '1234567890123'); // Değişmemiş
        expect(updatedModel.brands, 'Test Marka'); // Değişmemiş
      });

      test('tüm alanları günceller', () {
        final updatedModel = productModel.copyWith(
          id: 'new-id',
          barcode: '9876543210987',
          name: 'Yeni Ürün',
          brands: 'Yeni Marka',
          categories: 'Yeni Kategori',
          quantity: '200g',
          energy: '400',
          fat: '20',
          carbs: '40',
          protein: '10',
          ingredients: 'Yeni içerikler',
          sodium: '1.0',
          fiber: '4',
          sugar: '10',
          allergens: 'Süt',
          description: 'Yeni açıklama',
          tags: 'yeni,etiket',
        );

        expect(updatedModel.id, 'new-id');
        expect(updatedModel.barcode, '9876543210987');
        expect(updatedModel.name, 'Yeni Ürün');
        expect(updatedModel.brands, 'Yeni Marka');
        expect(updatedModel.categories, 'Yeni Kategori');
        expect(updatedModel.quantity, '200g');
        expect(updatedModel.energy, '400');
        expect(updatedModel.fat, '20');
        expect(updatedModel.carbs, '40');
        expect(updatedModel.protein, '10');
        expect(updatedModel.ingredients, 'Yeni içerikler');
        expect(updatedModel.sodium, '1.0');
        expect(updatedModel.fiber, '4');
        expect(updatedModel.sugar, '10');
        expect(updatedModel.allergens, 'Süt');
        expect(updatedModel.description, 'Yeni açıklama');
        expect(updatedModel.tags, 'yeni,etiket');
      });

      test('null parametrelerle orijinal değerleri korur', () {
        final updatedModel = productModel.copyWith();

        expect(updatedModel.id, 'test-id-123');
        expect(updatedModel.barcode, '1234567890123');
        expect(updatedModel.name, 'Test Ürün');
        expect(updatedModel.brands, 'Test Marka');
        expect(updatedModel.categories, 'Test Kategori');
        expect(updatedModel.quantity, '100g');
        expect(updatedModel.energy, '250');
        expect(updatedModel.fat, '10');
        expect(updatedModel.carbs, '30');
        expect(updatedModel.protein, '5');
        expect(updatedModel.ingredients, 'Test içerikler');
        expect(updatedModel.sodium, '0.5');
        expect(updatedModel.fiber, '2');
        expect(updatedModel.sugar, '5');
        expect(updatedModel.allergens, 'Gluten');
        expect(updatedModel.description, 'Test ürün açıklaması');
        expect(updatedModel.tags, 'test,ürün');
      });
    });

    group('Edge Cases', () {
      test('çok uzun string değerlerle çalışır', () {
        final longString = 'A' * 1000;
        final modelWithLongValues = AddProductModel(
          barcode: '1234567890123',
          name: longString,
          brands: longString,
          categories: longString,
          quantity: longString,
          energy: longString,
          fat: longString,
          carbs: longString,
          protein: longString,
          ingredients: longString,
          sodium: longString,
          fiber: longString,
          sugar: longString,
          allergens: longString,
          description: longString,
          tags: longString,
        );

        expect(modelWithLongValues.name, longString);
        expect(modelWithLongValues.description, longString);
      });

      test('özel karakterlerle çalışır', () {
        final specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
        final modelWithSpecialChars = AddProductModel(
          barcode: '1234567890123',
          name: specialChars,
          brands: specialChars,
          categories: specialChars,
          quantity: specialChars,
          energy: specialChars,
          fat: specialChars,
          carbs: specialChars,
          protein: specialChars,
          ingredients: specialChars,
          sodium: specialChars,
          fiber: specialChars,
          sugar: specialChars,
          allergens: specialChars,
          description: specialChars,
          tags: specialChars,
        );

        expect(modelWithSpecialChars.name, specialChars);
        expect(modelWithSpecialChars.description, specialChars);
      });

      test('Unicode karakterlerle çalışır', () {
        final unicodeString = 'Türkçe karakterler: çğıöşü ÇĞIÖŞÜ';
        final modelWithUnicode = AddProductModel(
          barcode: '1234567890123',
          name: unicodeString,
          brands: unicodeString,
          categories: unicodeString,
          quantity: unicodeString,
          energy: unicodeString,
          fat: unicodeString,
          carbs: unicodeString,
          protein: unicodeString,
          ingredients: unicodeString,
          sodium: unicodeString,
          fiber: unicodeString,
          sugar: unicodeString,
          allergens: unicodeString,
          description: unicodeString,
          tags: unicodeString,
        );

        expect(modelWithUnicode.name, unicodeString);
        expect(modelWithUnicode.description, unicodeString);
      });
    });
  });
}
