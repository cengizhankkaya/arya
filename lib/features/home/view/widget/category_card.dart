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
        context.router.push(
          ProductsRoute(initialCategory: category.titleKey.tr()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: appColors.categoryBg(category.palette),
          borderRadius: BorderRadius.circular(18),
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
                  Image.asset(category.imageUrl, fit: BoxFit.contain),
                  if (isNutritionCategory)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: appColors
                            .categoryBg(category.palette)
                            .withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 8), // Biraz daha az boşluk
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ), // Yatay padding ekliyorum
              child: Text(
                category.titleKey.tr(),
                textAlign: TextAlign.center,
                maxLines: 1, // Tüm kategoriler için tek satır
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: isNutritionCategory
                      ? 13
                      : 14, // Besin değeri kategorileri için biraz daha küçük
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
