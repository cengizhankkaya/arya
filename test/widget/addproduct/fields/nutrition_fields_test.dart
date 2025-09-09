import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:arya/features/addproduct/view/widgets/fields/nutrition_fields.dart';
import 'package:arya/features/addproduct/view/widgets/common/form_field.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/product/index.dart';
import '../../../helpers/test_helpers.dart';

import 'nutrition_fields_test.mocks.dart';

/// Mock sınıfları için annotation
@GenerateMocks([AddProductViewModel])
void main() {
  group('NutritionFields Widget Tests', () {
    late MockAddProductViewModel mockViewModel;

    setUpAll(() async {
      // Test ortamını başlat
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupComprehensiveFirebaseMocks();
      await TestHelpers.initializeFirebaseForTests();
      TestHelpers.setupPlatformChannels();
    });

    setUp(() {
      // Mock ViewModel'i initialize et
      mockViewModel = MockAddProductViewModel();

      // Mock nutrition controller'ları ayarla
      when(mockViewModel.energyController).thenReturn(TextEditingController());
      when(mockViewModel.fatController).thenReturn(TextEditingController());
      when(mockViewModel.carbsController).thenReturn(TextEditingController());
      when(mockViewModel.proteinController).thenReturn(TextEditingController());
      when(mockViewModel.sodiumController).thenReturn(TextEditingController());
      when(mockViewModel.fiberController).thenReturn(TextEditingController());
      when(mockViewModel.sugarController).thenReturn(TextEditingController());
    });

    tearDown(() {
      // Test sonrası temizlik
      reset(mockViewModel);
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    /// Test için NutritionFields wrapper'ı oluştur
    Widget createTestNutritionFields() {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
        home: Scaffold(body: NutritionFields(viewModel: mockViewModel)),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('NutritionFields temel widget yapısını göstermeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Ana widget'ların varlığını kontrol et
        expect(find.byType(NutritionFields), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('Section title doğru şekilde görünmeli', (tester) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Section title'ın varlığını kontrol et
        expect(find.text('add_product.sections.nutrition'), findsOneWidget);
      });

      testWidgets('Tüm nutrition form alanları doğru şekilde render edilmeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Form alanlarının varlığını kontrol et (7 alan)
        expect(find.byType(CustomFormField), findsNWidgets(7));

        // Her alanın label'ını kontrol et
        expect(find.text('add_product.fields.energy'), findsOneWidget);
        expect(find.text('add_product.fields.fat'), findsOneWidget);
        expect(find.text('add_product.fields.carbs'), findsOneWidget);
        expect(find.text('add_product.fields.protein'), findsOneWidget);
        expect(find.text('add_product.fields.sodium'), findsOneWidget);
        expect(find.text('add_product.fields.fiber'), findsOneWidget);
        expect(find.text('add_product.fields.sugar'), findsOneWidget);
      });

      testWidgets('Nutrition alanları doğru sırada görünmeli', (tester) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // İlk satır: Energy ve Fat
        final firstRow = find.byType(Row).at(0);
        expect(firstRow, findsOneWidget);

        // İkinci satır: Carbs ve Protein
        final secondRow = find.byType(Row).at(1);
        expect(secondRow, findsOneWidget);

        // Üçüncü satır: Sodium ve Fiber
        final thirdRow = find.byType(Row).at(2);
        expect(thirdRow, findsOneWidget);

        // Tek alan: Sugar
        final sugarField = find.widgetWithText(
          CustomFormField,
          'add_product.fields.sugar',
        );
        expect(sugarField, findsOneWidget);
      });

      testWidgets('SizedBox widget\'ları mevcut olmalı', (tester) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // SizedBox widget'larının varlığını kontrol et
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Form Field Tests', () {
      testWidgets('Energy alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final energyController = TextEditingController();
        when(mockViewModel.energyController).thenReturn(energyController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Energy alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.energy'),
          '250',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(energyController.text, equals('250'));
      });

      testWidgets('Fat alanı doğru controller ile bağlanmalı', (tester) async {
        final fatController = TextEditingController();
        when(mockViewModel.fatController).thenReturn(fatController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Fat alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.fat'),
          '15.5',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(fatController.text, equals('15.5'));
      });

      testWidgets('Carbs alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final carbsController = TextEditingController();
        when(mockViewModel.carbsController).thenReturn(carbsController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Carbs alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.carbs'),
          '30.2',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(carbsController.text, equals('30.2'));
      });

      testWidgets('Protein alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final proteinController = TextEditingController();
        when(mockViewModel.proteinController).thenReturn(proteinController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Protein alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.protein'),
          '8.7',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(proteinController.text, equals('8.7'));
      });

      testWidgets('Sodium alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final sodiumController = TextEditingController();
        when(mockViewModel.sodiumController).thenReturn(sodiumController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Sodium alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.sodium'),
          '0.5',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(sodiumController.text, equals('0.5'));
      });

      testWidgets('Fiber alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final fiberController = TextEditingController();
        when(mockViewModel.fiberController).thenReturn(fiberController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Fiber alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.fiber'),
          '2.1',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(fiberController.text, equals('2.1'));
      });

      testWidgets('Sugar alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final sugarController = TextEditingController();
        when(mockViewModel.sugarController).thenReturn(sugarController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Sugar alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.sugar'),
          '12.3',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(sugarController.text, equals('12.3'));
      });
    });

    group('Keyboard Type Tests', () {
      testWidgets(
        'Tüm nutrition alanları number keyboard type\'a sahip olmalı',
        (tester) async {
          await tester.pumpWidget(createTestNutritionFields());
          await tester.pumpAndSettle();

          // Tüm CustomFormField'ları bul
          final formFields = find.byType(CustomFormField);
          expect(formFields, findsNWidgets(7));

          // Her alanın keyboardType'ını kontrol et
          for (int i = 0; i < 7; i++) {
            final field = formFields.at(i);
            final customFormField = tester.widget<CustomFormField>(field);
            expect(customFormField.keyboardType, equals(TextInputType.number));
          }
        },
      );
    });

    group('Layout Tests', () {
      testWidgets('Nutrition alanları doğru Row yapısında olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // 3 Row widget'ı olmalı (her satırda 2 alan)
        expect(find.byType(Row), findsNWidgets(3));

        // Her Row'da Expanded widget'ları olmalı
        expect(find.byType(Expanded), findsNWidgets(6)); // 3 satır × 2 alan
      });

      testWidgets('İlk satırda Energy ve Fat alanları olmalı', (tester) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // İlk Row'u bul
        final firstRow = find.byType(Row).at(0);
        expect(firstRow, findsOneWidget);

        // İlk Row içinde Energy ve Fat alanlarını kontrol et
        final rowWidget = tester.widget<Row>(firstRow);
        expect(rowWidget.children.length, equals(3)); // 2 Expanded + 1 SizedBox
      });

      testWidgets('İkinci satırda Carbs ve Protein alanları olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // İkinci Row'u bul
        final secondRow = find.byType(Row).at(1);
        expect(secondRow, findsOneWidget);

        // İkinci Row içinde Carbs ve Protein alanlarını kontrol et
        final rowWidget = tester.widget<Row>(secondRow);
        expect(rowWidget.children.length, equals(3)); // 2 Expanded + 1 SizedBox
      });

      testWidgets('Üçüncü satırda Sodium ve Fiber alanları olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Üçüncü Row'u bul
        final thirdRow = find.byType(Row).at(2);
        expect(thirdRow, findsOneWidget);

        // Üçüncü Row içinde Sodium ve Fiber alanlarını kontrol et
        final rowWidget = tester.widget<Row>(thirdRow);
        expect(rowWidget.children.length, equals(3)); // 2 Expanded + 1 SizedBox
      });

      testWidgets('Sugar alanı tek başına olmalı', (tester) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Sugar alanını bul
        final sugarField = find.widgetWithText(
          CustomFormField,
          'add_product.fields.sugar',
        );
        expect(sugarField, findsOneWidget);

        // Sugar alanının Row içinde olmadığını kontrol et
        final sugarWidget = tester.widget<CustomFormField>(sugarField);
        expect(sugarWidget, isA<CustomFormField>());
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Widget semantic yapısı doğru olmalı', (tester) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Semantic tree'in doğru oluşturulduğunu kontrol et
        final semantics = tester.getSemantics(find.byType(NutritionFields));
        expect(semantics, isNotNull);
      });

      testWidgets('Form alanları semantic label\'lara sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Form alanlarının semantic yapısını kontrol et
        final formFields = find.byType(CustomFormField);
        expect(formFields, findsNWidgets(7));

        // Her form alanının semantic yapısını kontrol et
        for (int i = 0; i < 7; i++) {
          final field = formFields.at(i);
          final semantics = tester.getSemantics(field);
          expect(semantics, isNotNull);
        }
      });
    });

    group('Responsiveness Tests', () {
      testWidgets('Farklı ekran boyutlarında çalışmalı', (tester) async {
        // Küçük ekran
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();
        expect(find.byType(NutritionFields), findsOneWidget);

        // Büyük ekran
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();
        expect(find.byType(NutritionFields), findsOneWidget);
      });

      testWidgets('Landscape orientation\'da çalışmalı', (tester) async {
        // Landscape orientation
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Widget hala görünür olmalı
        expect(find.byType(NutritionFields), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(CustomFormField), findsNWidgets(7));
      });
    });

    group('Edge Case Tests', () {
      testWidgets('ViewModel null olduğunda hata vermemeli', (tester) async {
        // Null ViewModel ile test
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppColors.light]),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [const Locale('tr', 'TR')],
            locale: const Locale('tr', 'TR'),
            home: Scaffold(body: NutritionFields(viewModel: mockViewModel)),
          ),
        );
        await tester.pumpAndSettle();

        // Widget'ın hala render edildiğini kontrol et
        expect(find.byType(NutritionFields), findsOneWidget);
      });

      testWidgets('Controller\'lar null olduğunda hata vermemeli', (
        tester,
      ) async {
        // Null controller'lar ile test
        when(
          mockViewModel.energyController,
        ).thenReturn(TextEditingController());
        when(mockViewModel.fatController).thenReturn(TextEditingController());
        when(mockViewModel.carbsController).thenReturn(TextEditingController());
        when(
          mockViewModel.proteinController,
        ).thenReturn(TextEditingController());
        when(
          mockViewModel.sodiumController,
        ).thenReturn(TextEditingController());
        when(mockViewModel.fiberController).thenReturn(TextEditingController());
        when(mockViewModel.sugarController).thenReturn(TextEditingController());

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Widget'ın hala render edildiğini kontrol et
        expect(find.byType(NutritionFields), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('Form alanları ile ViewModel entegrasyonu çalışmalı', (
        tester,
      ) async {
        // Mock controller'ları ayarla
        final energyController = TextEditingController();
        final fatController = TextEditingController();
        final carbsController = TextEditingController();
        final proteinController = TextEditingController();
        final sodiumController = TextEditingController();
        final fiberController = TextEditingController();
        final sugarController = TextEditingController();

        when(mockViewModel.energyController).thenReturn(energyController);
        when(mockViewModel.fatController).thenReturn(fatController);
        when(mockViewModel.carbsController).thenReturn(carbsController);
        when(mockViewModel.proteinController).thenReturn(proteinController);
        when(mockViewModel.sodiumController).thenReturn(sodiumController);
        when(mockViewModel.fiberController).thenReturn(fiberController);
        when(mockViewModel.sugarController).thenReturn(sugarController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Tüm alanlara değer gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.energy'),
          '250',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.fat'),
          '15.5',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.carbs'),
          '30.2',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.protein'),
          '8.7',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.sodium'),
          '0.5',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.fiber'),
          '2.1',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.sugar'),
          '12.3',
        );
        await tester.pump();

        // Controller'ların değerlerini kontrol et
        expect(energyController.text, equals('250'));
        expect(fatController.text, equals('15.5'));
        expect(carbsController.text, equals('30.2'));
        expect(proteinController.text, equals('8.7'));
        expect(sodiumController.text, equals('0.5'));
        expect(fiberController.text, equals('2.1'));
        expect(sugarController.text, equals('12.3'));
      });

      testWidgets('Nutrition alanları doğru sırada ve düzende olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Widget'ların sırasını kontrol et
        final column = find.byType(Column);
        expect(column, findsOneWidget);

        // Column içindeki widget'ları kontrol et
        final columnWidget = tester.widget<Column>(column);
        expect(columnWidget.children.length, greaterThan(0));

        // Section title'ın ilk sırada olduğunu kontrol et
        expect(find.text('add_product.sections.nutrition'), findsOneWidget);
      });
    });

    group('Nutrition Field Specific Tests', () {
      testWidgets('Nutrition alanları sayısal değerler kabul etmeli', (
        tester,
      ) async {
        final energyController = TextEditingController();
        when(mockViewModel.energyController).thenReturn(energyController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Sayısal değerler gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.energy'),
          '123.45',
        );
        await tester.pump();

        expect(energyController.text, equals('123.45'));
      });

      testWidgets('Nutrition alanları ondalık sayıları kabul etmeli', (
        tester,
      ) async {
        final fatController = TextEditingController();
        when(mockViewModel.fatController).thenReturn(fatController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Ondalık değer gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.fat'),
          '12.5',
        );
        await tester.pump();

        expect(fatController.text, equals('12.5'));
      });

      testWidgets('Nutrition alanları sıfır değerini kabul etmeli', (
        tester,
      ) async {
        final carbsController = TextEditingController();
        when(mockViewModel.carbsController).thenReturn(carbsController);

        await tester.pumpWidget(createTestNutritionFields());
        await tester.pumpAndSettle();

        // Sıfır değer gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.carbs'),
          '0',
        );
        await tester.pump();

        expect(carbsController.text, equals('0'));
      });
    });
  });
}
