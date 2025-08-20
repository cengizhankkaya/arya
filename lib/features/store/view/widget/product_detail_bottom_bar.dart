import 'package:arya/features/store/view_model/product_detail_view_model.dart';
import 'package:arya/product/theme/app_typography.dart';
import 'package:arya/product/widget/add_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:arya/product/theme/app_colors.dart';

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
        border: Border(
          top: BorderSide(
            color: scheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).extension<AppColors>()!.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.14),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      onPressed: viewModel.isLoading
                          ? null
                          : () => viewModel.decrementQuantity(),
                      icon: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      viewModel.quantity.toString(),
                      style: AppTypography.lightTextTheme.titleLarge,
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      onPressed: viewModel.isLoading
                          ? null
                          : () => viewModel.incrementQuantity(),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
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
