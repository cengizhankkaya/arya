import 'package:arya/product/index.dart';
import 'package:arya/features/store/view_model/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailView extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final viewModel = ProductDetailViewModel();
        viewModel.loadProduct(product);
        return viewModel;
      },
      child: Consumer<ProductDetailViewModel>(
        builder: (context, viewModel, child) {
          return _ProductDetailContent(viewModel: viewModel);
        },
      ),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  final ProductDetailViewModel viewModel;

  const _ProductDetailContent({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final product = viewModel.productData;
    final nutriments = product['nutriments'] ?? {};

    // Quantity değişikliklerini dinle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.quantity <= 0) {
        viewModel.resetQuantity();
      }
    });

    if (viewModel.isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: scheme.primary)),
      );
    }

    if (viewModel.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: scheme.error),
              const SizedBox(height: 16),
              Text(
                'Hata',
                style: AppTypography.lightTextTheme.headlineMedium?.copyWith(
                  color: scheme.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.error!,
                style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => viewModel.loadProduct(product),
                child: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 400,
            floating: false,
            pinned: true,
            backgroundColor: scheme.primary,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(
                    viewModel.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: viewModel.isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () => viewModel.toggleFavorite(),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (product['image_url'] != null)
                    Image.network(product['image_url'], fit: BoxFit.cover)
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [scheme.primary, scheme.primaryContainer],
                        ),
                      ),
                      child: Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: ProjectPadding.allLarge(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Brand in same row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  product['product_name'] ?? 'Product Name',
                                  style: AppTypography
                                      .lightTextTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: scheme.onSurface,
                                      ),
                                ),
                              ),
                              if (product['brands'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: scheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    product['brands'],
                                    style: AppTypography
                                        .lightTextTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: scheme.onPrimaryContainer,
                                        ),
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Product Details in compact horizontal layout
                          if (product['ingredients_text'] != null ||
                              product['quantity'] != null ||
                              product['categories'] != null)
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: [
                                if (product['ingredients_text'] != null)
                                  _buildCompactDetailItem(
                                    "Ingredients",
                                    product['ingredients_text'],
                                    scheme,
                                  ),
                                if (product['quantity'] != null)
                                  _buildCompactDetailItem(
                                    "Quantity",
                                    product['quantity'],
                                    scheme,
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),
                    // Nutrition Section
                    _buildDetailCard(
                      context,
                      scheme,
                      "Nutrition Facts",
                      Icons.monitor_heart_outlined,
                      _buildNutritionItems(nutriments, scheme),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: viewModel.quantity > 1
                          ? () => viewModel.decreaseQuantity()
                          : null,
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: viewModel.quantity > 1
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: scheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        viewModel.quantity.toString(),
                        style: AppTypography.lightTextTheme.titleLarge
                            ?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => viewModel.increaseQuantity(),
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: addElevatedButton(scheme, context, product),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    ColorScheme scheme,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: scheme.onPrimaryContainer, size: 20),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.lightTextTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...children,
          // Product info subtitle
          Text(
            "Ürün bilgileri gönülüler sayeeysinde toplanmaktadır gerçeği yansıtmakta sorun çıkabilir",
            style: AppTypography.lightTextTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDetailItem(
    String label,
    String value,
    ColorScheme scheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outline.withOpacity(0.2), width: 1),
      ),
      child: Text(
        "$label: $value",
        style: AppTypography.lightTextTheme.bodySmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  List<Widget> _buildNutritionItems(
    Map<String, dynamic> nutriments,
    ColorScheme scheme,
  ) {
    final nutritionData = [
      {'key': 'energy-kcal_100g', 'label': 'Energy', 'unit': 'kcal'},
      {'key': 'fat_100g', 'label': 'Fat', 'unit': 'g'},
      {'key': 'saturated-fat_100g', 'label': 'Saturated Fat', 'unit': 'g'},
      {'key': 'carbohydrates_100g', 'label': 'Carbohydrates', 'unit': 'g'},
      {'key': 'sugars_100g', 'label': 'Sugars', 'unit': 'g'},
      {'key': 'proteins_100g', 'label': 'Proteins', 'unit': 'g'},
      {'key': 'salt_100g', 'label': 'Salt', 'unit': 'g'},
    ];

    return nutritionData.map((item) {
      final value = nutriments[item['key']];
      if (value == null) return SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outline.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['label']!,
              style: AppTypography.lightTextTheme.bodyLarge?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${value.toStringAsFixed(1)} ${item['unit']}",
              style: AppTypography.lightTextTheme.bodyLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
