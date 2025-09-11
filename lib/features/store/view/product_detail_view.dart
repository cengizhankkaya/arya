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
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: ProjectRadius.topOnly,
                    boxShadow: [
                      BoxShadow(
                        color: scheme.shadow.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: ProjectPadding.productDetailMain,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (viewModel.errorMessage != null)
                          ProductDetailErrorBanner(
                            errorMessage: viewModel.errorMessage!,
                            onClose: () => viewModel.clearError(),
                            scheme: scheme,
                          ),
                        Container(
                          padding: ProjectPadding.productDetailCard,
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: ProjectRadius.xxLarge,
                            border: Border.all(
                              color: scheme.outline.withValues(alpha: 0.08),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: scheme.shadow.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel.productName,
                                    style: AppTypography
                                        .lightTextTheme
                                        .headlineLarge
                                        ?.copyWith(
                                          fontWeight: AppTypography.boldWeight,
                                          color: scheme.onSurface,
                                          height: 1.2,
                                        ),
                                  ),
                                  if (viewModel.brand != null) ...[
                                    ProjectSizedBox.heightNormal,
                                    Container(
                                      padding:
                                          ProjectPadding.productDetailBrand,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            scheme.primaryContainer,
                                            scheme.primaryContainer.withValues(
                                              alpha: 0.8,
                                            ),
                                          ],
                                        ),
                                        borderRadius: ProjectRadius.xxLarge,
                                        border: Border.all(
                                          color: scheme.primary.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: scheme.primary.withValues(
                                              alpha: 0.1,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.business,
                                            size: 16,
                                            color: scheme.onPrimaryContainer,
                                          ),
                                          ProjectSizedBox.widthSmall,
                                          Text(
                                            viewModel.brand!,
                                            style: AppTypography
                                                .lightTextTheme
                                                .labelLarge
                                                ?.copyWith(
                                                  color:
                                                      scheme.onPrimaryContainer,
                                                  fontWeight:
                                                      AppTypography.boldWeight,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              ProjectSizedBox.heightXLarge,
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
                              ProjectSizedBox.heightXXLarge,
                              ProjectSizedBox.heightMedium,
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
      padding: ProjectPadding.productDetailChip,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            scheme.surfaceContainerHighest,
            scheme.surfaceContainerHighest.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: ProjectRadius.xxLarge,
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: ProjectPadding.productDetailIcon,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              borderRadius: ProjectRadius.medium,
            ),
            child: Icon(
              label == 'detail.ingredients'.tr()
                  ? Icons.eco_outlined
                  : Icons.scale_outlined,
              size: 14,
              color: scheme.primary,
            ),
          ),
          ProjectSizedBox.widthSmall,
          Flexible(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$label: ",
                    style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: AppTypography.bodyLargeWeight,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: AppTypography.boldWeight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
