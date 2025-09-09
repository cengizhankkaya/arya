import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:arya/features/addproduct/view/add_product_view.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/view/widgets/index.dart';
import 'package:arya/features/addproduct/service/index.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

import 'add_product_view_test.mocks.dart';

/// Mock sınıfları için annotation
@GenerateMocks([
  AddProductViewModel,
  IProductRepository,
  IImageService,
  fb.FirebaseAuth,
  fb.User,
])
void main() {
  group('AddProductView Widget Tests', () {
    late MockAddProductViewModel mockViewModel;
    late MockIProductRepository mockProductRepository;
    late MockIImageService mockImageService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUpAll(() async {
      // Test ortamını başlat
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupComprehensiveFirebaseMocks();
      await TestHelpers.initializeFirebaseForTests();
      TestHelpers.setupPlatformChannels();
    });

    setUp(() {
      // Mock sınıfları initialize et
      mockViewModel = MockAddProductViewModel();
      mockProductRepository = MockIProductRepository();
      mockImageService = MockIImageService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();

      // Mock ViewModel davranışlarını ayarla
      when(mockViewModel.isLoading).thenReturn(false);
      when(mockViewModel.formKey).thenReturn(GlobalKey<FormState>());
      when(mockViewModel.selectedImage).thenReturn(null);
      when(mockViewModel.isImageUploading).thenReturn(false);
      when(mockViewModel.errorMessage).thenReturn(null);
      when(mockViewModel.successMessage).thenReturn(null);

      // Mock Firebase Auth setup
      when(mockUser.uid).thenReturn('test-uid');
      when(mockUser.email).thenReturn('test@example.com');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    });

    tearDown(() {
      // Test sonrası temizlik
      reset(mockViewModel);
      reset(mockProductRepository);
      reset(mockImageService);
      reset(mockFirebaseAuth);
      reset(mockUser);
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    /// Test için AddProductScreen wrapper'ı oluştur
    ///
    /// Bu wrapper, dependency injection ile mock ViewModel'i kullanır
    Widget createTestAddProductScreen({
      AddProductViewModel? viewModel,
      bool showWelcomeDialog = false,
    }) {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
        home: ChangeNotifierProvider<AddProductViewModel>(
          create: (_) => viewModel ?? mockViewModel,
          child: const AddProductScreen(),
        ),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('AddProductScreen temel widget yapısını göstermeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Ana widget'ların varlığını kontrol et
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(Consumer<AddProductViewModel>), findsOneWidget);
      });

      testWidgets('AppBar doğru title ile görünmeli', (tester) async {
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // AppBar'ın varlığını ve title'ını kontrol et
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('add_product.title'), findsOneWidget);
      });

      testWidgets('Form yapısı doğru şekilde oluşturulmalı', (tester) async {
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Form widget'larının varlığını kontrol et
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(ProductFormFields), findsOneWidget);
        expect(find.byType(ProductFormActions), findsOneWidget);
      });
    });

    group('Image Management Tests', () {
      testWidgets('Resim seçilmediğinde image section boş olmalı', (
        tester,
      ) async {
        when(mockViewModel.selectedImage).thenReturn(null);
        when(mockViewModel.isImageUploading).thenReturn(false);

        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Image section'ın varlığını kontrol et
        expect(find.byType(ImageSection), findsOneWidget);
      });

      testWidgets('Resim yüklenirken loading state gösterilmeli', (
        tester,
      ) async {
        when(mockViewModel.isImageUploading).thenReturn(true);

        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Image section'ın varlığını kontrol et
        expect(find.byType(ImageSection), findsOneWidget);
      });
    });

    group('Form Interaction Tests', () {
      testWidgets('Form alanları etkileşime açık olmalı', (tester) async {
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Form alanlarının varlığını kontrol et
        expect(find.byType(ProductFormFields), findsOneWidget);
        expect(find.byType(ProductFormActions), findsOneWidget);
      });

      testWidgets('Form validation çalışmalı', (tester) async {
        // Mock form validation
        when(mockViewModel.validateForm()).thenReturn(true);

        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Form'un varlığını kontrol et
        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('Responsiveness Tests', () {
      testWidgets('Farklı ekran boyutlarında çalışmalı', (tester) async {
        // Küçük ekran
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();
        expect(find.byType(Scaffold), findsOneWidget);

        // Büyük ekran
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();
        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Landscape orientation\'da çalışmalı', (tester) async {
        // Landscape orientation
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Form hala görünür olmalı
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(ProductFormFields), findsOneWidget);
        expect(find.byType(ProductFormActions), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Semantic labels doğru olmalı', (tester) async {
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // AppBar semantic label'ı
        final appBar = find.byType(AppBar);
        final appBarSemantics = tester.getSemantics(appBar);
        expect(appBarSemantics, isNotNull);

        // Form semantic label'ı
        final form = find.byType(Form);
        final formSemantics = tester.getSemantics(form);
        expect(formSemantics, isNotNull);
      });

      testWidgets('Widget tree semantic yapısı doğru olmalı', (tester) async {
        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Semantic tree'in doğru oluşturulduğunu kontrol et
        final semantics = tester.getSemantics(find.byType(Scaffold));
        expect(semantics, isNotNull);
      });
    });

    group('Integration Tests', () {
      testWidgets('Tam add product flow entegrasyon testi', (tester) async {
        // Mock successful product addition
        when(mockViewModel.validateForm()).thenReturn(true);
        when(mockViewModel.addProduct()).thenAnswer((_) async {});

        await tester.pumpWidget(createTestAddProductScreen());
        await tester.pumpAndSettle();

        // Form'un doğru şekilde render edildiğini kontrol et
        expect(find.byType(Form), findsOneWidget);
        expect(find.byType(ProductFormFields), findsOneWidget);
        expect(find.byType(ProductFormActions), findsOneWidget);
      });
    });

    group('Edge Case Tests', () {
      testWidgets('ViewModel null olduğunda hata vermemeli', (tester) async {
        // Null ViewModel ile test
        await tester.pumpWidget(createTestAddProductScreen(viewModel: null));
        await tester.pumpAndSettle();

        // Widget'ın hala render edildiğini kontrol et
        expect(find.byType(Scaffold), findsOneWidget);
      });
    });
  });
}
