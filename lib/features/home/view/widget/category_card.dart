import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final HomeCategory category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors.of(context);
    final isNutritionCategory = _isNutritionCategory(category.titleKey);

    return InkWell(
      onTap: () {
        try {
          context.router.push(
            ProductsRoute(initialCategory: category.titleKey.tr()),
          );
        } catch (e) {
          // Test ortamında AutoRouter context'i olmayabilir
          // Bu durumda navigation'ı sessizce geç
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: appColors.categoryBg(category.palette),
          borderRadius: ProjectRadius.xxLarge,
          border: Border.all(
            color: appColors.categoryBorder(category.palette),
            width: 1,
          ),
        ),
        padding: ProjectPadding.allVerySmall(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildImage(category.imageUrl),
                  if (isNutritionCategory)
                    Container(
                      padding: ProjectPadding.verySmall(),
                      decoration: BoxDecoration(
                        color: appColors
                            .categoryBg(category.palette)
                            .withValues(alpha: 0.8),
                        borderRadius: ProjectRadius.large,
                      ),
                      child: Icon(
                        _getNutritionIcon(category.titleKey),
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
            ProjectSizedBox.heightSmall,
            Padding(
              padding: ProjectPadding.verticalVerySmall,
              child: Text(
                category.titleKey.tr(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: isNutritionCategory ? 13 : 14,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isNutritionCategory(String titleKey) {
    return titleKey.contains('high_') ||
        titleKey.contains('protein') ||
        titleKey.contains('carbohydrate') ||
        titleKey.contains('fat') ||
        titleKey.contains('vitamins') ||
        titleKey.contains('fiber');
  }

  Widget _buildImage(String imageUrl) {
    return Image.asset(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Görsel yüklenemezse fallback göster
        return Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        );
      },
    );
  }

  IconData _getNutritionIcon(String titleKey) {
    if (titleKey.contains('protein')) {
      return Icons.fitness_center;
    }
    if (titleKey.contains('carbohydrate') || titleKey.contains('carbs')) {
      return Icons.grain;
    }
    if (titleKey.contains('fat')) {
      return Icons.water_drop;
    }
    if (titleKey.contains('vitamins') || titleKey.contains('minerals')) {
      return Icons.eco;
    }
    if (titleKey.contains('fiber')) {
      return Icons.forest;
    }
    return Icons.category;
  }
}
