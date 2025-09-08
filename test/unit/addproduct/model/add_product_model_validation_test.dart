import 'package:flutter_test/flutter_test.dart';

import 'package:arya/features/addproduct/model/add_product_model.dart';

void main() {
  group('AddProductModel Validation Tests', () {
    group('Barcode Validation', () {
      test('geçerli barkod değerleri için null döner', () {
        // Test case 1: 8 karakter barkod
        expect(AddProductModel.validateBarcode('12345678'), isNull);

        // Test case 2: 13 karakter barkod (EAN-13)
        expect(AddProductModel.validateBarcode('1234567890123'), isNull);

        // Test case 3: 12 karakter barkod (UPC)
        expect(AddProductModel.validateBarcode('123456789012'), isNull);

        // Test case 4: 14 karakter barkod (ITF-14)
        expect(AddProductModel.validateBarcode('12345678901234'), isNull);
      });

      test('null barkod için hata mesajı döner', () {
        final result = AddProductModel.validateBarcode(null);
        expect(result, equals('Barkod gerekli'));
      });

      test('boş barkod için hata mesajı döner', () {
        final result = AddProductModel.validateBarcode('');
        expect(result, equals('Barkod gerekli'));
      });

      test(
        'sadece boşluk karakteri içeren barkod için uzunluk hatası döner',
        () {
          final result = AddProductModel.validateBarcode('   ');
          expect(result, equals('Barkod en az 8 karakter olmalı'));
        },
      );

      test('8 karakterden kısa barkod için hata mesajı döner', () {
        // Test case 1: 1 karakter
        expect(
          AddProductModel.validateBarcode('1'),
          equals('Barkod en az 8 karakter olmalı'),
        );

        // Test case 2: 7 karakter
        expect(
          AddProductModel.validateBarcode('1234567'),
          equals('Barkod en az 8 karakter olmalı'),
        );
      });

      test('özel karakterler içeren barkod için null döner (geçerli)', () {
        // Barkod sadece uzunluk kontrolü yapıyor, özel karakter kontrolü yok
        expect(AddProductModel.validateBarcode('12345678-ABC'), isNull);
        expect(AddProductModel.validateBarcode('12345678.123'), isNull);
      });

      test('çok uzun barkod için null döner (geçerli)', () {
        // Maksimum uzunluk kontrolü yok, sadece minimum kontrol var
        final longBarcode = '1' * 100;
        expect(AddProductModel.validateBarcode(longBarcode), isNull);
      });
    });

    group('Name Validation', () {
      test('geçerli isim değerleri için null döner', () {
        // Test case 1: Minimum uzunluk (2 karakter)
        expect(AddProductModel.validateName('AB'), isNull);

        // Test case 2: Normal uzunluk
        expect(AddProductModel.validateName('Test Ürün'), isNull);

        // Test case 3: Uzun isim
        expect(
          AddProductModel.validateName('Çok Uzun Bir Ürün İsmi Bu'),
          isNull,
        );

        // Test case 4: Sayı içeren isim
        expect(AddProductModel.validateName('Ürün 123'), isNull);

        // Test case 5: Özel karakter içeren isim
        expect(AddProductModel.validateName('Ürün & Co.'), isNull);
      });

      test('null isim için hata mesajı döner', () {
        final result = AddProductModel.validateName(null);
        expect(result, equals('Ürün adı gerekli'));
      });

      test('boş isim için hata mesajı döner', () {
        final result = AddProductModel.validateName('');
        expect(result, equals('Ürün adı gerekli'));
      });

      test('sadece boşluk karakteri içeren isim için null döner (geçerli)', () {
        final result = AddProductModel.validateName('   ');
        expect(result, isNull);
      });

      test('2 karakterden kısa isim için hata mesajı döner', () {
        // Test case 1: 1 karakter
        expect(
          AddProductModel.validateName('A'),
          equals('Ürün adı en az 2 karakter olmalı'),
        );

        // Test case 2: Boşluk + 1 karakter (toplam 2 karakter, geçerli)
        expect(AddProductModel.validateName(' A'), isNull);
      });

      test('Unicode karakterler içeren isim için null döner', () {
        expect(AddProductModel.validateName('Türkçe Ürün'), isNull);
        expect(AddProductModel.validateName('Café Mocha'), isNull);
        expect(AddProductModel.validateName('产品名称'), isNull);
      });

      test('çok uzun isim için null döner (geçerli)', () {
        // Maksimum uzunluk kontrolü yok
        final longName = 'A' * 1000;
        expect(AddProductModel.validateName(longName), isNull);
      });
    });

    group('Brands Validation', () {
      test('geçerli marka değerleri için null döner', () {
        // Test case 1: Normal marka
        expect(AddProductModel.validateBrands('Test Marka'), isNull);

        // Test case 2: Kısa marka
        expect(AddProductModel.validateBrands('AB'), isNull);

        // Test case 3: Uzun marka
        expect(
          AddProductModel.validateBrands('Çok Uzun Bir Marka İsmi'),
          isNull,
        );

        // Test case 4: Sayı içeren marka
        expect(AddProductModel.validateBrands('Marka 123'), isNull);

        // Test case 5: Özel karakter içeren marka
        expect(AddProductModel.validateBrands('Marka & Co.'), isNull);
      });

      test('null marka için hata mesajı döner', () {
        final result = AddProductModel.validateBrands(null);
        expect(result, equals('Marka bilgisi gerekli'));
      });

      test('boş marka için hata mesajı döner', () {
        final result = AddProductModel.validateBrands('');
        expect(result, equals('Marka bilgisi gerekli'));
      });

      test(
        'sadece boşluk karakteri içeren marka için null döner (geçerli)',
        () {
          final result = AddProductModel.validateBrands('   ');
          expect(result, isNull);
        },
      );

      test('Unicode karakterler içeren marka için null döner', () {
        expect(AddProductModel.validateBrands('Türkçe Marka'), isNull);
        expect(AddProductModel.validateBrands('Café Brand'), isNull);
        expect(AddProductModel.validateBrands('品牌名称'), isNull);
      });

      test('çok uzun marka için null döner (geçerli)', () {
        // Maksimum uzunluk kontrolü yok
        final longBrand = 'A' * 1000;
        expect(AddProductModel.validateBrands(longBrand), isNull);
      });
    });

    group('Categories Validation', () {
      test('geçerli kategori değerleri için null döner', () {
        // Test case 1: Normal kategori
        expect(AddProductModel.validateCategories('Test Kategori'), isNull);

        // Test case 2: Kısa kategori
        expect(AddProductModel.validateCategories('AB'), isNull);

        // Test case 3: Uzun kategori
        expect(
          AddProductModel.validateCategories('Çok Uzun Bir Kategori İsmi'),
          isNull,
        );

        // Test case 4: Sayı içeren kategori
        expect(AddProductModel.validateCategories('Kategori 123'), isNull);

        // Test case 5: Özel karakter içeren kategori
        expect(AddProductModel.validateCategories('Kategori & Co.'), isNull);
      });

      test('null kategori için hata mesajı döner', () {
        final result = AddProductModel.validateCategories(null);
        expect(result, equals('Kategori bilgisi gerekli'));
      });

      test('boş kategori için hata mesajı döner', () {
        final result = AddProductModel.validateCategories('');
        expect(result, equals('Kategori bilgisi gerekli'));
      });

      test(
        'sadece boşluk karakteri içeren kategori için null döner (geçerli)',
        () {
          final result = AddProductModel.validateCategories('   ');
          expect(result, isNull);
        },
      );

      test('Unicode karakterler içeren kategori için null döner', () {
        expect(AddProductModel.validateCategories('Türkçe Kategori'), isNull);
        expect(AddProductModel.validateCategories('Café Category'), isNull);
        expect(AddProductModel.validateCategories('产品类别'), isNull);
      });

      test('çok uzun kategori için null döner (geçerli)', () {
        // Maksimum uzunluk kontrolü yok
        final longCategory = 'A' * 1000;
        expect(AddProductModel.validateCategories(longCategory), isNull);
      });
    });

    group('Quantity Validation', () {
      test('geçerli miktar değerleri için null döner', () {
        // Test case 1: Normal miktar
        expect(AddProductModel.validateQuantity('100g'), isNull);

        // Test case 2: Kısa miktar
        expect(AddProductModel.validateQuantity('1g'), isNull);

        // Test case 3: Uzun miktar
        expect(AddProductModel.validateQuantity('1000ml'), isNull);

        // Test case 4: Sayı + birim
        expect(AddProductModel.validateQuantity('250ml'), isNull);

        // Test case 5: Özel karakter içeren miktar
        expect(AddProductModel.validateQuantity('100.5g'), isNull);

        // Test case 6: Virgül içeren miktar
        expect(AddProductModel.validateQuantity('100,5g'), isNull);
      });

      test('null miktar için hata mesajı döner', () {
        final result = AddProductModel.validateQuantity(null);
        expect(result, equals('Miktar bilgisi gerekli'));
      });

      test('boş miktar için hata mesajı döner', () {
        final result = AddProductModel.validateQuantity('');
        expect(result, equals('Miktar bilgisi gerekli'));
      });

      test(
        'sadece boşluk karakteri içeren miktar için null döner (geçerli)',
        () {
          final result = AddProductModel.validateQuantity('   ');
          expect(result, isNull);
        },
      );

      test('Unicode karakterler içeren miktar için null döner', () {
        expect(AddProductModel.validateQuantity('100г'), isNull);
        expect(AddProductModel.validateQuantity('100毫升'), isNull);
      });

      test('çok uzun miktar için null döner (geçerli)', () {
        // Maksimum uzunluk kontrolü yok
        final longQuantity = 'A' * 1000;
        expect(AddProductModel.validateQuantity(longQuantity), isNull);
      });
    });

    group('Ingredients Validation', () {
      test('geçerli içerik değerleri için null döner', () {
        // Test case 1: Normal içerik
        expect(AddProductModel.validateIngredients('Test içerikler'), isNull);

        // Test case 2: Kısa içerik
        expect(AddProductModel.validateIngredients('AB'), isNull);

        // Test case 3: Uzun içerik
        expect(
          AddProductModel.validateIngredients('Çok Uzun Bir İçerik Listesi Bu'),
          isNull,
        );

        // Test case 4: Sayı içeren içerik
        expect(AddProductModel.validateIngredients('İçerik 123'), isNull);

        // Test case 5: Özel karakter içeren içerik
        expect(AddProductModel.validateIngredients('İçerik & Co.'), isNull);
      });

      test('null içerik için hata mesajı döner', () {
        final result = AddProductModel.validateIngredients(null);
        expect(result, equals('İçerik bilgisi gerekli'));
      });

      test('boş içerik için hata mesajı döner', () {
        final result = AddProductModel.validateIngredients('');
        expect(result, equals('İçerik bilgisi gerekli'));
      });

      test(
        'sadece boşluk karakteri içeren içerik için null döner (geçerli)',
        () {
          final result = AddProductModel.validateIngredients('   ');
          expect(result, isNull);
        },
      );

      test('Unicode karakterler içeren içerik için null döner', () {
        expect(AddProductModel.validateIngredients('Türkçe İçerik'), isNull);
        expect(AddProductModel.validateIngredients('Café Ingredients'), isNull);
        expect(AddProductModel.validateIngredients('产品成分'), isNull);
      });

      test('çok uzun içerik için null döner (geçerli)', () {
        // Maksimum uzunluk kontrolü yok
        final longIngredients = 'A' * 1000;
        expect(AddProductModel.validateIngredients(longIngredients), isNull);
      });
    });

    group('Comprehensive Validation Tests', () {
      test('tüm alanlar geçerli olduğunda model oluşturulabilir', () {
        expect(
          () => AddProductModel(
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
            description: 'Test açıklama',
            tags: 'test,ürün',
          ),
          returnsNormally,
        );
      });

      test('fromForm factory method validation testleri', () {
        // Test case 1: Tüm alanlar dolu
        final formModel1 = AddProductModel.fromForm(
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

        // Boşlukların trim edildiğini kontrol et
        expect(formModel1.barcode, equals('1234567890123'));
        expect(formModel1.name, equals('Test Ürün'));
        expect(formModel1.brands, equals('Test Marka'));
        expect(formModel1.categories, equals('Test Kategori'));
        expect(formModel1.quantity, equals('100g'));
        expect(formModel1.energy, equals('250'));
        expect(formModel1.fat, equals('10'));
        expect(formModel1.carbs, equals('30'));
        expect(formModel1.protein, equals('5'));
        expect(formModel1.ingredients, equals('Test içerikler'));
        expect(formModel1.sodium, equals('0.5'));
        expect(formModel1.fiber, equals('2'));
        expect(formModel1.sugar, equals('5'));
        expect(formModel1.allergens, equals('Gluten'));
        expect(formModel1.description, equals('Test açıklama'));
        expect(formModel1.tags, equals('test,ürün'));

        // Test case 2: Varsayılan değerlerle
        final formModel2 = AddProductModel.fromForm(
          barcode: '1234567890123',
          name: 'Test Ürün',
          brands: 'Test Marka',
          categories: 'Test Kategori',
          quantity: '100g',
          ingredients: 'Test içerikler',
        );

        expect(formModel2.energy, equals(''));
        expect(formModel2.fat, equals(''));
        expect(formModel2.carbs, equals(''));
        expect(formModel2.protein, equals(''));
        expect(formModel2.sodium, equals(''));
        expect(formModel2.fiber, equals(''));
        expect(formModel2.sugar, equals(''));
        expect(formModel2.allergens, equals(''));
        expect(formModel2.description, equals(''));
        expect(formModel2.tags, equals(''));
      });
    });

    group('Edge Cases and Error Scenarios', () {
      test('çok uzun string değerlerle çalışır', () {
        final longString = 'A' * 10000;

        expect(
          () => AddProductModel(
            barcode: longString,
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
          ),
          returnsNormally,
        );
      });

      test('özel karakterlerle çalışır', () {
        final specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

        expect(
          () => AddProductModel(
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
          ),
          returnsNormally,
        );
      });

      test('Unicode karakterlerle çalışır', () {
        final unicodeString =
            'Türkçe karakterler: çğıöşü ÇĞIÖŞÜ 中文 日本語 العربية';

        expect(
          () => AddProductModel(
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
          ),
          returnsNormally,
        );
      });

      test('null değerlerle çalışır (sadece id null olabilir)', () {
        expect(
          () => AddProductModel(
            id: null, // Sadece id null olabilir
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
            description: 'Test açıklama',
            tags: 'test,ürün',
          ),
          returnsNormally,
        );
      });

      test('boş string değerlerle çalışır', () {
        expect(
          () => AddProductModel(
            barcode: '1234567890123',
            name: 'Test Ürün',
            brands: 'Test Marka',
            categories: 'Test Kategori',
            quantity: '100g',
            energy: '', // Boş string
            fat: '', // Boş string
            carbs: '', // Boş string
            protein: '', // Boş string
            ingredients: 'Test içerikler',
            sodium: '', // Boş string
            fiber: '', // Boş string
            sugar: '', // Boş string
            allergens: '', // Boş string
            description: '', // Boş string
            tags: '', // Boş string
          ),
          returnsNormally,
        );
      });
    });

    group('Performance Tests', () {
      test('çok sayıda validation işlemi performans testi', () {
        final stopwatch = Stopwatch()..start();

        // 1000 kez validation işlemi yap
        for (int i = 0; i < 1000; i++) {
          AddProductModel.validateBarcode('1234567890123');
          AddProductModel.validateName('Test Ürün');
          AddProductModel.validateBrands('Test Marka');
          AddProductModel.validateCategories('Test Kategori');
          AddProductModel.validateQuantity('100g');
          AddProductModel.validateIngredients('Test içerikler');
        }

        stopwatch.stop();

        // 1000 işlemin 1 saniyeden az sürmesi beklenir
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });

      test('büyük model oluşturma performans testi', () {
        final stopwatch = Stopwatch()..start();

        // 100 kez büyük model oluştur
        for (int i = 0; i < 100; i++) {
          AddProductModel(
            barcode: '1234567890123',
            name: 'A' * 1000,
            brands: 'A' * 1000,
            categories: 'A' * 1000,
            quantity: 'A' * 1000,
            energy: 'A' * 1000,
            fat: 'A' * 1000,
            carbs: 'A' * 1000,
            protein: 'A' * 1000,
            ingredients: 'A' * 1000,
            sodium: 'A' * 1000,
            fiber: 'A' * 1000,
            sugar: 'A' * 1000,
            allergens: 'A' * 1000,
            description: 'A' * 1000,
            tags: 'A' * 1000,
          );
        }

        stopwatch.stop();

        // 100 model oluşturmanın 1 saniyeden az sürmesi beklenir
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
      });
    });

    group('Integration Tests', () {
      test('validation + model oluşturma entegrasyon testi', () {
        // Geçerli verilerle model oluştur
        final validData = {
          'barcode': '1234567890123',
          'name': 'Test Ürün',
          'brands': 'Test Marka',
          'categories': 'Test Kategori',
          'quantity': '100g',
          'ingredients': 'Test içerikler',
        };

        // Önce validation yap
        expect(AddProductModel.validateBarcode(validData['barcode']), isNull);
        expect(AddProductModel.validateName(validData['name']), isNull);
        expect(AddProductModel.validateBrands(validData['brands']), isNull);
        expect(
          AddProductModel.validateCategories(validData['categories']),
          isNull,
        );
        expect(AddProductModel.validateQuantity(validData['quantity']), isNull);
        expect(
          AddProductModel.validateIngredients(validData['ingredients']),
          isNull,
        );

        // Sonra model oluştur
        final model = AddProductModel.fromForm(
          barcode: validData['barcode']!,
          name: validData['name']!,
          brands: validData['brands']!,
          categories: validData['categories']!,
          quantity: validData['quantity']!,
          ingredients: validData['ingredients']!,
        );

        // Model değerlerini kontrol et
        expect(model.barcode, equals(validData['barcode']));
        expect(model.name, equals(validData['name']));
        expect(model.brands, equals(validData['brands']));
        expect(model.categories, equals(validData['categories']));
        expect(model.quantity, equals(validData['quantity']));
        expect(model.ingredients, equals(validData['ingredients']));
      });

      test('validation + API data dönüşümü entegrasyon testi', () {
        // Geçerli model oluştur
        final model = AddProductModel(
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
          description: 'Test açıklama',
          tags: 'test,ürün',
        );

        // API data'ya dönüştür
        final apiData = model.toApiData();

        // API data'nın doğru formatda olduğunu kontrol et
        expect(apiData['code'], equals('1234567890123'));
        expect(apiData['product_name'], equals('Test Ürün'));
        expect(apiData['brands'], equals('Test Marka'));
        expect(apiData['categories'], equals('Test Kategori'));
        expect(apiData['quantity'], equals('100g'));
        expect(apiData['ingredients_text'], equals('Test içerikler'));
        expect(apiData['nutriment_energy-kcal'], equals('250'));
        expect(apiData['nutriment_fat'], equals('10'));
        expect(apiData['nutriment_carbohydrates'], equals('30'));
        expect(apiData['nutriment_proteins'], equals('5'));
        expect(apiData['nutriment_salt'], equals('0.5'));
        expect(apiData['nutriment_fiber'], equals('2'));
        expect(apiData['nutriment_sugars'], equals('5'));
        expect(apiData['allergens_tags'], equals('Gluten'));
        expect(apiData['generic_name'], equals('Test açıklama'));
        expect(apiData['labels_tags'], equals('test,ürün'));
      });

      test('validation + copyWith entegrasyon testi', () {
        // Orijinal model oluştur
        final originalModel = AddProductModel(
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
          description: 'Test açıklama',
          tags: 'test,ürün',
        );

        // Yeni değerlerle güncelle
        final updatedModel = originalModel.copyWith(
          name: 'Güncellenmiş Ürün',
          energy: '300',
          fat: '15',
        );

        // Güncellenmiş değerleri kontrol et
        expect(updatedModel.name, equals('Güncellenmiş Ürün'));
        expect(updatedModel.energy, equals('300'));
        expect(updatedModel.fat, equals('15'));

        // Değişmeyen değerleri kontrol et
        expect(updatedModel.barcode, equals(originalModel.barcode));
        expect(updatedModel.brands, equals(originalModel.brands));
        expect(updatedModel.categories, equals(originalModel.categories));
        expect(updatedModel.quantity, equals(originalModel.quantity));
        expect(updatedModel.carbs, equals(originalModel.carbs));
        expect(updatedModel.protein, equals(originalModel.protein));
        expect(updatedModel.ingredients, equals(originalModel.ingredients));
        expect(updatedModel.sodium, equals(originalModel.sodium));
        expect(updatedModel.fiber, equals(originalModel.fiber));
        expect(updatedModel.sugar, equals(originalModel.sugar));
        expect(updatedModel.allergens, equals(originalModel.allergens));
        expect(updatedModel.description, equals(originalModel.description));
        expect(updatedModel.tags, equals(originalModel.tags));
      });
    });
  });
}
