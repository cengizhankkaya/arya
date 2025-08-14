import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.viewModel,
    required this.scheme,
  });

  final ProductDetailViewModel viewModel;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: viewModel.isLoading
          ? null
          : () => viewModel.addToCart(context),
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
