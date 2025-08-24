import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  late final List<HomeCategory> categories;

  HomeViewModel() {
    categories = _buildCategories();
  }

  List<HomeCategory> _buildCategories() {
    return const [
      HomeCategory(
        titleKey: 'categories.high_protein',
        imageUrl: HomeConstants.catHighProtein,
        palette: CategoryPalette.highProtein,
      ),
      HomeCategory(
        titleKey: 'categories.high_carbohydrate',
        imageUrl: HomeConstants.catHighCarbohydrate,
        palette: CategoryPalette.highCarbohydrate,
      ),
      HomeCategory(
        titleKey: 'categories.high_fat',
        imageUrl: HomeConstants.catHighFat,
        palette: CategoryPalette.highFat,
      ),
      HomeCategory(
        titleKey: 'categories.high_vitamins_minerals',
        imageUrl: HomeConstants.catHighVitaminsMinerals,
        palette: CategoryPalette.highVitaminsMinerals,
      ),
      HomeCategory(
        titleKey: 'categories.high_fiber',
        imageUrl: HomeConstants.catHighFiber,
        palette: CategoryPalette.highFiber,
      ),
      HomeCategory(
        titleKey: 'categories.fruits_vegetables',
        imageUrl: HomeConstants.catFruitsVegetables,
        palette: CategoryPalette.fruitsVegetables,
      ),
      HomeCategory(
        titleKey: 'categories.breakfast',
        imageUrl: HomeConstants.catBreakfast,
        palette: CategoryPalette.breakfast,
      ),
      HomeCategory(
        titleKey: 'categories.beverages',
        imageUrl: HomeConstants.catBeverages,
        palette: CategoryPalette.beverages,
      ),
      HomeCategory(
        titleKey: 'categories.meat_fish',
        imageUrl: HomeConstants.catMeatFish,
        palette: CategoryPalette.meatFish,
      ),
      HomeCategory(
        titleKey: 'categories.snacks',
        imageUrl: HomeConstants.catSnacks,
        palette: CategoryPalette.snacks,
      ),
      HomeCategory(
        titleKey: 'categories.dairy',
        imageUrl: HomeConstants.catDairy,
        palette: CategoryPalette.dairy,
      ),
    ];
  }

  String localize(BuildContext context, String key) {
    return key.tr();
  }
}
