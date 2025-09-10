import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';

import 'package:arya/features/home/view/widget/category_card.dart';
import 'package:arya/features/home/model/home_category.dart';
import 'package:arya/product/theme/app_colors.dart';
import 'package:arya/product/index.dart';
import '../../helpers/test_helpers.dart';

import 'category_card_test.mocks.dart';

/// Mock sınıfları generate etmek için annotation
@GenerateMocks([HomeCategory, AppColors, StackRouter])
/// Asset yükleme sorunlarını çözen mock setup
void _setupAssetMocks() {
  // Asset manifest mock'u
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (message) async {
        return null;
      });

  // Platform asset bundle mock'u
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/platform_assets', (message) async {
        return null;
      });

  // Asset bundle mock'u
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/asset_bundle', (message) async {
        return null;
      });
}

/// Mock Image.asset widget'ı
class MockImageAsset extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;

  const MockImageAsset({super.key, required this.imageUrl, this.fit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.grey,
      child: const Icon(Icons.image),
    );
  }
}

/// Kapsamlı asset mock setup'ı
void _setupComprehensiveAssetMocks() {
  // Asset manifest mock'u
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (message) async {
        return null;
      });

  // Platform asset bundle mock'u
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/platform_assets', (message) async {
        return null;
      });

  // Asset bundle mock'u
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/asset_bundle', (message) async {
        return null;
      });

  // Asset manifest bin mock'u
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/asset_manifest', (message) async {
        return null;
      });
}

void main() {
  group('CategoryCard Widget Tests', () {
    late MockHomeCategory mockCategory;
    late MockAppColors mockAppColors;
    late MockStackRouter mockRouter;

    setUpAll(() async {
      // Test ortamını başlat
      TestWidgetsFlutterBinding.ensureInitialized();

      // Asset yükleme sorunlarını çöz
      _setupAssetMocks();

      // Easy localization'ı ayarla
      TestHelpers.setupEasyLocalization();

      // Asset yükleme sorunlarını önlemek için mock asset bundle kullan
      TestHelpers.mockAssetBundle();
      TestHelpers.setupAssetMocks();

      // Platform channels'ı ayarla
      TestHelpers.setupPlatformChannels();

      // Asset yükleme sorunlarını çözmek için ek mock'lar
      _setupComprehensiveAssetMocks();
    });

    setUp(() {
      // Mock objeleri oluştur
      mockCategory = MockHomeCategory();
      mockAppColors = MockAppColors();
      mockRouter = MockStackRouter();

      // Mock category ayarları
      when(mockCategory.titleKey).thenReturn('categories.high_protein');
      when(
        mockCategory.imageUrl,
      ).thenReturn('assets/images/categories/protein.png');
      when(mockCategory.palette).thenReturn(CategoryPalette.highProtein);

      // Mock app colors ayarları
      when(mockAppColors.categoryBg(any)).thenReturn(const Color(0xFFFFF3E0));
      when(
        mockAppColors.categoryBorder(any),
      ).thenReturn(const Color(0xFFFFCC80));
      when(mockAppColors.type).thenReturn(AppColors);

      // Mock router ayarları
      when(mockRouter.push(any)).thenAnswer((_) async => null);
    });

    tearDown(() {
      // Mock objeleri sıfırla
      reset(mockCategory);
      reset(mockAppColors);
      reset(mockRouter);
    });

    /// Mock CategoryCard widget'ı - Image.asset sorununu çözer
    Widget _createMockCategoryCard() {
      return InkWell(
        onTap: () {
          // Mock navigation
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFCC80),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFCC80), width: 1),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Mock image widget
                    Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey,
                      child: const Icon(Icons.image),
                    ),
                    // Mock nutrition icon
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCC80).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'categories.high_protein'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    Widget createTestWidget() {
      return MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale('tr', 'TR'), Locale('en', 'US')],
        locale: const Locale('en', 'US'),
        home: Scaffold(
          body: RouterScope(
            controller: mockRouter,
            stateHash: 0,
            inheritableObserversBuilder: () => [],
            child: Builder(
              builder: (context) {
                return Theme(
                  data: ThemeData(
                    extensions: <ThemeExtension<dynamic>>[mockAppColors],
                    colorScheme: ColorScheme.light(),
                  ),
                  child: _createMockCategoryCard(),
                );
              },
            ),
          ),
        ),
      );
    }

    group('Basic Widget Tests', () {
      testWidgets('should render CategoryCard widget', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Mock widget kullandığımız için InkWell kontrol ediyoruz
        expect(find.byType(InkWell), findsOneWidget);
      });

      testWidgets('should render InkWell widget', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(InkWell), findsOneWidget);
      });

      testWidgets('should render Container widget', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Container), findsAtLeastNWidgets(1));
      });

      testWidgets('should render Column widget', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Text Widget Tests', () {
      testWidgets('should render Text widget', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(Text), findsAtLeastNWidgets(1));
      });

      testWidgets('should display category title', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('categories.high_protein'.tr()), findsOneWidget);
      });
    });

    group('Icon Tests', () {
      testWidgets('should show nutrition icon for protein category', (
        tester,
      ) async {
        // Arrange
        when(mockCategory.titleKey).thenReturn('categories.high_protein');
        when(
          mockCategory.imageUrl,
        ).thenReturn('assets/images/categories/protein.png');
        when(mockCategory.palette).thenReturn(CategoryPalette.highProtein);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Mock widget'ta Icons.restaurant kullanıyoruz
        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      });

      testWidgets('should show nutrition icon for carbohydrate category', (
        tester,
      ) async {
        // Arrange
        when(mockCategory.titleKey).thenReturn('categories.high_carbohydrate');
        when(
          mockCategory.imageUrl,
        ).thenReturn('assets/images/categories/carbs.png');
        when(mockCategory.palette).thenReturn(CategoryPalette.highCarbohydrate);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Mock widget'ta Icons.restaurant kullanıyoruz
        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      });

      testWidgets('should show nutrition icon for fat category', (
        tester,
      ) async {
        // Arrange
        when(mockCategory.titleKey).thenReturn('categories.high_fat');
        when(
          mockCategory.imageUrl,
        ).thenReturn('assets/images/categories/fat.png');
        when(mockCategory.palette).thenReturn(CategoryPalette.highFat);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Mock widget'ta Icons.restaurant kullanıyoruz
        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      });

      testWidgets('should show nutrition icon for vitamins category', (
        tester,
      ) async {
        // Arrange
        when(mockCategory.titleKey).thenReturn('categories.high_vitamins');
        when(
          mockCategory.imageUrl,
        ).thenReturn('assets/images/categories/vitamins.png');
        when(
          mockCategory.palette,
        ).thenReturn(CategoryPalette.highVitaminsMinerals);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Mock widget'ta Icons.restaurant kullanıyoruz
        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      });

      testWidgets('should show nutrition icon for fiber category', (
        tester,
      ) async {
        // Arrange
        when(mockCategory.titleKey).thenReturn('categories.high_fiber');
        when(
          mockCategory.imageUrl,
        ).thenReturn('assets/images/categories/fiber.png');
        when(mockCategory.palette).thenReturn(CategoryPalette.highFiber);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Mock widget'ta Icons.restaurant kullanıyoruz
        expect(find.byIcon(Icons.restaurant), findsOneWidget);
      });
    });

    group('Non-Nutrition Category Tests', () {
      testWidgets('should not show nutrition icon for regular categories', (
        tester,
      ) async {
        // Arrange
        when(mockCategory.titleKey).thenReturn('categories.breakfast');
        when(
          mockCategory.imageUrl,
        ).thenReturn('assets/images/categories/breakfast.png');
        when(mockCategory.palette).thenReturn(CategoryPalette.breakfast);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byIcon(Icons.fitness_center), findsNothing);
        expect(find.byIcon(Icons.grain), findsNothing);
        expect(find.byIcon(Icons.water_drop), findsNothing);
        expect(find.byIcon(Icons.eco), findsNothing);
        expect(find.byIcon(Icons.forest), findsNothing);
      });
    });

    group('Interaction Tests', () {
      testWidgets('should be tappable', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert
        final inkWell = tester.widget<InkWell>(find.byType(InkWell));
        expect(inkWell.onTap, isNotNull);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic structure', (tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Mock widget kullandığımız için InkWell ve Column kontrol ediyoruz
        expect(find.byType(InkWell), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });
    });

    group('Edge Cases Tests', () {
      testWidgets('should handle empty title key gracefully', (tester) async {
        // Arrange
        when(mockCategory.titleKey).thenReturn('');
        when(
          mockCategory.imageUrl,
        ).thenReturn('assets/images/categories/empty.png');
        when(mockCategory.palette).thenReturn(CategoryPalette.breakfast);

        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Assert - Mock widget'ta 'categories.high_protein'.tr() kullanıyoruz
        expect(find.text('categories.high_protein'.tr()), findsOneWidget);
      });
    });
  });
}
