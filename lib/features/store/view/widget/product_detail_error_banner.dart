import 'package:arya/product/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ProductDetailErrorBanner extends StatelessWidget {
  const ProductDetailErrorBanner({
    super.key,
    required this.errorMessage,
    required this.onClose,
    required this.scheme,
  });

  final String errorMessage;
  final VoidCallback onClose;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
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
              errorMessage,
              style: AppTypography.lightTextTheme.bodyMedium?.copyWith(
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
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}


