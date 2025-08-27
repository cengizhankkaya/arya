import 'package:flutter/material.dart';

@immutable
class ProjectSizedBox {
  const ProjectSizedBox._();

  // Height (Yükseklik) - Vertical Spacing
  static const SizedBox heightVerySmall = SizedBox(height: 4);
  static const SizedBox heightSmall = SizedBox(height: 8);
  static const SizedBox heightSmallMedium = SizedBox(height: 10);
  static const SizedBox heightNormal = SizedBox(height: 12);
  static const SizedBox heightMedium = SizedBox(height: 16);
  static const SizedBox heightLarge = SizedBox(height: 20);
  static const SizedBox heightXLarge = SizedBox(height: 24);
  static const SizedBox heightXXLarge = SizedBox(height: 32);
  static const SizedBox heightXXXLarge = SizedBox(height: 40);
  static const SizedBox heightXXXXLarge = SizedBox(height: 48);

  // Width (Genişlik) - Horizontal Spacing
  static const SizedBox widthVerySmall = SizedBox(width: 4);
  static const SizedBox widthSmall = SizedBox(width: 8);
  static const SizedBox widthSmallMedium = SizedBox(width: 10);
  static const SizedBox widthNormal = SizedBox(width: 12);
  static const SizedBox widthNormalMedium = SizedBox(width: 15);
  static const SizedBox widthMedium = SizedBox(width: 16);
  static const SizedBox widthLarge = SizedBox(width: 20);
  static const SizedBox widthXLarge = SizedBox(width: 24);
  static const SizedBox widthXXLarge = SizedBox(width: 32);

  // Square SizedBox (Kare boyutlar)
  static const SizedBox squareVerySmall = SizedBox.shrink();
  static const SizedBox squareSmall = SizedBox.shrink();
  static const SizedBox squareNormal = SizedBox.shrink();
  static const SizedBox squareMedium = SizedBox.shrink();
  static const SizedBox squareLarge = SizedBox.shrink();
  static const SizedBox squareXLarge = SizedBox.shrink();

  // Expanded SizedBox (Genişletilmiş)
  static const SizedBox expanded = SizedBox.expand();

  // Shrink SizedBox (Küçültülmüş)
  static const SizedBox shrink = SizedBox.shrink();

  // Custom SizedBox oluşturucu metodlar
  static SizedBox customHeight(double height) => SizedBox(height: height);
  static SizedBox customWidth(double width) => SizedBox(width: width);
  static SizedBox customSize({double? width, double? height}) =>
      SizedBox(width: width, height: height);

  // Responsive SizedBox (Ekran boyutuna göre)
  static SizedBox responsiveHeight(BuildContext context, double factor) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(height: screenHeight * factor);
  }

  static SizedBox responsiveWidth(BuildContext context, double factor) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(width: screenWidth * factor);
  }

  // Responsive width değeri döndüren metod (SizedBox değil, double)
  static double responsiveWidthValue(BuildContext context, double factor) {
    return MediaQuery.of(context).size.width * factor;
  }
}

// Kullanım kolaylığı için extension
extension ProjectSizedBoxExtension on num {
  SizedBox get height => SizedBox(height: toDouble());
  SizedBox get width => SizedBox(width: toDouble());
  SizedBox get square => SizedBox(width: toDouble(), height: toDouble());
}
