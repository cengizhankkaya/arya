import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/product_detail_view_model.dart';

class ProductDetailView extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetailViewModel(product: product),
      child: _ProductDetailViewBody(),
    );
  }
}

class _ProductDetailViewBody extends StatelessWidget {
  const _ProductDetailViewBody();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final viewModel = context.watch<ProductDetailViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
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
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () => viewModel.shareProduct(),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (viewModel.imageUrl != null)
                        Image.network(viewModel.imageUrl!, fit: BoxFit.cover)
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
                        // Error Message Display
                        if (viewModel.errorMessage != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: scheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: scheme.error),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: scheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    viewModel.errorMessage!,
                                    style: AppTypography
                                        .lightTextTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: scheme.onErrorContainer,
                                        ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: scheme.error,
                                    size: 20,
                                  ),
                                  onPressed: () => viewModel.clearError(),
                                ),
                              ],
                            ),
                          ),

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
                                      viewModel.productName,
                                      style: AppTypography
                                          .lightTextTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: scheme.onSurface,
                                          ),
                                    ),
                                  ),
                                  if (viewModel.brand != null)
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
                                        viewModel.brand!,
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

                              const SizedBox(height: 16),

                              // Product Details in compact horizontal layout
                              if (viewModel.ingredients != null ||
                                  viewModel.quantityText != null ||
                                  viewModel.categories != null)
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 12,
                                  children: [
                                    if (viewModel.ingredients != null)
                                      _buildCompactDetailItem(
                                        "Ingredients",
                                        viewModel.ingredients!,
                                        scheme,
                                      ),
                                    if (viewModel.quantityText != null)
                                      _buildCompactDetailItem(
                                        "Quantity",
                                        viewModel.quantityText!,
                                        scheme,
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        // Nutrition Section
                        _buildDetailCard(
                          context,
                          scheme,
                          "Nutrition Facts",
                          Icons.monitor_heart_outlined,
                          _buildNutritionItems(
                            viewModel.nutriments,
                            viewModel.nutritionData,
                            scheme,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Loading Overlay
          if (viewModel.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
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
                      onPressed: viewModel.isLoading
                          ? null
                          : () => viewModel.decrementQuantity(),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      viewModel.quantity.toString(),
                      style: AppTypography.lightTextTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () => viewModel.incrementQuantity(),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: _buildAddToCartButton(context, scheme, viewModel),
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
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTypography.lightTextTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
    List<Map<String, String>> nutritionData,
    ColorScheme scheme,
  ) {
    return nutritionData.map((item) {
      final value = nutriments[item['key']];
      if (value == null) return const SizedBox.shrink();

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

  Widget _buildAddToCartButton(
    BuildContext context,
    ColorScheme scheme,
    ProductDetailViewModel viewModel,
  ) {
    return ElevatedButton(
      onPressed: viewModel.isLoading ? null : () => viewModel.addToCart(),
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: viewModel.isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(scheme.onPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Sepete Ekleniyor...',
                  style: AppTypography.lightTextTheme.titleMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, color: scheme.onPrimary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Sepete Ekle (${viewModel.quantity})',
                  style: AppTypography.lightTextTheme.titleMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }
}
