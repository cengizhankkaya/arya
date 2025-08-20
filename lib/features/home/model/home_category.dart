import 'package:arya/product/theme/app_colors.dart';

class HomeCategory {
  final String titleKey; // easy_localization key
  final String imageUrl;
  final CategoryPalette palette;

  const HomeCategory({
    required this.titleKey,
    required this.imageUrl,
    required this.palette,
  });
}
