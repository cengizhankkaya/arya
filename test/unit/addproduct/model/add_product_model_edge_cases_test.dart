import 'package:flutter_test/flutter_test.dart';

import 'package:arya/features/addproduct/model/add_product_model.dart';

void main() {
  group('AddProductModel Edge Cases Tests', () {
    group('Boundary Value Tests', () {
      test('barkod minimum uzunluk sınırı testleri', () {
        // Tam 8 karakter (minimum geçerli)
        expect(AddProductModel.validateBarcode('12345678'), isNull);

        // 7 karakter (minimum geçersiz)
        expect(
          AddProductModel.validateBarcode('1234567'),
          equals('Barkod en az 8 karakter olmalı'),
        );

        // 8 karakter + 1 (geçerli)
        expect(AddProductModel.validateBarcode('123456789'), isNull);
      });

      test('isim minimum uzunluk sınırı testleri', () {
        // Tam 2 karakter (minimum geçerli)
        expect(AddProductModel.validateName('AB'), isNull);

        // 1 karakter (minimum geçersiz)
        expect(
          AddProductModel.validateName('A'),
          equals('Ürün adı en az 2 karakter olmalı'),
        );

        // 2 karakter + 1 (geçerli)
        expect(AddProductModel.validateName('ABC'), isNull);
      });

      test('sıfır uzunluk string testleri', () {
        expect(AddProductModel.validateBarcode(''), equals('Barkod gerekli'));
        expect(AddProductModel.validateName(''), equals('Ürün adı gerekli'));
        expect(
          AddProductModel.validateBrands(''),
          equals('Marka bilgisi gerekli'),
        );
        expect(
          AddProductModel.validateCategories(''),
          equals('Kategori bilgisi gerekli'),
        );
        expect(
          AddProductModel.validateQuantity(''),
          equals('Miktar bilgisi gerekli'),
        );
        expect(
          AddProductModel.validateIngredients(''),
          equals('İçerik bilgisi gerekli'),
        );
      });
    });

    group('Whitespace Edge Cases', () {
      test('sadece whitespace karakterleri testleri', () {
        // Sadece boşluk
        expect(
          AddProductModel.validateBarcode('   '),
          equals('Barkod en az 8 karakter olmalı'),
        );
        expect(
          AddProductModel.validateName('   '),
          isNull,
        ); // Name validation'da whitespace kontrolü yok
        expect(AddProductModel.validateBrands('   '), isNull);
        expect(AddProductModel.validateCategories('   '), isNull);
        expect(AddProductModel.validateQuantity('   '), isNull);
        expect(AddProductModel.validateIngredients('   '), isNull);

        // Sadece tab
        expect(
          AddProductModel.validateBarcode('\t\t\t'),
          equals('Barkod en az 8 karakter olmalı'),
        );
        expect(AddProductModel.validateName('\t\t\t'), isNull);

        // Sadece newline
        expect(
          AddProductModel.validateBarcode('\n\n\n'),
          equals('Barkod en az 8 karakter olmalı'),
        );
        expect(AddProductModel.validateName('\n\n\n'), isNull);

        // Karışık whitespace
        expect(
          AddProductModel.validateBarcode(' \t\n '),
          equals('Barkod en az 8 karakter olmalı'),
        );
        expect(AddProductModel.validateName(' \t\n '), isNull);
      });

      test('başında ve sonunda whitespace testleri', () {
        // Başında ve sonunda boşluk (trim edilmeli)
        final model = AddProductModel.fromForm(
          barcode: ' 1234567890123 ',
          name: ' Test Ürün ',
          brands: ' Test Marka ',
          categories: ' Test Kategori ',
          quantity: ' 100g ',
          ingredients: ' Test içerikler ',
        );

        expect(model.barcode, equals('1234567890123'));
        expect(model.name, equals('Test Ürün'));
        expect(model.brands, equals('Test Marka'));
        expect(model.categories, equals('Test Kategori'));
        expect(model.quantity, equals('100g'));
        expect(model.ingredients, equals('Test içerikler'));
      });
    });

    group('Special Characters Edge Cases', () {
      test('Unicode ve özel karakterler testleri', () {
        final specialChars = [
          '🚀', // Emoji
          'ñáéíóú', // Aksanlı karakterler
          '中文', // Çince
          'العربية', // Arapça
          'русский', // Rusça
          '日本語', // Japonca
          '한국어', // Korece
          'Ελληνικά', // Yunanca
          'עברית', // İbranice
          'தமிழ்', // Tamil
        ];

        for (final char in specialChars) {
          // Tüm validation metodları Unicode karakterleri kabul etmeli
          expect(AddProductModel.validateBarcode('12345678$char'), isNull);
          expect(AddProductModel.validateName('Test$char'), isNull);
          expect(AddProductModel.validateBrands('Brand$char'), isNull);
          expect(AddProductModel.validateCategories('Category$char'), isNull);
          expect(AddProductModel.validateQuantity('100$char'), isNull);
          expect(
            AddProductModel.validateIngredients('Ingredient$char'),
            isNull,
          );
        }
      });

      test('SQL injection karakterleri testleri', () {
        final sqlChars = [
          "'",
          '"',
          ';',
          '--',
          '/*',
          '*/',
          'DROP',
          'SELECT',
          'INSERT',
          'UPDATE',
          'DELETE',
        ];

        for (final char in sqlChars) {
          expect(AddProductModel.validateBarcode('12345678$char'), isNull);
          expect(AddProductModel.validateName('Test$char'), isNull);
          expect(AddProductModel.validateBrands('Brand$char'), isNull);
          expect(AddProductModel.validateCategories('Category$char'), isNull);
          expect(AddProductModel.validateQuantity('100$char'), isNull);
          expect(
            AddProductModel.validateIngredients('Ingredient$char'),
            isNull,
          );
        }
      });

      test('HTML/XML karakterleri testleri', () {
        final htmlChars = [
          '<',
          '>',
          '&',
          '"',
          "'",
          '<script>',
          '</script>',
          '<img>',
          '&lt;',
          '&gt;',
        ];

        for (final char in htmlChars) {
          expect(AddProductModel.validateBarcode('12345678$char'), isNull);
          expect(AddProductModel.validateName('Test$char'), isNull);
          expect(AddProductModel.validateBrands('Brand$char'), isNull);
          expect(AddProductModel.validateCategories('Category$char'), isNull);
          expect(AddProductModel.validateQuantity('100$char'), isNull);
          expect(
            AddProductModel.validateIngredients('Ingredient$char'),
            isNull,
          );
        }
      });
    });

    group('Numeric Edge Cases', () {
      test('sayısal değerler testleri', () {
        final numericValues = [
          '0',
          '1',
          '999',
          '1000',
          '999999',
          '0.0',
          '0.1',
          '1.0',
          '1.5',
          '99.99',
          '0,0',
          '0,1',
          '1,0',
          '1,5',
          '99,99',
          '-1',
          '-0.5',
          '-999',
          '+1',
          '+0.5',
          '+999',
          '1e5',
          '1E5',
          '1e-5',
          '1E-5',
          'infinity',
          'NaN',
          'null',
          'undefined',
        ];

        for (final value in numericValues) {
          expect(AddProductModel.validateBarcode('12345678$value'), isNull);
          expect(AddProductModel.validateName('Test$value'), isNull);
          expect(AddProductModel.validateBrands('Brand$value'), isNull);
          expect(AddProductModel.validateCategories('Category$value'), isNull);
          expect(AddProductModel.validateQuantity('$value g'), isNull);
          expect(
            AddProductModel.validateIngredients('Ingredient$value'),
            isNull,
          );
        }
      });
    });

    group('Length Edge Cases', () {
      test('çok uzun string testleri', () {
        final veryLongString = 'A' * 100000; // 100KB string

        // Çok uzun string'ler validation'dan geçmeli (maksimum uzunluk kontrolü yok)
        expect(AddProductModel.validateBarcode(veryLongString), isNull);
        expect(AddProductModel.validateName(veryLongString), isNull);
        expect(AddProductModel.validateBrands(veryLongString), isNull);
        expect(AddProductModel.validateCategories(veryLongString), isNull);
        expect(AddProductModel.validateQuantity(veryLongString), isNull);
        expect(AddProductModel.validateIngredients(veryLongString), isNull);
      });

      test('çok uzun string ile model oluşturma testi', () {
        final veryLongString = 'A' * 10000;

        expect(
          () => AddProductModel(
            barcode: veryLongString,
            name: veryLongString,
            brands: veryLongString,
            categories: veryLongString,
            quantity: veryLongString,
            energy: veryLongString,
            fat: veryLongString,
            carbs: veryLongString,
            protein: veryLongString,
            ingredients: veryLongString,
            sodium: veryLongString,
            fiber: veryLongString,
            sugar: veryLongString,
            allergens: veryLongString,
            description: veryLongString,
            tags: veryLongString,
          ),
          returnsNormally,
        );
      });
    });

    group('Null Safety Edge Cases', () {
      test('null değer testleri', () {
        expect(AddProductModel.validateBarcode(null), equals('Barkod gerekli'));
        expect(AddProductModel.validateName(null), equals('Ürün adı gerekli'));
        expect(
          AddProductModel.validateBrands(null),
          equals('Marka bilgisi gerekli'),
        );
        expect(
          AddProductModel.validateCategories(null),
          equals('Kategori bilgisi gerekli'),
        );
        expect(
          AddProductModel.validateQuantity(null),
          equals('Miktar bilgisi gerekli'),
        );
        expect(
          AddProductModel.validateIngredients(null),
          equals('İçerik bilgisi gerekli'),
        );
      });

      test('id null olabilir testi', () {
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
    });

    group('API Data Edge Cases', () {
      test('boş değerlerle API data oluşturma testi', () {
        final model = AddProductModel(
          barcode: '1234567890123',
          name: 'Test Ürün',
          brands: 'Test Marka',
          categories: 'Test Kategori',
          quantity: '100g',
          energy: '', // Boş
          fat: '', // Boş
          carbs: '', // Boş
          protein: '', // Boş
          ingredients: 'Test içerikler',
          sodium: '', // Boş
          fiber: '', // Boş
          sugar: '', // Boş
          allergens: '', // Boş
          description: '', // Boş
          tags: '', // Boş
        );

        final apiData = model.toApiData();

        // Boş olmayan alanlar
        expect(apiData['code'], equals('1234567890123'));
        expect(apiData['product_name'], equals('Test Ürün'));
        expect(apiData['brands'], equals('Test Marka'));
        expect(apiData['categories'], equals('Test Kategori'));
        expect(apiData['quantity'], equals('100g'));
        expect(apiData['ingredients_text'], equals('Test içerikler'));

        // Boş alanlar API data'da olmamalı (sadece energy, fat, carbs, protein, sodium için)
        expect(apiData.containsKey('nutriment_energy-kcal'), isFalse);
        expect(apiData.containsKey('nutriment_fat'), isFalse);
        expect(apiData.containsKey('nutriment_carbohydrates'), isFalse);
        expect(apiData.containsKey('nutriment_proteins'), isFalse);
        expect(apiData.containsKey('nutriment_salt'), isFalse);

        // Bu alanlar her zaman API data'da olur (boş olsalar bile)
        expect(apiData.containsKey('nutriment_fiber'), isTrue);
        expect(apiData.containsKey('nutriment_sugars'), isTrue);
        expect(apiData.containsKey('allergens_tags'), isTrue);
        expect(apiData.containsKey('generic_name'), isTrue);
        expect(apiData.containsKey('labels_tags'), isTrue);

        // Boş değerleri kontrol et
        expect(apiData['nutriment_fiber'], equals(''));
        expect(apiData['nutriment_sugars'], equals(''));
        expect(apiData['allergens_tags'], equals(''));
        expect(apiData['generic_name'], equals(''));
        expect(apiData['labels_tags'], equals(''));
      });

      test('tüm alanlar dolu API data testi', () {
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

        final apiData = model.toApiData();

        // Tüm alanlar API data'da olmalı
        expect(apiData['code'], equals('1234567890123'));
        expect(apiData['product_name'], equals('Test Ürün'));
        expect(apiData['brands'], equals('Test Marka'));
        expect(apiData['categories'], equals('Test Kategori'));
        expect(apiData['quantity'], equals('100g'));
        expect(apiData['ingredients_text'], equals('Test içerikler'));
        expect(apiData['nutriment_energy-kcal'], equals('250'));
        expect(apiData['nutriment_energy-kcal_unit'], equals('kcal'));
        expect(apiData['nutriment_fat'], equals('10'));
        expect(apiData['nutriment_fat_unit'], equals('g'));
        expect(apiData['nutriment_carbohydrates'], equals('30'));
        expect(apiData['nutriment_carbohydrates_unit'], equals('g'));
        expect(apiData['nutriment_proteins'], equals('5'));
        expect(apiData['nutriment_proteins_unit'], equals('g'));
        expect(apiData['nutriment_salt'], equals('0.5'));
        expect(apiData['nutriment_salt_unit'], equals('g'));
        expect(apiData['nutriment_fiber'], equals('2'));
        expect(apiData['nutriment_sugars'], equals('5'));
        expect(apiData['allergens_tags'], equals('Gluten'));
        expect(apiData['generic_name'], equals('Test açıklama'));
        expect(apiData['labels_tags'], equals('test,ürün'));
      });
    });

    group('CopyWith Edge Cases', () {
      test('copyWith null değerlerle testi', () {
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

        // Hiçbir parametre vermeden copyWith çağır
        final copiedModel = originalModel.copyWith();

        // Tüm değerler aynı olmalı
        expect(copiedModel.barcode, equals(originalModel.barcode));
        expect(copiedModel.name, equals(originalModel.name));
        expect(copiedModel.brands, equals(originalModel.brands));
        expect(copiedModel.categories, equals(originalModel.categories));
        expect(copiedModel.quantity, equals(originalModel.quantity));
        expect(copiedModel.energy, equals(originalModel.energy));
        expect(copiedModel.fat, equals(originalModel.fat));
        expect(copiedModel.carbs, equals(originalModel.carbs));
        expect(copiedModel.protein, equals(originalModel.protein));
        expect(copiedModel.ingredients, equals(originalModel.ingredients));
        expect(copiedModel.sodium, equals(originalModel.sodium));
        expect(copiedModel.fiber, equals(originalModel.fiber));
        expect(copiedModel.sugar, equals(originalModel.sugar));
        expect(copiedModel.allergens, equals(originalModel.allergens));
        expect(copiedModel.description, equals(originalModel.description));
        expect(copiedModel.tags, equals(originalModel.tags));
      });

      test('copyWith boş string değerlerle testi', () {
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

        // Boş string değerlerle güncelle
        final updatedModel = originalModel.copyWith(
          name: '',
          energy: '',
          fat: '',
          carbs: '',
          protein: '',
          sodium: '',
          fiber: '',
          sugar: '',
          allergens: '',
          description: '',
          tags: '',
        );

        // Güncellenen değerler boş olmalı
        expect(updatedModel.name, equals(''));
        expect(updatedModel.energy, equals(''));
        expect(updatedModel.fat, equals(''));
        expect(updatedModel.carbs, equals(''));
        expect(updatedModel.protein, equals(''));
        expect(updatedModel.sodium, equals(''));
        expect(updatedModel.fiber, equals(''));
        expect(updatedModel.sugar, equals(''));
        expect(updatedModel.allergens, equals(''));
        expect(updatedModel.description, equals(''));
        expect(updatedModel.tags, equals(''));

        // Değişmeyen değerler aynı olmalı
        expect(updatedModel.barcode, equals(originalModel.barcode));
        expect(updatedModel.brands, equals(originalModel.brands));
        expect(updatedModel.categories, equals(originalModel.categories));
        expect(updatedModel.quantity, equals(originalModel.quantity));
        expect(updatedModel.ingredients, equals(originalModel.ingredients));
      });
    });

    group('Memory and Performance Edge Cases', () {
      test('çok sayıda model oluşturma memory testi', () {
        final models = <AddProductModel>[];

        // 1000 model oluştur
        for (int i = 0; i < 1000; i++) {
          models.add(
            AddProductModel(
              barcode: '1234567890123',
              name: 'Test Ürün $i',
              brands: 'Test Marka $i',
              categories: 'Test Kategori $i',
              quantity: '100g',
              energy: '250',
              fat: '10',
              carbs: '30',
              protein: '5',
              ingredients: 'Test içerikler $i',
              sodium: '0.5',
              fiber: '2',
              sugar: '5',
              allergens: 'Gluten',
              description: 'Test açıklama $i',
              tags: 'test,ürün,$i',
            ),
          );
        }

        // Tüm modellerin oluşturulduğunu kontrol et
        expect(models.length, equals(1000));
        expect(models.first.name, equals('Test Ürün 0'));
        expect(models.last.name, equals('Test Ürün 999'));
      });

      test('çok sayıda validation performans testi', () {
        final stopwatch = Stopwatch()..start();

        // 10000 kez validation işlemi yap
        for (int i = 0; i < 10000; i++) {
          AddProductModel.validateBarcode('1234567890123');
          AddProductModel.validateName('Test Ürün');
          AddProductModel.validateBrands('Test Marka');
          AddProductModel.validateCategories('Test Kategori');
          AddProductModel.validateQuantity('100g');
          AddProductModel.validateIngredients('Test içerikler');
        }

        stopwatch.stop();

        // 10000 işlemin 5 saniyeden az sürmesi beklenir
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });
    });

    group('Concurrent Access Edge Cases', () {
      test('aynı anda çok sayıda model oluşturma testi', () {
        final futures = <Future<AddProductModel>>[];

        // 100 eşzamanlı model oluşturma işlemi
        for (int i = 0; i < 100; i++) {
          futures.add(
            Future(
              () => AddProductModel(
                barcode: '1234567890123',
                name: 'Test Ürün $i',
                brands: 'Test Marka $i',
                categories: 'Test Kategori $i',
                quantity: '100g',
                energy: '250',
                fat: '10',
                carbs: '30',
                protein: '5',
                ingredients: 'Test içerikler $i',
                sodium: '0.5',
                fiber: '2',
                sugar: '5',
                allergens: 'Gluten',
                description: 'Test açıklama $i',
                tags: 'test,ürün,$i',
              ),
            ),
          );
        }

        // Tüm işlemlerin tamamlanmasını bekle
        return Future.wait(futures).then((models) {
          expect(models.length, equals(100));
          expect(models.first.name, equals('Test Ürün 0'));
          expect(models.last.name, equals('Test Ürün 99'));
        });
      });
    });

    group('Data Type Edge Cases', () {
      test('farklı string formatları testleri', () {
        final testCases = [
          'normal string',
          'STRING WITH CAPS',
          'string with numbers 123',
          'string-with-dashes',
          'string_with_underscores',
          'string.with.dots',
          'string with spaces',
          'string\twith\ttabs',
          'string\nwith\nnewlines',
          'string\rwith\rcarriage',
          'string with mixed\t\n\r characters',
        ];

        for (final testCase in testCases) {
          expect(AddProductModel.validateBarcode('12345678$testCase'), isNull);
          expect(AddProductModel.validateName(testCase), isNull);
          expect(AddProductModel.validateBrands(testCase), isNull);
          expect(AddProductModel.validateCategories(testCase), isNull);
          expect(AddProductModel.validateQuantity('$testCase g'), isNull);
          expect(AddProductModel.validateIngredients(testCase), isNull);
        }
      });
    });
  });
}
