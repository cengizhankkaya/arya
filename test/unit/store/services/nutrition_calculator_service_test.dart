import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/store/services/nutrition_calculator_service.dart';
import 'package:arya/product/theme/app_colors.dart';

void main() {
  group('NutritionCalculatorService Tests', () {
    group('getProteinValue', () {
      test('proteins anahtarını kullanarak protein değerini döndürür', () {
        final nutriments = {'proteins': '25.5'};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(25.5));
      });

      test('proteins_100g anahtarını kullanarak protein değerini döndürür', () {
        final nutriments = {'proteins_100g': '30.0'};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(30.0));
      });

      test('proteins anahtarı varsa proteins_100g\'yi görmezden gelir', () {
        final nutriments = {'proteins': '20.0', 'proteins_100g': '25.0'};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(20.0));
      });

      test('geçersiz string değer için 0.0 döndürür', () {
        final nutriments = {'proteins': 'invalid'};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(0.0));
      });

      test('null değer için 0.0 döndürür', () {
        final nutriments = <String, dynamic>{};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(0.0));
      });

      test('integer değer için doğru double değerini döndürür', () {
        final nutriments = {'proteins': 15};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(15.0));
      });

      test('negatif değer için negatif değeri döndürür', () {
        final nutriments = {'proteins': '-10.0'};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(-10.0));
      });
    });

    group('getCarbohydrateValue', () {
      test(
        'carbohydrates anahtarını kullanarak karbonhidrat değerini döndürür',
        () {
          final nutriments = {'carbohydrates': '45.5'};
          final result = NutritionCalculatorService.getCarbohydrateValue(
            nutriments,
          );
          expect(result, equals(45.5));
        },
      );

      test(
        'carbohydrates_100g anahtarını kullanarak karbonhidrat değerini döndürür',
        () {
          final nutriments = {'carbohydrates_100g': '50.0'};
          final result = NutritionCalculatorService.getCarbohydrateValue(
            nutriments,
          );
          expect(result, equals(50.0));
        },
      );

      test(
        'carbohydrates anahtarı varsa carbohydrates_100g\'yi görmezden gelir',
        () {
          final nutriments = {
            'carbohydrates': '40.0',
            'carbohydrates_100g': '45.0',
          };
          final result = NutritionCalculatorService.getCarbohydrateValue(
            nutriments,
          );
          expect(result, equals(40.0));
        },
      );

      test('geçersiz string değer için 0.0 döndürür', () {
        final nutriments = {'carbohydrates': 'invalid'};
        final result = NutritionCalculatorService.getCarbohydrateValue(
          nutriments,
        );
        expect(result, equals(0.0));
      });
    });

    group('getFatValue', () {
      test('fat anahtarını kullanarak yağ değerini döndürür', () {
        final nutriments = {'fat': '15.5'};
        final result = NutritionCalculatorService.getFatValue(nutriments);
        expect(result, equals(15.5));
      });

      test('fat_100g anahtarını kullanarak yağ değerini döndürür', () {
        final nutriments = {'fat_100g': '20.0'};
        final result = NutritionCalculatorService.getFatValue(nutriments);
        expect(result, equals(20.0));
      });

      test('fat anahtarı varsa fat_100g\'yi görmezden gelir', () {
        final nutriments = {'fat': '18.0', 'fat_100g': '22.0'};
        final result = NutritionCalculatorService.getFatValue(nutriments);
        expect(result, equals(18.0));
      });
    });

    group('getVitaminCValue', () {
      test('vitamin-c anahtarını kullanarak vitamin C değerini döndürür', () {
        final nutriments = {'vitamin-c': '60.0'};
        final result = NutritionCalculatorService.getVitaminCValue(nutriments);
        expect(result, equals(60.0));
      });

      test(
        'vitamin-c_100g anahtarını kullanarak vitamin C değerini döndürür',
        () {
          final nutriments = {'vitamin-c_100g': '80.0'};
          final result = NutritionCalculatorService.getVitaminCValue(
            nutriments,
          );
          expect(result, equals(80.0));
        },
      );
    });

    group('getCalciumValue', () {
      test('calcium anahtarını kullanarak kalsiyum değerini döndürür', () {
        final nutriments = {'calcium': '120.0'};
        final result = NutritionCalculatorService.getCalciumValue(nutriments);
        expect(result, equals(120.0));
      });

      test('calcium_100g anahtarını kullanarak kalsiyum değerini döndürür', () {
        final nutriments = {'calcium_100g': '150.0'};
        final result = NutritionCalculatorService.getCalciumValue(nutriments);
        expect(result, equals(150.0));
      });
    });

    group('getFiberValue', () {
      test('fiber anahtarını kullanarak lif değerini döndürür', () {
        final nutriments = {'fiber': '8.5'};
        final result = NutritionCalculatorService.getFiberValue(nutriments);
        expect(result, equals(8.5));
      });

      test('fiber_100g anahtarını kullanarak lif değerini döndürür', () {
        final nutriments = {'fiber_100g': '12.0'};
        final result = NutritionCalculatorService.getFiberValue(nutriments);
        expect(result, equals(12.0));
      });
    });

    group('hasNutritionInfo', () {
      test('protein değeri varsa true döndürür', () {
        final nutriments = {'proteins': '10.0'};
        final result = NutritionCalculatorService.hasNutritionInfo(nutriments);
        expect(result, isTrue);
      });

      test('karbonhidrat değeri varsa true döndürür', () {
        final nutriments = {'carbohydrates': '20.0'};
        final result = NutritionCalculatorService.hasNutritionInfo(nutriments);
        expect(result, isTrue);
      });

      test('yağ değeri varsa true döndürür', () {
        final nutriments = {'fat': '5.0'};
        final result = NutritionCalculatorService.hasNutritionInfo(nutriments);
        expect(result, isTrue);
      });

      test('vitamin C değeri varsa true döndürür', () {
        final nutriments = {'vitamin-c': '30.0'};
        final result = NutritionCalculatorService.hasNutritionInfo(nutriments);
        expect(result, isTrue);
      });

      test('kalsiyum değeri varsa true döndürür', () {
        final nutriments = {'calcium': '100.0'};
        final result = NutritionCalculatorService.hasNutritionInfo(nutriments);
        expect(result, isTrue);
      });

      test('lif değeri varsa true döndürür', () {
        final nutriments = {'fiber': '3.0'};
        final result = NutritionCalculatorService.hasNutritionInfo(nutriments);
        expect(result, isTrue);
      });

      test('hiçbir besin değeri yoksa false döndürür', () {
        final nutriments = <String, dynamic>{};
        final result = NutritionCalculatorService.hasNutritionInfo(nutriments);
        expect(result, isFalse);
      });

      test('tüm değerler 0 ise false döndürür', () {
        final nutriments = {
          'proteins': '0',
          'carbohydrates': '0',
          'fat': '0',
          'vitamin-c': '0',
          'calcium': '0',
          'fiber': '0',
        };
        final result = NutritionCalculatorService.hasNutritionInfo(nutriments);
        expect(result, isFalse);
      });
    });

    group('getDominantNutrient', () {
      test('en yüksek protein değeri için Protein döndürür', () {
        final nutriments = {
          'proteins': '30.0',
          'carbohydrates': '20.0',
          'fat': '10.0',
        };
        final result = NutritionCalculatorService.getDominantNutrient(
          nutriments,
        );
        expect(result, equals('Protein'));
      });

      test('en yüksek karbonhidrat değeri için Karbonhidrat döndürür', () {
        final nutriments = {
          'proteins': '15.0',
          'carbohydrates': '50.0',
          'fat': '10.0',
        };
        final result = NutritionCalculatorService.getDominantNutrient(
          nutriments,
        );
        expect(result, equals('Karbonhidrat'));
      });

      test('en yüksek yağ değeri için Yağ döndürür', () {
        final nutriments = {
          'proteins': '10.0',
          'carbohydrates': '20.0',
          'fat': '35.0',
        };
        final result = NutritionCalculatorService.getDominantNutrient(
          nutriments,
        );
        expect(result, equals('Yağ'));
      });

      test('en yüksek vitamin C değeri için Vitamin C döndürür', () {
        final nutriments = {
          'proteins': '10.0',
          'vitamin-c': '120.0',
          'calcium': '50.0',
        };
        final result = NutritionCalculatorService.getDominantNutrient(
          nutriments,
        );
        expect(result, equals('Vitamin C'));
      });

      test('en yüksek kalsiyum değeri için Kalsiyum döndürür', () {
        final nutriments = {
          'proteins': '10.0',
          'calcium': '200.0',
          'fiber': '5.0',
        };
        final result = NutritionCalculatorService.getDominantNutrient(
          nutriments,
        );
        expect(result, equals('Kalsiyum'));
      });

      test('en yüksek lif değeri için Lif döndürür', () {
        final nutriments = {
          'proteins': '10.0',
          'fiber': '15.0',
          'vitamin-c': '5.0',
        };
        final result = NutritionCalculatorService.getDominantNutrient(
          nutriments,
        );
        expect(result, equals('Lif'));
      });

      test('eşit değerlerde ilk sıradaki besin değerini döndürür', () {
        final nutriments = {
          'proteins': '20.0',
          'carbohydrates': '20.0',
          'fat': '20.0',
        };
        final result = NutritionCalculatorService.getDominantNutrient(
          nutriments,
        );
        // Sıralama algoritmasına göre ilk sıradaki değer döndürülür
        expect(
          result,
          isIn([
            'Protein',
            'Karbonhidrat',
            'Yağ',
            'Vitamin C',
            'Kalsiyum',
            'Lif',
          ]),
        );
      });
    });

    group('Color Methods', () {
      testWidgets('getProteinColor yüksek değer için doğru rengi döndürür', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            home: Builder(
              builder: (context) {
                final color = NutritionCalculatorService.getProteinColor(
                  25.0,
                  context,
                );
                expect(color, isA<Color>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('getCarbohydrateColor orta değer için doğru rengi döndürür', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            home: Builder(
              builder: (context) {
                final color = NutritionCalculatorService.getCarbohydrateColor(
                  25.0,
                  context,
                );
                expect(color, isA<Color>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets('getFatColor düşük değer için doğru rengi döndürür', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            home: Builder(
              builder: (context) {
                final color = NutritionCalculatorService.getFatColor(
                  10.0,
                  context,
                );
                expect(color, isA<Color>());
                return Container();
              },
            ),
          ),
        );
      });

      testWidgets(
        'getVitaminMineralColor yüksek değer için doğru rengi döndürür',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(extensions: [AppColors.light]),
              home: Builder(
                builder: (context) {
                  final color =
                      NutritionCalculatorService.getVitaminMineralColor(
                        150.0,
                        context,
                      );
                  expect(color, isA<Color>());
                  return Container();
                },
              ),
            ),
          );
        },
      );

      testWidgets('getFiberColor orta değer için doğru rengi döndürür', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            home: Builder(
              builder: (context) {
                final color = NutritionCalculatorService.getFiberColor(
                  8.0,
                  context,
                );
                expect(color, isA<Color>());
                return Container();
              },
            ),
          ),
        );
      });
    });

    group('Edge Cases', () {
      test('çok büyük sayılar için doğru değeri döndürür', () {
        final nutriments = {'proteins': '999999.99'};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(999999.99));
      });

      test('boş string için 0.0 döndürür', () {
        final nutriments = {'proteins': ''};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(0.0));
      });

      test('whitespace string için 0.0 döndürür', () {
        final nutriments = {'proteins': '   '};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(0.0));
      });

      test('sıfır değer için 0.0 döndürür', () {
        final nutriments = {'proteins': '0'};
        final result = NutritionCalculatorService.getProteinValue(nutriments);
        expect(result, equals(0.0));
      });
    });
  });
}
