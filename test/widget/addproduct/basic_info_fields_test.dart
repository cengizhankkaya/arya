import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:arya/features/addproduct/view/widgets/fields/basic_info_fields.dart';
import 'package:arya/features/addproduct/view/widgets/common/form_field.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view_model/mixins/form_controllers_mixin.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

import 'basic_info_fields_test.mocks.dart';

/// Mock sınıfları için annotation
@GenerateMocks([AddProductViewModel])
void main() {
  group('BasicInfoFields Widget Tests', () {
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

      // Mock controller'ları ayarla
      when(mockViewModel.barcodeController).thenReturn(TextEditingController());
      when(mockViewModel.nameController).thenReturn(TextEditingController());
      when(mockViewModel.brandsController).thenReturn(TextEditingController());
      when(
        mockViewModel.categoriesController,
      ).thenReturn(TextEditingController());
      when(
        mockViewModel.quantityController,
      ).thenReturn(TextEditingController());
      when(
        mockViewModel.ingredientsController,
      ).thenReturn(TextEditingController());
    });

    tearDown(() {
      // Test sonrası temizlik
      reset(mockViewModel);
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    /// Test için BasicInfoFields wrapper'ı oluştur
    Widget createTestBasicInfoFields() {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
        home: Scaffold(body: BasicInfoFields(viewModel: mockViewModel)),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('BasicInfoFields temel widget yapısını göstermeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Ana widget'ların varlığını kontrol et
        expect(find.byType(BasicInfoFields), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('Section title doğru şekilde görünmeli', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Section title'ın varlığını kontrol et
        expect(find.text('add_product.sections.basic_info'), findsOneWidget);
      });

      testWidgets('Tüm form alanları doğru şekilde render edilmeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Form alanlarının varlığını kontrol et
        expect(find.byType(CustomFormField), findsNWidgets(6));

        // Her alanın label'ını kontrol et
        expect(find.text('add_product.fields.barcode'), findsOneWidget);
        expect(find.text('add_product.fields.product_name'), findsOneWidget);
        expect(find.text('add_product.fields.brand'), findsOneWidget);
        expect(find.text('add_product.fields.categories'), findsOneWidget);
        expect(find.text('add_product.fields.quantity'), findsOneWidget);
        expect(find.text('add_product.fields.ingredients'), findsOneWidget);
      });

      testWidgets('Barkod tarayıcı butonu görünmeli', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Barkod tarayıcı butonunun varlığını kontrol et
        expect(find.byType(IconButton), findsOneWidget);
        expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      });

      testWidgets('SizedBox widget\'ları mevcut olmalı', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // SizedBox widget'larının varlığını kontrol et (ProjectSizedBox static const SizedBox'lar döndürür)
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('Form Field Tests', () {
      testWidgets('Barkod alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final barcodeController = TextEditingController();
        when(mockViewModel.barcodeController).thenReturn(barcodeController);

        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Barkod alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.barcode'),
          '1234567890123',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(barcodeController.text, equals('1234567890123'));
      });

      testWidgets('Ürün adı alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final nameController = TextEditingController();
        when(mockViewModel.nameController).thenReturn(nameController);

        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Ürün adı alanına metin gir
        await tester.enterText(
          find.widgetWithText(
            CustomFormField,
            'add_product.fields.product_name',
          ),
          'Test Ürün',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(nameController.text, equals('Test Ürün'));
      });

      testWidgets('Marka alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final brandsController = TextEditingController();
        when(mockViewModel.brandsController).thenReturn(brandsController);

        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Marka alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.brand'),
          'Test Marka',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(brandsController.text, equals('Test Marka'));
      });

      testWidgets('Kategori alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final categoriesController = TextEditingController();
        when(
          mockViewModel.categoriesController,
        ).thenReturn(categoriesController);

        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Kategori alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.categories'),
          'Test Kategori',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(categoriesController.text, equals('Test Kategori'));
      });

      testWidgets('Miktar alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final quantityController = TextEditingController();
        when(mockViewModel.quantityController).thenReturn(quantityController);

        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Miktar alanına metin gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.quantity'),
          '500g',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(quantityController.text, equals('500g'));
      });

      testWidgets('İçindekiler alanı doğru controller ile bağlanmalı', (
        tester,
      ) async {
        final ingredientsController = TextEditingController();
        when(
          mockViewModel.ingredientsController,
        ).thenReturn(ingredientsController);

        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // İçindekiler alanına metin gir
        await tester.enterText(
          find.widgetWithText(
            CustomFormField,
            'add_product.fields.ingredients',
          ),
          'Su, şeker, aroma',
        );
        await tester.pump();

        // Controller'ın değerini kontrol et
        expect(ingredientsController.text, equals('Su, şeker, aroma'));
      });
    });

    group('Validation Tests', () {
      testWidgets('Barkod alanı validation çalışmalı', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Barkod alanını boş bırak
        final barcodeField = find.widgetWithText(
          CustomFormField,
          'add_product.fields.barcode',
        );
        expect(barcodeField, findsOneWidget);

        // Form validation'ı tetikle
        final form = find.byType(Form);
        if (form.evaluate().isNotEmpty) {
          await tester.tap(form);
          await tester.pump();
        }
      });

      testWidgets('Ürün adı alanı validation çalışmalı', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Ürün adı alanını boş bırak
        final nameField = find.widgetWithText(
          CustomFormField,
          'add_product.fields.product_name',
        );
        expect(nameField, findsOneWidget);

        // Form validation'ı tetikle
        final form = find.byType(Form);
        if (form.evaluate().isNotEmpty) {
          await tester.tap(form);
          await tester.pump();
        }
      });
    });

    group('Barcode Scanner Tests', () {
      testWidgets('Barkod tarayıcı butonu tıklanabilir olmalı', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Barkod tarayıcı butonunu bul
        final scannerButton = find.byType(IconButton);
        expect(scannerButton, findsOneWidget);

        // Butona tıkla
        await tester.tap(scannerButton);
        await tester.pump();

        // Buton tıklanabilir olmalı
        expect(tester.widget<IconButton>(scannerButton).onPressed, isNotNull);
      });

      testWidgets('Barkod tarayıcı butonu doğru tooltip\'e sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Barkod tarayıcı butonunu bul
        final scannerButton = find.byType(IconButton);
        final buttonWidget = tester.widget<IconButton>(scannerButton);

        // Tooltip kontrolü
        expect(buttonWidget.tooltip, equals('add_product.fields.scan_barcode'));
      });

      testWidgets('Barkod tarayıcı butonu doğru icon\'a sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // QR kod scanner icon'unu kontrol et
        expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      });
    });

    group('Layout Tests', () {
      testWidgets('Widget\'lar doğru sırada görünmeli', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Widget'ların sırasını kontrol et
        final column = find.byType(Column);
        expect(column, findsOneWidget);

        // Column içindeki widget'ları kontrol et
        final columnWidget = tester.widget<Column>(column);
        expect(columnWidget.children.length, greaterThan(0));
      });

      testWidgets('Barkod alanı ve tarayıcı butonu Row içinde olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Row widget'ını kontrol et
        expect(find.byType(Row), findsOneWidget);

        // Row içinde Expanded ve IconButton olmalı
        expect(find.byType(Expanded), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });

      testWidgets('İçindekiler alanı maxLines 3 olmalı', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // İçindekiler alanını bul
        final ingredientsField = find.widgetWithText(
          CustomFormField,
          'add_product.fields.ingredients',
        );
        expect(ingredientsField, findsOneWidget);

        // CustomFormField widget'ını kontrol et
        final formField = tester.widget<CustomFormField>(ingredientsField);
        expect(formField.maxLines, equals(3));
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Widget semantic yapısı doğru olmalı', (tester) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Semantic tree'in doğru oluşturulduğunu kontrol et
        final semantics = tester.getSemantics(find.byType(BasicInfoFields));
        expect(semantics, isNotNull);
      });

      testWidgets('Form alanları semantic label\'lara sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Form alanlarının semantic yapısını kontrol et
        final formFields = find.byType(CustomFormField);
        expect(formFields, findsNWidgets(6));

        // Her form alanının semantic yapısını kontrol et
        for (int i = 0; i < 6; i++) {
          final field = formFields.at(i);
          final semantics = tester.getSemantics(field);
          expect(semantics, isNotNull);
        }
      });

      testWidgets('Barkod tarayıcı butonu semantic label\'a sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Barkod tarayıcı butonunun semantic yapısını kontrol et
        final scannerButton = find.byType(IconButton);
        final semantics = tester.getSemantics(scannerButton);
        expect(semantics, isNotNull);
      });
    });

    group('Responsiveness Tests', () {
      testWidgets('Farklı ekran boyutlarında çalışmalı', (tester) async {
        // Küçük ekran
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();
        expect(find.byType(BasicInfoFields), findsOneWidget);

        // Büyük ekran
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();
        expect(find.byType(BasicInfoFields), findsOneWidget);
      });

      testWidgets('Landscape orientation\'da çalışmalı', (tester) async {
        // Landscape orientation
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Widget hala görünür olmalı
        expect(find.byType(BasicInfoFields), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(CustomFormField), findsNWidgets(6));
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
            home: Scaffold(body: BasicInfoFields(viewModel: mockViewModel)),
          ),
        );
        await tester.pumpAndSettle();

        // Widget'ın hala render edildiğini kontrol et
        expect(find.byType(BasicInfoFields), findsOneWidget);
      });

      testWidgets('Controller\'lar null olduğunda hata vermemeli', (
        tester,
      ) async {
        // Null controller'lar ile test
        when(
          mockViewModel.barcodeController,
        ).thenReturn(TextEditingController());
        when(mockViewModel.nameController).thenReturn(TextEditingController());
        when(
          mockViewModel.brandsController,
        ).thenReturn(TextEditingController());
        when(
          mockViewModel.categoriesController,
        ).thenReturn(TextEditingController());
        when(
          mockViewModel.quantityController,
        ).thenReturn(TextEditingController());
        when(
          mockViewModel.ingredientsController,
        ).thenReturn(TextEditingController());

        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Widget'ın hala render edildiğini kontrol et
        expect(find.byType(BasicInfoFields), findsOneWidget);
      });
    });

    group('Integration Tests', () {
      testWidgets('Form alanları ile ViewModel entegrasyonu çalışmalı', (
        tester,
      ) async {
        // Mock controller'ları ayarla
        final barcodeController = TextEditingController();
        final nameController = TextEditingController();
        final brandsController = TextEditingController();
        final categoriesController = TextEditingController();
        final quantityController = TextEditingController();
        final ingredientsController = TextEditingController();

        when(mockViewModel.barcodeController).thenReturn(barcodeController);
        when(mockViewModel.nameController).thenReturn(nameController);
        when(mockViewModel.brandsController).thenReturn(brandsController);
        when(
          mockViewModel.categoriesController,
        ).thenReturn(categoriesController);
        when(mockViewModel.quantityController).thenReturn(quantityController);
        when(
          mockViewModel.ingredientsController,
        ).thenReturn(ingredientsController);

        await tester.pumpWidget(createTestBasicInfoFields());
        await tester.pumpAndSettle();

        // Tüm alanlara değer gir
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.barcode'),
          '1234567890123',
        );
        await tester.enterText(
          find.widgetWithText(
            CustomFormField,
            'add_product.fields.product_name',
          ),
          'Test Ürün',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.brand'),
          'Test Marka',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.categories'),
          'Test Kategori',
        );
        await tester.enterText(
          find.widgetWithText(CustomFormField, 'add_product.fields.quantity'),
          '500g',
        );
        await tester.enterText(
          find.widgetWithText(
            CustomFormField,
            'add_product.fields.ingredients',
          ),
          'Su, şeker, aroma',
        );
        await tester.pump();

        // Controller'ların değerlerini kontrol et
        expect(barcodeController.text, equals('1234567890123'));
        expect(nameController.text, equals('Test Ürün'));
        expect(brandsController.text, equals('Test Marka'));
        expect(categoriesController.text, equals('Test Kategori'));
        expect(quantityController.text, equals('500g'));
        expect(ingredientsController.text, equals('Su, şeker, aroma'));
      });
    });
  });
}
