import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// ViewModel responsible for managing the home screen's business logic and state.
/// This class follows the MVVM (Model-View-ViewModel) architecture pattern,
/// separating business logic from UI concerns and providing a clean interface
/// for the home view to interact with data and operations.
///
/// The HomeViewModel manages:
/// - Product category definitions and organization
/// - Localization support for category titles
/// - State management through ChangeNotifier
///
/// Key responsibilities:
/// - Initializing and maintaining the category list
/// - Providing localized category information
/// - Managing view state and updates
///
/// Usage:
/// ```dart
/// final viewModel = HomeViewModel();
/// final categories = viewModel.categories;
/// final localizedTitle = viewModel.localize(context, 'categories.high_protein');
/// ```
class HomeViewModel extends ChangeNotifier {
  /// List of product categories available on the home screen.
  /// This list is initialized during construction and remains constant
  /// throughout the view model's lifecycle.
  ///
  /// The categories are organized to provide logical grouping of products
  /// based on nutritional characteristics and common food categories.
  late final List<HomeCategory> categories;

  /// Constructs a new HomeViewModel instance.
  /// During construction, the categories list is initialized with predefined
  /// category definitions that cover the main product types in the application.
  ///
  /// The initialization process:
  /// 1. Creates category instances with localized keys
  /// 2. Assigns appropriate image assets
  /// 3. Applies consistent color palettes
  ///
  /// Parameters:
  /// - [categories]: Optional list of categories for testing purposes
  HomeViewModel({List<HomeCategory>? categories}) {
    this.categories = categories ?? _buildCategories();
  }

  /// Builds and returns the complete list of product categories.
  /// This method defines all available categories with their properties,
  /// ensuring consistency in naming, imagery, and visual presentation.
  ///
  /// The categories are organized into logical groups:
  /// - Nutritional focus (high protein, high carb, high fat)
  /// - Food types (fruits/vegetables, meat/fish, dairy)
  /// - Meal categories (breakfast, snacks, beverages)
  ///
  /// Returns:
  /// - Immutable list of HomeCategory instances
  /// - Pre-configured with localization keys and assets
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

  /// Localizes a given key using the current locale context.
  /// This method provides a convenient way to translate category titles
  /// and other text elements based on the user's language preference.
  ///
  /// The method uses easy_localization to handle:
  /// - Language detection and switching
  /// - Fallback to default language
  /// - Dynamic text updates
  ///
  /// Parameters:
  /// - context: BuildContext for accessing localization data
  /// - key: Localization key to translate
  ///
  /// Returns:
  /// - Localized string in the current language
  /// - Fallback text if translation is not available
  ///
  /// Example:
  /// ```dart
  /// final title = viewModel.localize(context, 'categories.high_protein');
  /// // Returns 'High Protein' in English or 'Yüksek Protein' in Turkish
  /// ```
  String localize(BuildContext context, String key) {
    return key.tr();
  }

  /// Disposes the view model and cleans up resources.
  /// This method can be called multiple times safely.
  @override
  void dispose() {
    if (!hasListeners) {
      return; // Already disposed
    }
    super.dispose();
  }
}
