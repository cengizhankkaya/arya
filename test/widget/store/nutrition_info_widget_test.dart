import 'package:arya/features/store/view/widget/nutrition_info_widget.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NutritionInfoWidget', () {
    late AppColors appColors;

    setUp(() {
      appColors = AppColors.light;
    });

    Widget createTestWidget({
      required Map<String, dynamic> product,
      AppColors? customAppColors,
    }) {
      return MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: [customAppColors ?? appColors],
        ),
        home: Scaffold(body: NutritionInfoWidget(product: product)),
      );
    }

    group('Null ve Boş Durumlar', () {
      testWidgets('nutriments null olduğunda SizedBox.shrink() döner', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          // nutriments yok
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Container), findsNothing);
      });

      testWidgets('nutriments boş olduğunda SizedBox.shrink() döner', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{},
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Container), findsNothing);
      });

      testWidgets('tüm besin değerleri 0 olduğunda SizedBox.shrink() döner', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': 0,
            'carbohydrates': 0,
            'fat': 0,
            'vitamin-c': 0,
            'calcium': 0,
            'fiber': 0,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Container), findsNothing);
      });
    });

    group('Tek Besin Değeri Testleri', () {
      testWidgets(
        'sadece protein değeri olduğunda sadece protein badge\'i gösterilir',
        (WidgetTester tester) async {
          // Arrange
          final product = <String, dynamic>{
            'product_name': 'Test Product',
            'nutriments': <String, dynamic>{
              'proteins': 15.5,
              'carbohydrates': 0,
              'fat': 0,
              'vitamin-c': 0,
              'calcium': 0,
              'fiber': 0,
            },
          };

          // Act
          await tester.pumpWidget(createTestWidget(product: product));

          // Assert
          expect(find.text('15.5g'), findsOneWidget);
          expect(find.text('Protein'), findsOneWidget);
          expect(find.text('Karb'), findsNothing);
          expect(find.text('Yağ'), findsNothing);
          expect(find.text('Vit/Min'), findsNothing);
          expect(find.text('Lif'), findsNothing);
          expect(find.byType(Container), findsOneWidget);
        },
      );

      testWidgets(
        'sadece karbonhidrat değeri olduğunda sadece karbonhidrat badge\'i gösterilir',
        (WidgetTester tester) async {
          // Arrange
          final product = <String, dynamic>{
            'product_name': 'Test Product',
            'nutriments': <String, dynamic>{
              'proteins': 0,
              'carbohydrates': 25.3,
              'fat': 0,
              'vitamin-c': 0,
              'calcium': 0,
              'fiber': 0,
            },
          };

          // Act
          await tester.pumpWidget(createTestWidget(product: product));

          // Assert
          expect(find.text('25.3g'), findsOneWidget);
          expect(find.text('Karb'), findsOneWidget);
          expect(find.text('Protein'), findsNothing);
          expect(find.text('Yağ'), findsNothing);
          expect(find.text('Vit/Min'), findsNothing);
          expect(find.text('Lif'), findsNothing);
        },
      );

      testWidgets(
        'sadece yağ değeri olduğunda sadece yağ badge\'i gösterilir',
        (WidgetTester tester) async {
          // Arrange
          final product = <String, dynamic>{
            'product_name': 'Test Product',
            'nutriments': <String, dynamic>{
              'proteins': 0,
              'carbohydrates': 0,
              'fat': 12.7,
              'vitamin-c': 0,
              'calcium': 0,
              'fiber': 0,
            },
          };

          // Act
          await tester.pumpWidget(createTestWidget(product: product));

          // Assert
          expect(find.text('12.7g'), findsOneWidget);
          expect(find.text('Yağ'), findsOneWidget);
          expect(find.text('Protein'), findsNothing);
          expect(find.text('Karb'), findsNothing);
          expect(find.text('Vit/Min'), findsNothing);
          expect(find.text('Lif'), findsNothing);
        },
      );

      testWidgets(
        'sadece vitamin C değeri olduğunda vitamin badge\'i gösterilir',
        (WidgetTester tester) async {
          // Arrange
          final product = <String, dynamic>{
            'product_name': 'Test Product',
            'nutriments': <String, dynamic>{
              'proteins': 0,
              'carbohydrates': 0,
              'fat': 0,
              'vitamin-c': 45.2,
              'calcium': 0,
              'fiber': 0,
            },
          };

          // Act
          await tester.pumpWidget(createTestWidget(product: product));

          // Assert
          expect(find.text('45.2mg'), findsOneWidget);
          expect(find.text('Vit/Min'), findsOneWidget);
          expect(find.text('Protein'), findsNothing);
          expect(find.text('Karb'), findsNothing);
          expect(find.text('Yağ'), findsNothing);
          expect(find.text('Lif'), findsNothing);
        },
      );

      testWidgets(
        'sadece kalsiyum değeri olduğunda vitamin badge\'i gösterilir',
        (WidgetTester tester) async {
          // Arrange
          final product = <String, dynamic>{
            'product_name': 'Test Product',
            'nutriments': <String, dynamic>{
              'proteins': 0,
              'carbohydrates': 0,
              'fat': 0,
              'vitamin-c': 0,
              'calcium': 120.5,
              'fiber': 0,
            },
          };

          // Act
          await tester.pumpWidget(createTestWidget(product: product));

          // Assert
          expect(find.text('120.5mg'), findsOneWidget);
          expect(find.text('Vit/Min'), findsOneWidget);
          expect(find.text('Protein'), findsNothing);
          expect(find.text('Karb'), findsNothing);
          expect(find.text('Yağ'), findsNothing);
          expect(find.text('Lif'), findsNothing);
        },
      );

      testWidgets(
        'sadece lif değeri olduğunda sadece lif badge\'i gösterilir',
        (WidgetTester tester) async {
          // Arrange
          final product = <String, dynamic>{
            'product_name': 'Test Product',
            'nutriments': <String, dynamic>{
              'proteins': 0,
              'carbohydrates': 0,
              'fat': 0,
              'vitamin-c': 0,
              'calcium': 0,
              'fiber': 8.3,
            },
          };

          // Act
          await tester.pumpWidget(createTestWidget(product: product));

          // Assert
          expect(find.text('8.3g'), findsOneWidget);
          expect(find.text('Lif'), findsOneWidget);
          expect(find.text('Protein'), findsNothing);
          expect(find.text('Karb'), findsNothing);
          expect(find.text('Yağ'), findsNothing);
          expect(find.text('Vit/Min'), findsNothing);
        },
      );
    });

    group('Çoklu Besin Değeri Testleri', () {
      testWidgets(
        'protein ve karbonhidrat değerleri olduğunda ayırıcı gösterilir',
        (WidgetTester tester) async {
          // Arrange
          final product = <String, dynamic>{
            'product_name': 'Test Product',
            'nutriments': <String, dynamic>{
              'proteins': 15.5,
              'carbohydrates': 25.3,
              'fat': 0,
              'vitamin-c': 0,
              'calcium': 0,
              'fiber': 0,
            },
          };

          // Act
          await tester.pumpWidget(createTestWidget(product: product));

          // Assert
          expect(find.text('15.5g'), findsOneWidget);
          expect(find.text('Protein'), findsOneWidget);
          expect(find.text('25.3g'), findsOneWidget);
          expect(find.text('Karb'), findsOneWidget);

          // Ayırıcı container'ı kontrol et - en az 2 container olmalı (ana container + ayırıcı)
          expect(find.byType(Container), findsAtLeastNWidgets(2));
        },
      );

      testWidgets('tüm besin değerleri olduğunda tüm badge\'ler gösterilir', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': 15.5,
            'carbohydrates': 25.3,
            'fat': 12.7,
            'vitamin-c': 45.2,
            'calcium': 0,
            'fiber': 8.3,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.text('15.5g'), findsOneWidget);
        expect(find.text('Protein'), findsOneWidget);
        expect(find.text('25.3g'), findsOneWidget);
        expect(find.text('Karb'), findsOneWidget);
        expect(find.text('12.7g'), findsOneWidget);
        expect(find.text('Yağ'), findsOneWidget);
        expect(find.text('45.2mg'), findsOneWidget);
        expect(find.text('Vit/Min'), findsOneWidget);
        expect(find.text('8.3g'), findsOneWidget);
        expect(find.text('Lif'), findsOneWidget);
      });

      testWidgets(
        'vitamin C ve kalsiyum değerleri olduğunda yüksek olan gösterilir',
        (WidgetTester tester) async {
          // Arrange
          final product = <String, dynamic>{
            'product_name': 'Test Product',
            'nutriments': <String, dynamic>{
              'proteins': 0,
              'carbohydrates': 0,
              'fat': 0,
              'vitamin-c': 30.0,
              'calcium': 80.0,
              'fiber': 0,
            },
          };

          // Act
          await tester.pumpWidget(createTestWidget(product: product));

          // Assert
          expect(find.text('80.0mg'), findsOneWidget); // Kalsiyum daha yüksek
          expect(find.text('Vit/Min'), findsOneWidget);
          expect(find.text('30.0mg'), findsNothing); // Vitamin C gösterilmez
        },
      );
    });

    group('Farklı Besin Değeri Formatları', () {
      testWidgets('_100g formatındaki değerler doğru okunur', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins_100g': 20.0,
            'carbohydrates_100g': 30.0,
            'fat_100g': 15.0,
            'vitamin-c_100g': 50.0,
            'calcium_100g': 100.0,
            'fiber_100g': 5.0,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.text('20.0g'), findsOneWidget);
        expect(find.text('Protein'), findsOneWidget);
        expect(find.text('30.0g'), findsOneWidget);
        expect(find.text('Karb'), findsOneWidget);
        expect(find.text('15.0g'), findsOneWidget);
        expect(find.text('Yağ'), findsOneWidget);
        expect(find.text('100.0mg'), findsOneWidget); // Kalsiyum daha yüksek
        expect(find.text('Vit/Min'), findsOneWidget);
        expect(find.text('5.0g'), findsOneWidget);
        expect(find.text('Lif'), findsOneWidget);
      });

      testWidgets('string formatındaki değerler doğru parse edilir', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': '18.5',
            'carbohydrates': '22.3',
            'fat': '10.7',
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.text('18.5g'), findsOneWidget);
        expect(find.text('Protein'), findsOneWidget);
        expect(find.text('22.3g'), findsOneWidget);
        expect(find.text('Karb'), findsOneWidget);
        expect(find.text('10.7g'), findsOneWidget);
        expect(find.text('Yağ'), findsOneWidget);
      });

      testWidgets('geçersiz değerler 0 olarak işlenir', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': 'invalid',
            'carbohydrates': null,
            'fat': '',
            'vitamin-c': 'abc',
            'calcium': 0,
            'fiber': 5.0, // Sadece bu geçerli
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.text('5.0g'), findsOneWidget);
        expect(find.text('Lif'), findsOneWidget);
        expect(find.text('Protein'), findsNothing);
        expect(find.text('Karb'), findsNothing);
        expect(find.text('Yağ'), findsNothing);
        expect(find.text('Vit/Min'), findsNothing);
      });
    });

    group('Widget Yapısı ve Stil Testleri', () {
      testWidgets('Container doğru padding ve decoration\'a sahip', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{'proteins': 15.5},
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        final container = tester.widget<Container>(find.byType(Container));
        expect(
          container.padding,
          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        );
        expect(container.decoration, isA<BoxDecoration>());

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.borderRadius, BorderRadius.circular(8));
        expect(decoration.border, isA<Border>());
      });

      testWidgets('Row doğru mainAxisSize ve mainAxisAlignment\'a sahip', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': 15.5,
            'carbohydrates': 25.3,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        final row = tester.widget<Row>(find.byType(Row));
        expect(row.mainAxisSize, MainAxisSize.min);
        expect(row.mainAxisAlignment, MainAxisAlignment.center);
      });

      testWidgets('Flexible widget\'ları doğru kullanılır', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': 15.5,
            'carbohydrates': 25.3,
            'fat': 12.7,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(
          find.byType(Flexible),
          findsNWidgets(3),
        ); // 3 besin değeri için 3 Flexible
      });
    });

    group('Hata Yönetimi', () {
      testWidgets('hata durumunda SizedBox.shrink() döner', (
        WidgetTester tester,
      ) async {
        // Arrange - Geçersiz product yapısı
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': 'invalid_nutriments', // String olarak geçersiz
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.byType(SizedBox), findsOneWidget);
        expect(find.byType(Container), findsNothing);
      });
    });

    group('Edge Case Testleri', () {
      testWidgets('çok küçük değerler doğru formatlanır', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': 0.1,
            'carbohydrates': 0.05,
            'fat': 0.99,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.text('0.1g'), findsNWidgets(2)); // protein ve carbohydrates
        expect(find.text('1.0g'), findsOneWidget); // fat (0.99 -> 1.0)
      });

      testWidgets('çok büyük değerler doğru formatlanır', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': 999.99,
            'carbohydrates': 1000.123,
            'fat': 500.555,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(find.text('1000.0g'), findsOneWidget); // proteins
        expect(find.text('1000.1g'), findsOneWidget); // carbohydrates
        expect(find.text('500.6g'), findsOneWidget); // fat
      });

      testWidgets('negatif değerler 0 olarak işlenir', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': -5.0,
            'carbohydrates': -10.0,
            'fat': -2.5,
            'vitamin-c': 0,
            'calcium': 0,
            'fiber': 0,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(
          find.byType(SizedBox),
          findsOneWidget,
        ); // Hiçbir değer gösterilmez
        expect(find.byType(Container), findsNothing);
      });
    });

    group('Performans ve Bellek Testleri', () {
      testWidgets('çok sayıda besin değeri ile performans testi', (
        WidgetTester tester,
      ) async {
        // Arrange
        final product = <String, dynamic>{
          'product_name': 'Test Product',
          'nutriments': <String, dynamic>{
            'proteins': 15.5,
            'carbohydrates': 25.3,
            'fat': 12.7,
            'vitamin-c': 45.2,
            'calcium': 120.5,
            'fiber': 8.3,
            // Ekstra alanlar (görmezden gelinmeli)
            'sodium': 200.0,
            'sugar': 10.0,
            'energy': 300.0,
          },
        };

        // Act
        await tester.pumpWidget(createTestWidget(product: product));

        // Assert
        expect(
          find.byType(Container),
          findsAtLeastNWidgets(1),
        ); // Ana container + ayırıcılar
        expect(find.byType(Row), findsOneWidget);
        expect(find.byType(Flexible), findsNWidgets(5)); // 5 besin değeri
      });
    });
  });
}
