import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';

class Category {
  final String name;
  final String imageUrl;
  final CategoryPalette palette;

  Category({required this.name, required this.imageUrl, required this.palette});
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>()!;
    final List<Category> categories = [
      Category(
        name: 'categories.fruits_vegetables'.tr(),
        imageUrl: 'assets/images/categories/cat_fruits.png',
        palette: CategoryPalette.fruitsVegetables,
      ),
      Category(
        name: 'categories.breakfast'.tr(),
        imageUrl: 'assets/images/categories/cat_breakfast.png',
        palette: CategoryPalette.breakfast,
      ),
      Category(
        name: 'categories.beverages'.tr(),
        imageUrl: 'assets/images/categories/cat_beverages.png',
        palette: CategoryPalette.beverages,
      ),
      Category(
        name: 'categories.meat_fish'.tr(),
        imageUrl: 'assets/images/categories/cat_meat_fish.png',
        palette: CategoryPalette.meatFish,
      ),
      Category(
        name: 'categories.snacks'.tr(),
        imageUrl: 'assets/images/categories/cat_snacks.png',
        palette: CategoryPalette.snacks,
      ),
      Category(
        name: 'categories.dairy'.tr(),
        imageUrl: 'assets/images/categories/cat_dairy.png',
        palette: CategoryPalette.dairy,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('appbar.categories'.tr()),
        centerTitle: true,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: appColors.surfaceMuted,
      body: Padding(
        padding: ProjectPadding.allSmall(),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (context, index) {
            return CategoryCard(category: categories[index]);
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductsPage(initialCategory: category.name),
          ),
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
          boxShadow: [
            BoxShadow(
              color:
                  (Theme.of(context).colorScheme.brightness == Brightness.light)
                  ? Colors.black12
                  : Theme.of(context).colorScheme.shadow.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
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
              category.name,
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
