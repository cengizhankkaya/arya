# Flutter'da Shimmer Efektleri: Modern Loading State'leri

## Temel Kullanım

```dart
import 'package:shimmer/shimmer.dart';

Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    height: 100,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

## Kategori Kartları Shimmer

```dart
class CategoryShimmerWidget extends StatelessWidget {
  const CategoryShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: ProjectPadding.allSmall(),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        return _buildShimmerCard(context);
      },
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: ProjectRadius.xxLarge,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      padding: ProjectPadding.allVerySmall(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Resim placeholder'ı
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.outline,
              highlightColor: Theme.of(context).colorScheme.outline,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: ProjectRadius.xxLarge,
                ),
              ),
            ),
          ),
          ProjectSizedBox.heightNormal,
          Shimmer.fromColors(
            baseColor: Theme.of(context).colorScheme.outline,
            highlightColor: Theme.of(context).colorScheme.outline,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Ürün Kartları Shimmer

```dart
class ProductShimmerWidget extends StatelessWidget {
  const ProductShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: ProjectPadding.allSmall(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildShimmerCard(context);
      },
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    final appColors = AppColors.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: ProjectRadius.xxLarge,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: ProjectMargin.verySmall.top,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: ProjectPadding.allVerySmall(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Resim placeholder'ı
          Expanded(
            child: Shimmer.fromColors(
              baseColor: appColors.shimmerBase,
              highlightColor: appColors.shimmerHighlight,
              child: Container(
                decoration: BoxDecoration(
                  color: appColors.shimmerBase,
                  borderRadius: ProjectRadius.large,
                ),
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // Ürün adı placeholder'ı
          Shimmer.fromColors(
            baseColor: appColors.shimmerBase,
            highlightColor: appColors.shimmerHighlight,
            child: Container(
              height: ProjectMargin.medium.top,
              width: double.infinity,
              decoration: BoxDecoration(
                color: appColors.shimmerBase,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.small.top),

          // İkinci satır placeholder'ı
          Shimmer.fromColors(
            baseColor: appColors.shimmerBase,
            highlightColor: appColors.shimmerHighlight,
            child: Container(
              height: ProjectMargin.normal.top,
              width: 60,
              decoration: BoxDecoration(
                color: appColors.shimmerBase,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          SizedBox(height: ProjectMargin.verySmall.top),

          // Alt kısım
          Row(
            children: [
              // Marka placeholder'ı
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: appColors.shimmerBase,
                  highlightColor: appColors.shimmerHighlight,
                  child: Container(
                    height: ProjectMargin.normal.top,
                    decoration: BoxDecoration(
                      color: appColors.shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ProjectMargin.small.top),

              // Buton placeholder'ı
              Shimmer.fromColors(
                baseColor: appColors.shimmerBase,
                highlightColor: appColors.shimmerHighlight,
                child: Container(
                  width: ProjectMargin.large.top,
                  height: ProjectMargin.large.top,
                  decoration: BoxDecoration(
                    color: appColors.shimmerBase,
                    borderRadius: ProjectRadius.large,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Profil Shimmer

```dart
class ProfileShimmerWidget extends StatelessWidget {
  const ProfileShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        padding: ProjectPadding.symmetricSmall,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeaderShimmer(context),
            ProjectSizedBox.heightLarge,
            _buildUserInfoShimmer(context),
            ProjectSizedBox.heightLarge,
            _buildProfileCompletionShimmer(context),
            ProjectSizedBox.heightLarge,
            _buildButtonsShimmer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderShimmer(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
          ),
        ),
        ProjectSizedBox.widthMedium,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  height: 24,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
              ProjectSizedBox.heightSmall,
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  height: 16,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.small,
            ),
          ),
        ),
        ProjectSizedBox.heightMedium,
        for (int i = 0; i < 4; i++) ...[
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: Theme.of(context).colorScheme.surface,
                child: Container(
                  height: 16,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
              ProjectSizedBox.widthMedium,
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.surface,
                  highlightColor: Theme.of(context).colorScheme.surface,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (i < 3) ProjectSizedBox.heightNormal,
        ],
      ],
    );
  }

  Widget _buildProfileCompletionShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 20,
            width: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.small,
            ),
          ),
        ),
        ProjectSizedBox.heightNormal,
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.small,
            ),
          ),
        ),
        ProjectSizedBox.heightSmall,
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 16,
            width: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.small,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsShimmer(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.large,
            ),
          ),
        ),
        ProjectSizedBox.heightNormal,
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.surface,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: ProjectRadius.large,
            ),
          ),
        ),
      ],
    );
  }
}
```

## Form Shimmer

```dart
class AddProductShimmerWidget extends StatelessWidget {
  const AddProductShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const ProjectPadding.allSmall(),
      child: Column(
        children: [
          _buildImageSectionShimmer(context),
          ProjectSizedBox.heightXLarge,
          _buildBasicInfoSectionShimmer(context),
          ProjectSizedBox.heightXLarge,
          _buildAdditionalInfoSectionShimmer(context),
          ProjectSizedBox.heightXLarge,
          _buildButtonsShimmer(context),
        ],
      ),
    );
  }

  Widget _buildImageSectionShimmer(BuildContext context) {
    return Container(
      padding: ProjectPadding.allSmall(),
      decoration: BoxDecoration(
        color: AppColors.of(context).cardBackground,
        borderRadius: ProjectRadius.large,
        border: Border.all(color: AppColors.of(context).grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          ProjectSizedBox.heightMedium,

          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.large,
                border: Border.all(
                  color: AppColors.of(context).shimmerBase,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                Icons.add_photo_alternate,
                size: 48,
                color: AppColors.of(context).shimmerBase,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSectionShimmer(BuildContext context) {
    return Container(
      padding: ProjectPadding.allSmall(),
      decoration: BoxDecoration(
        color: AppColors.of(context).cardBackground,
        borderRadius: ProjectRadius.large,
        border: Border.all(color: AppColors.of(context).grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık shimmer
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          ProjectSizedBox.heightMedium,

          // Form alanları shimmer
          for (int i = 0; i < 3; i++) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.of(context).shimmerBase,
                  highlightColor: AppColors.of(context).shimmerHighlight,
                  child: Container(
                    height: 16,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).cardBackground,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
                ProjectSizedBox.heightSmall,

                // Input field shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.of(context).shimmerBase,
                  highlightColor: AppColors.of(context).shimmerHighlight,
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).cardBackground,
                      borderRadius: ProjectRadius.medium,
                      border: Border.all(
                        color: AppColors.of(context).shimmerBase,
                      ),
                    ),
                  ),
                ),
                if (i < 2) ProjectSizedBox.heightMedium,
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSectionShimmer(BuildContext context) {
    return Container(
      padding: ProjectPadding.allSmall(),
      decoration: BoxDecoration(
        color: AppColors.of(context).cardBackground,
        borderRadius: ProjectRadius.large,
        border: Border.all(color: AppColors.of(context).grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık shimmer
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 20,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.small,
              ),
            ),
          ),
          ProjectSizedBox.heightMedium,

          // Text area shimmer
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.of(context).cardBackground,
                borderRadius: ProjectRadius.medium,
                border: Border.all(color: AppColors.of(context).shimmerBase),
              ),
            ),
          ),
          ProjectSizedBox.heightMedium,

          // Checkbox shimmer
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.of(context).shimmerBase,
                highlightColor: AppColors.of(context).shimmerHighlight,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).cardBackground,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
              ProjectSizedBox.widthNormal,
              Shimmer.fromColors(
                baseColor: AppColors.of(context).shimmerBase,
                highlightColor: AppColors.of(context).shimmerHighlight,
                child: Container(
                  height: 16,
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppColors.of(context).cardBackground,
                    borderRadius: ProjectRadius.small,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsShimmer(BuildContext context) {
    return Column(
      children: [
        // Kaydet butonu shimmer
        Shimmer.fromColors(
          baseColor: AppColors.of(context).shimmerBase,
          highlightColor: AppColors.of(context).shimmerHighlight,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.of(context).cardBackground,
              borderRadius: ProjectRadius.medium,
            ),
          ),
        ),
        ProjectSizedBox.heightNormal,

        // İptal butonu shimmer
        Shimmer.fromColors(
          baseColor: AppColors.of(context).shimmerBase,
          highlightColor: AppColors.of(context).shimmerHighlight,
          child: Container(
            height: 48,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.of(context).cardBackground,
              borderRadius: ProjectRadius.medium,
            ),
          ),
        ),
      ],
    );
  }
}
```

## Tema Renkleri

```dart
class AppColors extends ThemeExtension<AppColors> {
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color shimmerBorder;

  const AppColors({
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.shimmerBorder,
  });

  static const AppColors light = AppColors(
    shimmerBase: Color(0xFFE0E0E0),
    shimmerHighlight: Color(0xFFF5F5F5),
    shimmerBorder: Color(0xFFE0E0E0),
  );

  static const AppColors dark = AppColors(
    shimmerBase: Color(0xFF333333),
    shimmerHighlight: Color(0xFF49454F),
    shimmerBorder: Color(0xFF49454F),
  );

  static AppColors of(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>();
    if (colors == null) {
      throw FlutterError(
        'AppColors extension not found. Make sure to add AppColors to your theme.',
      );
    }
    return colors;
  }
}
```

## Liste Shimmer

```dart
class ListShimmerWidget extends StatelessWidget {
  const ListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return _buildListItemShimmer(context);
      },
    );
  }

  Widget _buildListItemShimmer(BuildContext context) {
    return Padding(
      padding: ProjectPadding.allSmall(),
      child: Row(
        children: [
          // Avatar shimmer
          Shimmer.fromColors(
            baseColor: AppColors.of(context).shimmerBase,
            highlightColor: AppColors.of(context).shimmerHighlight,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.of(context).shimmerBase,
                shape: BoxShape.circle,
              ),
            ),
          ),
          ProjectSizedBox.widthMedium,

          // Content shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: AppColors.of(context).shimmerBase,
                  highlightColor: AppColors.of(context).shimmerHighlight,
                  child: Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
                ProjectSizedBox.heightSmall,
                Shimmer.fromColors(
                  baseColor: AppColors.of(context).shimmerBase,
                  highlightColor: AppColors.of(context).shimmerHighlight,
                  child: Container(
                    height: 14,
                    width: 200,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).shimmerBase,
                      borderRadius: ProjectRadius.small,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Custom Shimmer Widget

```dart
class CustomShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration? period;

  const CustomShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    
    return Shimmer.fromColors(
      baseColor: baseColor ?? appColors.shimmerBase,
      highlightColor: highlightColor ?? appColors.shimmerHighlight,
      period: period ?? const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

// Kullanım
CustomShimmer(
  child: Container(
    height: 100,
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

## Animasyonlu Shimmer

```dart
class AnimatedShimmer extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;

  const AnimatedShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedShimmer> createState() => _AnimatedShimmerState();
}

class _AnimatedShimmerState extends State<AnimatedShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Shimmer.fromColors(
          baseColor: widget.baseColor ?? appColors.shimmerBase,
          highlightColor: widget.highlightColor ?? appColors.shimmerHighlight,
          child: widget.child,
        );
      },
    );
  }
}
```

## Conditional Shimmer

```dart
class ConditionalShimmer extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget shimmerChild;

  const ConditionalShimmer({
    super.key,
    required this.isLoading,
    required this.child,
    required this.shimmerChild,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: AppColors.of(context).shimmerBase,
        highlightColor: AppColors.of(context).shimmerHighlight,
        child: shimmerChild,
      );
    }
    return child;
  }
}

// Kullanım
ConditionalShimmer(
  isLoading: viewModel.isLoading,
  child: ProductCard(product: product),
  shimmerChild: ProductShimmerCard(),
)
```

## Shimmer ile State Management

```dart
class ProductViewModel extends ChangeNotifier {
  bool _isLoading = false;
  List<Product> _products = [];

  bool get isLoading => _isLoading;
  List<Product> get products => _products;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _products = await productService.getProducts();
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// View'da kullanım
Consumer<ProductViewModel>(
  builder: (context, viewModel, child) {
    if (viewModel.isLoading) {
      return const ProductShimmerWidget();
    }
    
    return ProductGridView(products: viewModel.products);
  },
)
```

## Performans Optimizasyonu

```dart
class OptimizedShimmer extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const OptimizedShimmer({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    
    return Shimmer.fromColors(
      baseColor: AppColors.of(context).shimmerBase,
      highlightColor: AppColors.of(context).shimmerHighlight,
      child: child,
    );
  }
}

// Lazy loading ile
class LazyShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return OptimizedShimmer(
          enabled: index < 5, // Sadece ilk 5 item shimmer
          child: ListTile(
            leading: CircleAvatar(),
            title: Text('Item $index'),
            subtitle: Text('Subtitle $index'),
          ),
        );
      },
    );
  }
}
```

## Test Stratejileri

```dart
// Shimmer widget test
void main() {
  group('ProductShimmerWidget', () {
    testWidgets('should display shimmer cards', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProductShimmerWidget(),
          ),
        ),
      );

      expect(find.byType(Shimmer), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });
  });
}

// Integration test
void main() {
  group('Shimmer Integration Tests', () {
    testWidgets('should show shimmer while loading', (tester) async {
      await tester.pumpWidget(MyApp());
      
      // Loading state'de shimmer gösterilmeli
      expect(find.byType(ProductShimmerWidget), findsOneWidget);
      
      // Data yüklendikten sonra shimmer kaybolmalı
      await tester.pumpAndSettle();
      expect(find.byType(ProductShimmerWidget), findsNothing);
    });
  });
}
```

## Sonuç

Shimmer efektleri:

- ✅ **Modern loading state'leri** sağlar
- ✅ **Kullanıcı deneyimini** geliştirir
- ✅ **Tema uyumlu** renkler
- ✅ **Performanslı** animasyonlar
- ✅ **Test edilebilir** yapı

### Anahtar Noktalar

1. **Tema renklerini** kullanın
2. **Gerçek içeriğe benzer** placeholder'lar oluşturun
3. **Performansı** optimize edin
4. **Test coverage'ı** sağlayın
5. **Conditional rendering** kullanın

**#Flutter #Shimmer #LoadingStates #UX #UI**
