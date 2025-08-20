import 'package:arya/product/theme/app_typography.dart';
import 'package:arya/product/utility/constants/dimensions/project_radius.dart';
import 'package:flutter/material.dart';

class ProductDetailNutritionGrid extends StatelessWidget {
  const ProductDetailNutritionGrid({
    super.key,
    required this.nutriments,
    required this.nutritionData,
    required this.scheme,
  });

  final Map<String, dynamic> nutriments;
  final List<Map<String, String>> nutritionData;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final items = nutritionData.map((item) {
      final raw = nutriments[item['key']];
      double? value;
      if (raw is num) {
        value = raw.toDouble();
      } else if (raw is String) {
        value = double.tryParse(raw.replaceAll(',', '.'));
      }
      if (value == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: ProjectRadius.xxLarge,
          border: Border.all(
            color: scheme.outline.withValues(alpha: 0.14),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${value.toStringAsFixed(1)} ${item['unit']}",
              style: AppTypography.lightTextTheme.titleMedium?.copyWith(
                color: scheme.tertiary,
                fontWeight: AppTypography.displayWeight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item['label'] ?? '',
              style: AppTypography.lightTextTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: AppTypography.labelWeight,
              ),
            ),
          ],
        ),
      );
    }).toList();

    final visibleItems = items.where((w) => w is! SizedBox).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacing = 12;
        final int columns = constraints.maxWidth > 520 ? 3 : 2;
        final double itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: visibleItems
              .map((w) => SizedBox(width: itemWidth, child: w))
              .toList(),
        );
      },
    );
  }
}
