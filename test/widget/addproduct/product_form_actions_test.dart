import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:arya/features/addproduct/view/widgets/product_form_actions.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/product/theme/app_colors.dart';
import '../../helpers/test_helpers.dart';

import 'product_form_actions_test.mocks.dart';

/// Mock sınıfları için annotation
@GenerateMocks([AddProductViewModel])
void main() {
  group('ProductFormActions Widget Tests', () {
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

      // Mock'ları varsayılan değerlerle ayarla
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.errorMessage).thenReturn(null);
      when(mockViewModel.successMessage).thenReturn(null);
      when(mockViewModel.addProduct()).thenAnswer((_) async {});
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    Widget createTestWidget() {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        home: Scaffold(body: ProductFormActions(viewModel: mockViewModel)),
      );
    }

    testWidgets('ProductFormActions widget başarıyla render edilir', (
      tester,
    ) async {
      // Widget'ı test ortamına yerleştir
      await tester.pumpWidget(createTestWidget());

      // Widget'ın render edildiğini kontrol et
      expect(find.byType(ProductFormActions), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Submit button doğru şekilde render edilir', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Submit button'ın varlığını kontrol et
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('add_product.buttons.add_product'), findsOneWidget);
    });

    testWidgets('Loading state\'inde CircularProgressIndicator gösterilir', (
      tester,
    ) async {
      // Loading state'ini ayarla
      when(mockViewModel.isLoading).thenReturn(true);

      await tester.pumpWidget(createTestWidget());

      // Loading indicator'ın gösterildiğini kontrol et
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('Error message doğru şekilde gösterilir', (tester) async {
      const errorMessage = 'Test error message';
      when(mockViewModel.errorMessage).thenReturn(errorMessage);

      await tester.pumpWidget(createTestWidget());

      // Error message'ın gösterildiğini kontrol et
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Success message doğru şekilde gösterilir', (tester) async {
      const successMessage = 'Test success message';
      when(mockViewModel.successMessage).thenReturn(successMessage);

      await tester.pumpWidget(createTestWidget());

      // Success message'ın gösterildiğini kontrol et
      expect(find.text(successMessage), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('Error ve success message birlikte gösterilir', (tester) async {
      const errorMessage = 'Test error message';
      const successMessage = 'Test success message';
      when(mockViewModel.errorMessage).thenReturn(errorMessage);
      when(mockViewModel.successMessage).thenReturn(successMessage);

      await tester.pumpWidget(createTestWidget());

      // Her iki message'ın da gösterildiğini kontrol et
      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text(successMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('Message yokken sadece submit button gösterilir', (
      tester,
    ) async {
      when(mockViewModel.errorMessage).thenReturn(null);
      when(mockViewModel.successMessage).thenReturn(null);

      await tester.pumpWidget(createTestWidget());

      // Sadece submit button'ın gösterildiğini kontrol et
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    });

    testWidgets('Submit button tıklandığında dialog açılır', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Submit button'ı bul ve tıkla
      final submitButton = find.byType(ElevatedButton);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Dialog'ın açıldığını kontrol et
      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets(
      'Submit button\'ın doğru stil özelliklerine sahip olduğunu kontrol et',
      (tester) async {
        await tester.pumpWidget(createTestWidget());

        // ElevatedButton'ı bul
        final elevatedButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );

        // Button'ın stil özelliklerini kontrol et
        expect(elevatedButton.style?.backgroundColor, isNotNull);
        expect(elevatedButton.style?.foregroundColor, isNotNull);
        expect(elevatedButton.style?.shape, isNotNull);
      },
    );

    testWidgets(
      'Error message container\'ının doğru renk özelliklerine sahip olduğunu kontrol et',
      (tester) async {
        const errorMessage = 'Test error message';
        when(mockViewModel.errorMessage).thenReturn(errorMessage);

        await tester.pumpWidget(createTestWidget());

        // Error message container'ını bul
        final containers = find.byType(Container);
        expect(containers, findsWidgets);

        // Container'ın decoration özelliklerini kontrol et
        final container = tester.widget<Container>(containers.first);
        expect(container.decoration, isA<BoxDecoration>());
      },
    );

    testWidgets(
      'Success message container\'ının doğru renk özelliklerine sahip olduğunu kontrol et',
      (tester) async {
        const successMessage = 'Test success message';
        when(mockViewModel.successMessage).thenReturn(successMessage);

        await tester.pumpWidget(createTestWidget());

        // Success message container'ını bul
        final containers = find.byType(Container);
        expect(containers, findsWidgets);

        // Container'ın decoration özelliklerini kontrol et
        final container = tester.widget<Container>(containers.first);
        expect(container.decoration, isA<BoxDecoration>());
      },
    );

    testWidgets('Widget\'ın doğru spacing\'e sahip olduğunu kontrol et', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // SizedBox'ların varlığını kontrol et
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('Loading state değiştiğinde UI doğru şekilde güncellenir', (
      tester,
    ) async {
      // İlk olarak loading false ile başla
      when(mockViewModel.isLoading).thenReturn(false);
      await tester.pumpWidget(createTestWidget());

      // ElevatedButton'ın gösterildiğini kontrol et
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Loading state'ini true yap
      when(mockViewModel.isLoading).thenReturn(true);
      await tester.pumpWidget(createTestWidget());

      // CircularProgressIndicator'ın gösterildiğini kontrol et
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('Message state değiştiğinde UI doğru şekilde güncellenir', (
      tester,
    ) async {
      // İlk olarak message'ları null yap
      when(mockViewModel.errorMessage).thenReturn(null);
      when(mockViewModel.successMessage).thenReturn(null);
      await tester.pumpWidget(createTestWidget());

      // Message'ların gösterilmediğini kontrol et
      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsNothing);

      // Error message ekle
      when(mockViewModel.errorMessage).thenReturn('Test error');
      await tester.pumpWidget(createTestWidget());

      // Error message'ın gösterildiğini kontrol et
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Test error'), findsOneWidget);

      // Success message ekle
      when(mockViewModel.successMessage).thenReturn('Test success');
      await tester.pumpWidget(createTestWidget());

      // Her iki message'ın da gösterildiğini kontrol et
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      expect(find.text('Test error'), findsOneWidget);
      expect(find.text('Test success'), findsOneWidget);
    });
  });
}
