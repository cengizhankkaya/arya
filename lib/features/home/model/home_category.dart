import 'package:arya/product/theme/app_colors.dart';

/// Represents a product category displayed on the home screen.
/// This model encapsulates the visual and functional properties of a category,
/// including its localized title, image representation, and color palette.
///
/// The category system is designed to provide users with intuitive navigation
/// through different product types based on nutritional characteristics and
/// common food groupings.
///
/// Usage:
/// ```dart
/// final category = HomeCategory(
///   titleKey: 'categories.high_protein',
///   imageUrl: 'assets/images/categories/protein.png',
///   palette: CategoryPalette.highProtein,
/// );
/// ```
class HomeCategory {
  /// Localization key for the category title.
  /// This key is used with easy_localization to provide multi-language support
  /// for category names across different locales.
  ///
  /// Example keys:
  /// - 'categories.high_protein' -> 'High Protein' (EN) / 'Yüksek Protein' (TR)
  /// - 'categories.breakfast' -> 'Breakfast' (EN) / 'Kahvaltı' (TR)
  final String titleKey;

  /// Asset path or URL for the category's visual representation.
  /// This image is displayed on the category card to help users quickly
  /// identify and understand the category type.
  ///
  /// The image should be:
  /// - Visually representative of the category
  /// - Consistent in style and quality
  /// - Optimized for performance
  final String imageUrl;

  /// Color palette defining the visual theme for this category.
  /// The palette includes primary, secondary, and accent colors that
  /// create a cohesive visual identity for the category.
  ///
  /// This ensures consistent branding and improves user experience
  /// through visual recognition and association.
  final CategoryPalette palette;

  /// Creates a new HomeCategory instance with the specified properties.
  /// All parameters are required to ensure complete category definition.
  ///
  /// Parameters:
  /// - titleKey: Localization key for the category title
  /// - imageUrl: Path to the category image asset
  /// - palette: Color scheme for the category
  const HomeCategory({
    required this.titleKey,
    required this.imageUrl,
    required this.palette,
  });

  /// Returns true if this HomeCategory is equal to [other].
  /// Two HomeCategory instances are considered equal if all their properties
  /// (titleKey, imageUrl, palette) are equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HomeCategory) return false;

    return titleKey == other.titleKey &&
        imageUrl == other.imageUrl &&
        palette == other.palette;
  }

  /// Returns the hash code for this HomeCategory.
  /// The hash code is computed based on all properties to ensure
  /// that equal objects have the same hash code.
  @override
  int get hashCode {
    return Object.hash(titleKey, imageUrl, palette);
  }

  /// Returns a string representation of this HomeCategory.
  /// Useful for debugging and logging purposes.
  @override
  String toString() {
    return 'HomeCategory(titleKey: $titleKey, imageUrl: $imageUrl, palette: $palette)';
  }
}
