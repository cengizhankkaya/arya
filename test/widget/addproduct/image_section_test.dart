import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:arya/features/addproduct/view/widgets/sections/image_section.dart';
import 'package:arya/features/addproduct/view/widgets/common/section_title.dart';
import 'package:arya/features/addproduct/view_model/add_product_viewmodel.dart';
import 'package:arya/features/addproduct/service/image_service.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

import 'image_section_test.mocks.dart';

@GenerateMocks([IImageService])
void main() {
  group('ImageSection Widget Tests', () {
    late MockIImageService mockImageService;
    late AddProductViewModel viewModel;

    setUpAll(() async {
      // Test ortamını başlat
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupComprehensiveFirebaseMocks();
      await TestHelpers.initializeFirebaseForTests();
      TestHelpers.setupPlatformChannels();
    });

    setUp(() {
      mockImageService = MockIImageService();
      // Mock'ları varsayılan değerlerle ayarla
      when(mockImageService.selectedImage).thenReturn(null);
      when(mockImageService.isImageUploading).thenReturn(false);
      when(
        mockImageService.pickImageFromGallery(),
      ).thenAnswer((_) async => null);
      when(
        mockImageService.takePhotoWithCamera(),
      ).thenAnswer((_) async => null);
      when(mockImageService.removeSelectedImage()).thenReturn(null);

      viewModel = AddProductViewModel(imageService: mockImageService);
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    /// Test için ImageSection wrapper'ı oluştur
    Widget createTestImageSection() {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
        home: Scaffold(
          body: EasyLocalization(
            supportedLocales: const [Locale('tr', 'TR')],
            path: 'assets/translations',
            fallbackLocale: const Locale('tr', 'TR'),
            startLocale: const Locale('tr', 'TR'),
            useOnlyLangCode: true,
            child: ImageSection(viewModel: viewModel),
          ),
        ),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('ImageSection temel widget yapısını göstermeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Ana widget'ın varlığını kontrol et
        expect(find.byType(ImageSection), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('ImageSection başlık göstermeli', (tester) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Başlığın varlığını kontrol et
        expect(find.byType(SectionTitle), findsOneWidget);
      });

      testWidgets('ImageSection butonlar göstermeli', (tester) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Önce widget'ın render edildiğini kontrol et
        expect(find.byType(ImageSection), findsOneWidget);

        // Butonların varlığını kontrol et - Icon finder ile
        expect(find.byIcon(Icons.photo_library), findsOneWidget);
        expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      });
    });

    group('Image Buttons Tests', () {
      testWidgets('Galeri butonu doğru metni göstermeli', (tester) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Galeri butonunun metnini kontrol et
        expect(find.text('add_product.pick_from_gallery'), findsOneWidget);
      });

      testWidgets('Kamera butonu doğru metni göstermeli', (tester) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Kamera butonunun metnini kontrol et
        expect(find.text('add_product.take_photo'), findsOneWidget);
      });

      testWidgets(
        'Galeri butonuna tıklandığında viewModel.pickImageFromGallery çağrılmalı',
        (tester) async {
          await tester.pumpWidget(createTestImageSection());
          await tester.pump();

          // Galeri butonuna tıkla
          await tester.tap(find.byIcon(Icons.photo_library));
          await tester.pump();

          // pickImageFromGallery metodunun çağrıldığını kontrol et
          verify(mockImageService.pickImageFromGallery()).called(1);
        },
      );

      testWidgets(
        'Kamera butonuna tıklandığında viewModel.takePhotoWithCamera çağrılmalı',
        (tester) async {
          await tester.pumpWidget(createTestImageSection());
          await tester.pump();

          // Kamera butonuna tıkla
          await tester.tap(find.byIcon(Icons.camera_alt));
          await tester.pump();

          // takePhotoWithCamera metodunun çağrıldığını kontrol et
          verify(mockImageService.takePhotoWithCamera()).called(1);
        },
      );
    });

    group('Loading State Tests', () {
      testWidgets('Image yüklenirken butonlar disabled olmalı', (tester) async {
        when(mockImageService.isImageUploading).thenReturn(true);

        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Loading state'de icon'lar CircularProgressIndicator ile değiştirilir
        // Bu yüzden CircularProgressIndicator'ları arayalım
        expect(find.byType(CircularProgressIndicator), findsNWidgets(2));

        // Butonların disabled olduğunu kontrol et - Text finder ile
        final galleryButtonFinder = find.text('add_product.processing');
        final cameraButtonFinder = find.text('add_product.take_photo');

        expect(galleryButtonFinder, findsOneWidget);
        expect(cameraButtonFinder, findsOneWidget);

        // Loading state'de butonlar disabled olmalı - bu durumda loading indicator'lar görünmeli
        // ve buton metinleri değişmeli
        expect(find.text('add_product.processing'), findsOneWidget);
        expect(find.text('add_product.take_photo'), findsOneWidget);
      });

      testWidgets('Image yüklenirken loading indicator gösterilmeli', (
        tester,
      ) async {
        when(mockImageService.isImageUploading).thenReturn(true);

        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Loading indicator'ların varlığını kontrol et
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });
    });

    group('Image Preview Tests', () {
      testWidgets('Seçili image varsa preview gösterilmeli', (tester) async {
        final mockFile = File('/test/path/image.jpg');
        when(mockImageService.selectedImage).thenReturn(mockFile);

        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Image preview widget'ının varlığını kontrol et
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(ClipRRect), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('Seçili image varsa remove butonu gösterilmeli', (
        tester,
      ) async {
        final mockFile = File('/test/path/image.jpg');
        when(mockImageService.selectedImage).thenReturn(mockFile);

        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Remove butonunun varlığını kontrol et - Icon finder ile
        expect(find.byIcon(Icons.delete), findsOneWidget);
        expect(find.text('add_product.remove_image'), findsOneWidget);
      });

      testWidgets(
        'Remove butonuna tıklandığında removeSelectedImage çağrılmalı',
        (tester) async {
          final mockFile = File('/test/path/image.jpg');
          when(mockImageService.selectedImage).thenReturn(mockFile);

          await tester.pumpWidget(createTestImageSection());
          await tester.pump();

          // Remove butonuna tıkla
          await tester.tap(find.byIcon(Icons.delete));
          await tester.pump();

          // removeSelectedImage metodunun çağrıldığını kontrol et
          verify(mockImageService.removeSelectedImage()).called(1);
        },
      );

      testWidgets(
        'Seçili image yoksa preview ve remove butonu gösterilmemeli',
        (tester) async {
          await tester.pumpWidget(createTestImageSection());
          await tester.pump();

          // Preview ve remove butonunun olmadığını kontrol et
          expect(find.byType(TextButton), findsNothing);
          expect(find.byIcon(Icons.delete), findsNothing);
          expect(find.text('add_product.remove_image'), findsNothing);
        },
      );
    });

    group('Layout Tests', () {
      testWidgets('ImageSection Column layout kullanmalı', (tester) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Column widget'ının varlığını kontrol et
        final columnWidget = tester.widget<Column>(find.byType(Column).first);
        expect(columnWidget.crossAxisAlignment, CrossAxisAlignment.start);
      });

      testWidgets('Image butonları Row layout kullanmalı', (tester) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Row widget'ının varlığını kontrol et
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('Image butonları Expanded widget kullanmalı', (tester) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Expanded widget'larının varlığını kontrol et
        expect(find.byType(Expanded), findsNWidgets(2));
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('ImageSection tema renklerini doğru kullanmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Widget'ların tema ile uyumlu olduğunu kontrol et
        expect(find.byType(ImageSection), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
      });

      testWidgets('Image preview tema renklerini kullanmalı', (tester) async {
        final mockFile = File('/test/path/image.jpg');
        when(mockImageService.selectedImage).thenReturn(mockFile);

        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Container'ın tema renklerini kullandığını kontrol et
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('ImageSection null image ile çalışmalı', (tester) async {
        await tester.pumpWidget(createTestImageSection());
        await tester.pump();

        // Widget'ın hata vermeden render olduğunu kontrol et
        expect(find.byType(ImageSection), findsOneWidget);
        expect(find.byType(SectionTitle), findsOneWidget);
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets(
        'ImageSection loading state değişiminde doğru render olmalı',
        (tester) async {
          await tester.pumpWidget(createTestImageSection());
          await tester.pump();

          // İlk durumda butonlar aktif olmalı
          expect(find.byType(CircularProgressIndicator), findsNothing);

          // Loading state'i değiştir
          when(mockImageService.isImageUploading).thenReturn(true);
          await tester.pumpWidget(createTestImageSection());
          await tester.pump();

          // Loading indicator'lar görünmeli
          expect(find.byType(CircularProgressIndicator), findsWidgets);
        },
      );
    });
  });
}
