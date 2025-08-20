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
    final appColors = Theme.of(context).extension<AppColors>()!;
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
              child: Image.asset(category.imageUrl, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(
              category.titleKey.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color:
                    Theme.of(context).extension<AppColors>()?.textStrong ??
                    Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
