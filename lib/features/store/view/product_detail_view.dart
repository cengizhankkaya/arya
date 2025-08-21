import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/product_detail_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:auto_route/auto_route.dart';
import 'widget/index.dart';

@RoutePage()
class ProductDetailView extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailView({super.key, required this.product});

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
              ProductDetailAppBar(viewModel: viewModel, scheme: scheme),
              // Content
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: ProjectRadius.xxLarge,
                  ),
                  child: Padding(
                    padding: ProjectPadding.allLarge(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (viewModel.errorMessage != null)
                          ProductDetailErrorBanner(
                            errorMessage: viewModel.errorMessage!,
                            onClose: () => viewModel.clearError(),
                            scheme: scheme,
                          ),
                        // Product Title Section
                        Container(
                          padding: ProjectPadding.allLarge(),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: ProjectRadius.xxLarge,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                            fontWeight:
                                                AppTypography.boldWeight,
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
                                        borderRadius: ProjectRadius.xxLarge,
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
                              const SizedBox(height: 24),
                              ProductDetailCard(
                                scheme: scheme,
                                titleKey: 'detail.nutrition_facts',
                                icon: Icons.monitor_heart_outlined,
                                child: ProductDetailNutritionGrid(
                                  nutriments: viewModel.nutriments,
                                  nutritionData: viewModel.nutritionData,
                                  scheme: scheme,
                                ),
                              ),
                              const SizedBox(height: 32),
                              const SizedBox(height: 16),
                              if (viewModel.ingredients != null ||
                                  viewModel.quantityText != null ||
                                  viewModel.categories != null)
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 12,
                                  children: [
                                    if (viewModel.ingredients != null)
                                      _CompactDetailChip(
                                        label: 'detail.ingredients'.tr(),
                                        value: viewModel.ingredients!,
                                        scheme: scheme,
                                      ),
                                    if (viewModel.quantityText != null)
                                      _CompactDetailChip(
                                        label: 'detail.quantity'.tr(),
                                        value: viewModel.quantityText!,
                                        scheme: scheme,
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
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
              color: Theme.of(
                context,
              ).extension<AppColors>()!.black.withValues(alpha: 0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      bottomNavigationBar: ProductDetailBottomBar(
        viewModel: viewModel,
        scheme: scheme,
      ),
    );
  }
}

class _CompactDetailChip extends StatelessWidget {
  const _CompactDetailChip({
    required this.label,
    required this.value,
    required this.scheme,
  });

  final String label;
  final String value;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: ProjectRadius.xxLarge,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.16),
          width: 1,
        ),
      ),
      child: Text(
        "$label: $value",
        style: AppTypography.lightTextTheme.bodySmall?.copyWith(
          color: scheme.onSurface,
          fontWeight: AppTypography.bodyLargeWeight,
        ),
      ),
    );
  }
}
