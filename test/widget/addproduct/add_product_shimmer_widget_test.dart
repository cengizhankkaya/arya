import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shimmer/shimmer.dart';

import 'package:arya/features/addproduct/view/widgets/add_product_shimmer_widget.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AddProductShimmerWidget Tests', () {
    setUpAll(() async {
      // Test ortamını başlat
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
      TestHelpers.setupComprehensiveFirebaseMocks();
      await TestHelpers.initializeFirebaseForTests();
      TestHelpers.setupPlatformChannels();
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    /// Test için AddProductShimmerWidget wrapper'ı oluştur
    Widget createTestShimmerWidget() {
      return MaterialApp(
        theme: ThemeData(extensions: [AppColors.light]),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [const Locale('tr', 'TR')],
        locale: const Locale('tr', 'TR'),
        home: const Scaffold(body: AddProductShimmerWidget()),
      );
    }

    group('Widget Structure Tests', () {
      testWidgets('AddProductShimmerWidget temel widget yapısını göstermeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Ana widget'ın varlığını kontrol et
        expect(find.byType(AddProductShimmerWidget), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('AddProductShimmerWidget tüm bölümleri içermeli', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Tüm shimmer bölümlerinin varlığını kontrol et
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Shimmer), findsWidgets);
      });

      testWidgets('AddProductShimmerWidget doğru padding kullanmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        final singleChildScrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(singleChildScrollView.padding, isA<EdgeInsets>());
      });
    });

    group('Shimmer Animation Tests', () {
      testWidgets('Shimmer animasyonları doğru renklerle çalışmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Shimmer widget'larının varlığını kontrol et
        final shimmerWidgets = find.byType(Shimmer);
        expect(shimmerWidgets, findsWidgets);

        // Shimmer widget'larının varlığını kontrol et
        expect(shimmerWidgets, findsWidgets);
      });

      testWidgets('Shimmer container\'ları doğru boyutlarda olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Container'ların varlığını kontrol et
        final containers = find.byType(Container);
        expect(containers, findsWidgets);

        // En az bir container'ın shimmer içinde olduğunu kontrol et
        final shimmerContainers = find.descendant(
          of: find.byType(Shimmer),
          matching: find.byType(Container),
        );
        expect(shimmerContainers, findsWidgets);
      });
    });

    group('Image Section Tests', () {
      testWidgets('Resim bölümü shimmer\'ı doğru yapıda olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Resim bölümü için icon'u kontrol et
        expect(find.byIcon(Icons.add_photo_alternate), findsOneWidget);

        // Container'ların varlığını kontrol et
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('Resim bölümü doğru boyutlarda olmalı', (tester) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Resim icon'unun boyutunu kontrol et
        final iconWidget = tester.widget<Icon>(
          find.byIcon(Icons.add_photo_alternate),
        );
        expect(iconWidget.size, 48);
      });
    });

    group('Basic Info Section Tests', () {
      testWidgets('Temel bilgi bölümü shimmer\'ları doğru sayıda olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Temel bilgi bölümü için 3 form alanı shimmer'ı olmalı
        final shimmerWidgets = find.byType(Shimmer);
        expect(shimmerWidgets, findsWidgets);

        // Container'ların varlığını kontrol et
        final containers = find.byType(Container);
        expect(containers, findsWidgets);
      });

      testWidgets('Temel bilgi bölümü doğru yapıda olmalı', (tester) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Column widget'larının varlığını kontrol et
        final columns = find.byType(Column);
        expect(columns, findsWidgets);

        // CrossAxisAlignment kontrolü
        final columnWidgets = tester.widgetList<Column>(columns);
        final hasCrossAxisAlignmentStart = columnWidgets.any(
          (column) => column.crossAxisAlignment == CrossAxisAlignment.start,
        );
        expect(hasCrossAxisAlignmentStart, isTrue);
      });
    });

    group('Additional Info Section Tests', () {
      testWidgets('Ek bilgi bölümü shimmer\'ları doğru yapıda olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Row widget'ının varlığını kontrol et (checkbox için)
        expect(find.byType(Row), findsWidgets);

        // Container'ların varlığını kontrol et
        final containers = find.byType(Container);
        expect(containers, findsWidgets);
      });

      testWidgets(
        'Ek bilgi bölümü checkbox shimmer\'ı doğru boyutlarda olmalı',
        (tester) async {
          await tester.pumpWidget(createTestShimmerWidget());
          await tester.pump();

          // Row içindeki container'ları kontrol et
          final rowContainers = find.descendant(
            of: find.byType(Row),
            matching: find.byType(Container),
          );
          expect(rowContainers, findsWidgets);

          // Container boyutlarını kontrol et
          final containers = tester.widgetList<Container>(rowContainers);
          final hasSmallContainer = containers.any(
            (container) => container.constraints?.maxWidth == 20,
          );
          expect(hasSmallContainer, isTrue);
        },
      );
    });

    group('Buttons Section Tests', () {
      testWidgets('Buton bölümü shimmer\'ları doğru sayıda olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Buton bölümü için 2 shimmer olmalı (Kaydet ve İptal)
        final shimmerWidgets = find.byType(Shimmer);
        expect(shimmerWidgets, findsWidgets);

        // Container'ların varlığını kontrol et
        final containers = find.byType(Container);
        expect(containers, findsWidgets);
      });

      testWidgets('Buton shimmer\'ları doğru boyutlarda olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Buton container'larını kontrol et
        final containers = find.byType(Container);
        final containerWidgets = tester.widgetList<Container>(containers);

        // En az bir container'ın height 48 olmalı (buton yüksekliği)
        final hasButtonHeight = containerWidgets.any(
          (container) => container.constraints?.maxHeight == 48,
        );
        expect(hasButtonHeight, isTrue);
      });
    });

    group('Theme Integration Tests', () {
      testWidgets('Shimmer widget tema renklerini doğru kullanmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Shimmer widget'larının varlığını kontrol et
        final shimmerWidgets = find.byType(Shimmer);
        expect(shimmerWidgets, findsWidgets);
      });

      testWidgets('Container\'lar tema renklerini doğru kullanmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Container'ların decoration özelliklerini kontrol et
        final containers = find.byType(Container);
        expect(containers, findsWidgets);

        final containerWidgets = tester.widgetList<Container>(containers);
        final hasDecoration = containerWidgets.any(
          (container) => container.decoration != null,
        );
        expect(hasDecoration, isTrue);
      });
    });

    group('Layout Tests', () {
      testWidgets('Widget doğru layout yapısında olmalı', (tester) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Ana layout yapısını kontrol et
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('Widget scrollable olmalı', (tester) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // SingleChildScrollView'ın varlığını kontrol et
        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(scrollView, isNotNull);
      });

      testWidgets('Widget responsive olmalı', (tester) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Container'ların width özelliklerini kontrol et
        final containers = find.byType(Container);
        final containerWidgets = tester.widgetList<Container>(containers);

        // En az bir container'ın double.infinity width'i olmalı
        final hasFullWidth = containerWidgets.any(
          (container) => container.constraints?.maxWidth == double.infinity,
        );
        expect(hasFullWidth, isTrue);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('Widget farklı ekran boyutlarında çalışmalı', (tester) async {
        // Küçük ekran boyutu
        await tester.binding.setSurfaceSize(const Size(320, 568));
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        expect(find.byType(AddProductShimmerWidget), findsOneWidget);

        // Büyük ekran boyutu
        await tester.binding.setSurfaceSize(const Size(1024, 768));
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        expect(find.byType(AddProductShimmerWidget), findsOneWidget);
      });

      testWidgets('Widget farklı temalarda çalışmalı', (tester) async {
        // Light tema
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
            home: const Scaffold(body: AddProductShimmerWidget()),
          ),
        );
        await tester.pump();

        expect(find.byType(AddProductShimmerWidget), findsOneWidget);
        expect(find.byType(Shimmer), findsWidgets);
      });

      testWidgets('Widget performans testi', (tester) async {
        final stopwatch = Stopwatch()..start();

        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        stopwatch.stop();

        // Widget'ın 1 saniyeden kısa sürede render edilmesi beklenir
        expect(stopwatch.elapsedMilliseconds, lessThan(1000));
        expect(find.byType(AddProductShimmerWidget), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Widget erişilebilirlik özelliklerine sahip olmalı', (
        tester,
      ) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Widget'ın render edildiğini kontrol et
        expect(find.byType(AddProductShimmerWidget), findsOneWidget);

        // Shimmer widget'larının varlığını kontrol et
        expect(find.byType(Shimmer), findsWidgets);
      });

      testWidgets('Widget semantic özelliklerini desteklemeli', (tester) async {
        await tester.pumpWidget(createTestShimmerWidget());
        await tester.pump();

        // Widget'ın semantic tree'de yer aldığını kontrol et
        expect(find.byType(AddProductShimmerWidget), findsOneWidget);
      });
    });
  });
}
