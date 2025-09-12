import 'package:arya/features/store/view_model/product_detail_view_model.dart';
import 'package:arya/product/theme/app_typography.dart';
import 'package:arya/product/utility/constants/dimensions/project_padding.dart';
import 'package:arya/product/utility/constants/dimensions/project_radius.dart';
import 'package:arya/product/utility/constants/dimensions/project_sizedbox.dart';
import 'package:arya/product/widget/add_elevated_button.dart';
import 'package:flutter/material.dart';

class ProductDetailBottomBar extends StatelessWidget {
  const ProductDetailBottomBar({
    super.key,
    required this.viewModel,
    required this.scheme,
  });

  final ProductDetailViewModel viewModel;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: ProjectRadius.bottomBar,
        border: Border(
          top: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: ProjectPadding.allLarge(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: ProjectPadding.bottomBarQuantity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      scheme.surfaceContainerHighest,
                      scheme.surfaceContainerHighest.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: ProjectRadius.xxxBig,
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.12),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: scheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.1),
                        borderRadius: ProjectRadius.big,
                      ),
                      child: IconButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () => viewModel.decrementQuantity(),
                        icon: Icon(Icons.remove, color: scheme.primary),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(40, 40),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    ProjectSizedBox.widthSmall,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: ProjectRadius.xLarge,
                      ),
                      child: Text(
                        viewModel.quantity.toString(),
                        style: AppTypography.lightTextTheme.titleLarge
                            ?.copyWith(
                              fontWeight: AppTypography.boldWeight,
                              color: scheme.onSurface,
                            ),
                      ),
                    ),
                    ProjectSizedBox.widthSmall,
                    Container(
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.1),
                        borderRadius: ProjectRadius.big,
                      ),
                      child: IconButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () => viewModel.incrementQuantity(),
                        icon: Icon(Icons.add, color: scheme.primary),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(40, 40),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ProjectSizedBox.heightNormal,
              SizedBox(
                width: double.infinity,
                child: AddToCartButton(viewModel: viewModel, scheme: scheme),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
