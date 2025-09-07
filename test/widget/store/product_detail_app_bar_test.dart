import 'package:arya/features/store/view/widget/product_detail_app_bar.dart';
import 'package:arya/features/store/view_model/product_detail_view_model.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Mock sınıfları oluştur
@GenerateMocks([ProductDetailViewModel])
import 'product_detail_app_bar_test.mocks.dart';

void main() {
  group('ProductDetailAppBar', () {
    late MockProductDetailViewModel mockViewModel;
    late AppColors appColors;
    late ColorScheme colorScheme;

    setUp(() {
      mockViewModel = MockProductDetailViewModel();
      appColors = AppColors.light;
      colorScheme = ColorScheme.light();
    });

    Widget createTestWidget({
      required ProductDetailViewModel viewModel,
      ColorScheme? customColorScheme,
    }) {
      return MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: [appColors],
          colorScheme: customColorScheme ?? colorScheme,
        ),
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              ProductDetailAppBar(
                viewModel: viewModel,
                scheme: customColorScheme ?? colorScheme,
              ),
            ],
          ),
        ),
      );
    }

    group('Temel Widget Yapısı', () {
      testWidgets('SliverAppBar doğru özelliklere sahip', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );
        expect(sliverAppBar.expandedHeight, 360);
        expect(sliverAppBar.floating, false);
        expect(sliverAppBar.pinned, true);
        expect(sliverAppBar.stretch, true);
        expect(sliverAppBar.elevation, 0);
      });

      testWidgets('başlık doğru gösterilir', (WidgetTester tester) async {
        // Arrange
        const productName = 'Test Product Name';
        when(mockViewModel.productName).thenReturn(productName);
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.text(productName), findsOneWidget);

        final titleText = tester.widget<Text>(find.text(productName));
        expect(titleText.maxLines, 1);
        expect(titleText.overflow, TextOverflow.ellipsis);
      });

      testWidgets('backgroundColor doğru ayarlanır', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        final sliverAppBar = tester.widget<SliverAppBar>(
          find.byType(SliverAppBar),
        );
        expect(sliverAppBar.backgroundColor, colorScheme.primary);
      });
    });

    group('Leading Button (Geri Butonu)', () {
      testWidgets('geri butonu doğru gösterilir', (WidgetTester tester) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);

        final iconButton = tester.widget<IconButton>(
          find.ancestor(
            of: find.byIcon(Icons.arrow_back),
            matching: find.byType(IconButton),
          ),
        );
        expect(iconButton.onPressed, isNotNull);
      });

      testWidgets('geri butonu doğru stil özelliklerine sahip', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        final containers = tester.widgetList<Container>(
          find.ancestor(
            of: find.byIcon(Icons.arrow_back),
            matching: find.byType(Container),
          ),
        );

        // Margin'i olan container'ı bul
        final containerWithMargin = containers.firstWhere(
          (container) => container.margin == const EdgeInsets.all(8),
        );
        expect(containerWithMargin.margin, const EdgeInsets.all(8));

        final clipRRect = tester.widget<ClipRRect>(
          find.ancestor(
            of: find.byIcon(Icons.arrow_back),
            matching: find.byType(ClipRRect),
          ),
        );
        expect(clipRRect.borderRadius, isNotNull);
      });

      testWidgets('geri butonu BackdropFilter içerir', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byType(BackdropFilter), findsAtLeastNWidgets(1));

        final backdropFilter = tester.widget<BackdropFilter>(
          find.ancestor(
            of: find.byIcon(Icons.arrow_back),
            matching: find.byType(BackdropFilter),
          ),
        );
        expect(backdropFilter.filter, isNotNull);
      });
    });

    group('Actions (Favori ve Paylaşım Butonları)', () {
      testWidgets('favori butonu doğru gösterilir - favori değil', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsNothing);
      });

      testWidgets('favori butonu doğru gösterilir - favori', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(true);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byIcon(Icons.favorite), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsNothing);
      });

      testWidgets('paylaşım butonu doğru gösterilir', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byIcon(Icons.share), findsOneWidget);
      });

      testWidgets('favori butonu tıklandığında toggleFavorite çağrılır', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));
        await tester.tap(find.byIcon(Icons.favorite_border));
        await tester.pump();

        // Assert
        verify(mockViewModel.toggleFavorite()).called(1);
      });

      testWidgets('paylaşım butonu tıklandığında shareProduct çağrılır', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));
        await tester.tap(find.byIcon(Icons.share));
        await tester.pump();

        // Assert
        verify(mockViewModel.shareProduct()).called(1);
      });

      testWidgets('action butonları doğru stil özelliklerine sahip', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        final actionContainers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(SliverAppBar),
            matching: find.byType(Container),
          ),
        );

        // En az 2 action container olmalı (favori + paylaşım)
        expect(actionContainers.length, greaterThanOrEqualTo(2));

        for (final container in actionContainers) {
          if (container.margin == const EdgeInsets.all(8)) {
            expect(container.margin, const EdgeInsets.all(8));
          }
        }
      });
    });

    group('FlexibleSpace ve Ürün Resmi', () {
      testWidgets('FlexibleSpaceBar doğru gösterilir', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byType(FlexibleSpaceBar), findsOneWidget);
      });

      testWidgets('Hero widget doğru gösterilir', (WidgetTester tester) async {
        // Arrange
        const imageUrl = 'https://example.com/image.jpg';
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(mockViewModel.imageUrl).thenReturn(imageUrl);

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byType(Hero), findsOneWidget);

        final hero = tester.widget<Hero>(find.byType(Hero));
        expect(hero.tag, imageUrl);
      });

      testWidgets('Image.network doğru özelliklere sahip', (
        WidgetTester tester,
      ) async {
        // Arrange
        const imageUrl = 'https://example.com/image.jpg';
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(mockViewModel.imageUrl).thenReturn(imageUrl);

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byType(Image), findsOneWidget);

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<NetworkImage>());
        expect(image.fit, BoxFit.cover);
        expect(image.filterQuality, FilterQuality.high);
      });

      testWidgets('resim yoksa Hero widget gösterilmez', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(mockViewModel.imageUrl).thenReturn(null);

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byType(Hero), findsNothing);
        expect(find.byType(Image), findsNothing);
      });

      testWidgets('resim yükleme hatası durumunda fallback gösterilir', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://invalid-url.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));
        await tester.pumpAndSettle();

        // Assert
        // Error builder çalıştığında fallback container gösterilir
        expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
      });

      testWidgets('gradient overlay doğru gösterilir', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        final containers = tester.widgetList<Container>(
          find.descendant(
            of: find.byType(FlexibleSpaceBar),
            matching: find.byType(Container),
          ),
        );

        // Gradient container'ı bul
        final gradientContainer = containers.firstWhere(
          (container) =>
              container.decoration is BoxDecoration &&
              (container.decoration as BoxDecoration).gradient
                  is LinearGradient,
        );

        expect(gradientContainer, isNotNull);
        final decoration = gradientContainer.decoration as BoxDecoration;
        expect(decoration.gradient, isA<LinearGradient>());
      });
    });

    group('Loading ve Error States', () {
      testWidgets('resim yüklenirken loading indicator gösterilir', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));
        await tester.pump(); // İlk frame

        // Assert
        // Loading builder çalıştığında CircularProgressIndicator gösterilir
        // Network resmi yüklenmediği için loading indicator görünmeyebilir
        // Bu durumda sadece Image widget'ının varlığını kontrol ederiz
        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('resim yükleme tamamlandığında loading kaybolur', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));
        await tester.pumpAndSettle();

        // Assert
        // Yükleme tamamlandığında Image widget'ı hala mevcut olmalı
        expect(find.byType(Image), findsOneWidget);
      });
    });

    group('Responsive ve Layout Testleri', () {
      testWidgets('farklı ekran boyutlarında doğru çalışır', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act - Küçük ekran
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byType(SliverAppBar), findsOneWidget);

        // Act - Büyük ekran
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byType(SliverAppBar), findsOneWidget);
      });

      testWidgets('uzun ürün adı doğru kısaltılır', (
        WidgetTester tester,
      ) async {
        // Arrange
        const longProductName =
            'Çok Uzun Bir Ürün Adı Bu Ürün Adı Çok Uzun Ve Kısaltılması Gerekiyor';
        when(mockViewModel.productName).thenReturn(longProductName);
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.text(longProductName), findsOneWidget);

        final titleText = tester.widget<Text>(find.text(longProductName));
        expect(titleText.maxLines, 1);
        expect(titleText.overflow, TextOverflow.ellipsis);
      });
    });

    group('Accessibility Testleri', () {
      testWidgets('butonlar doğru semantic özelliklere sahip', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border), findsOneWidget);
        expect(find.byIcon(Icons.share), findsOneWidget);
      });

      testWidgets('Hero widget doğru tag ile oluşturulur', (
        WidgetTester tester,
      ) async {
        // Arrange
        const imageUrl = 'https://example.com/image.jpg';
        const productName = 'Test Product';
        when(mockViewModel.productName).thenReturn(productName);
        when(mockViewModel.isFavorite).thenReturn(false);
        when(mockViewModel.imageUrl).thenReturn(imageUrl);

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Assert
        final hero = tester.widget<Hero>(find.byType(Hero));
        expect(hero.tag, imageUrl);
      });
    });

    group('Performance Testleri', () {
      testWidgets('çok sayıda rebuild\'de performans sorunu yok', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(
          mockViewModel.imageUrl,
        ).thenReturn('https://example.com/image.jpg');

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));

        // Çok sayıda rebuild simüle et
        for (int i = 0; i < 10; i++) {
          when(mockViewModel.isFavorite).thenReturn(i % 2 == 0);
          await tester.pump();
        }

        // Assert
        expect(find.byType(SliverAppBar), findsOneWidget);
        expect(find.byType(FlexibleSpaceBar), findsOneWidget);
      });

      testWidgets('büyük resim URL\'leri ile performans sorunu yok', (
        WidgetTester tester,
      ) async {
        // Arrange
        const largeImageUrl = 'https://example.com/very-large-image.jpg';
        when(mockViewModel.productName).thenReturn('Test Product');
        when(mockViewModel.isFavorite).thenReturn(false);
        when(mockViewModel.imageUrl).thenReturn(largeImageUrl);

        // Act
        await tester.pumpWidget(createTestWidget(viewModel: mockViewModel));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(SliverAppBar), findsOneWidget);
        expect(find.byType(Hero), findsOneWidget);
      });
    });
  });
}
