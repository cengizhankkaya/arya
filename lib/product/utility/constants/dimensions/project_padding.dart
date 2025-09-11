import 'package:flutter/widgets.dart';

final class ProjectPadding extends EdgeInsets {
  const ProjectPadding.xVerySmall() : super.all(4);
  const ProjectPadding.verySmall() : super.all(8);
  const ProjectPadding.allVerySmall() : super.all(12);
  const ProjectPadding.allSmall() : super.all(16);
  const ProjectPadding.allNormal() : super.all(18);
  const ProjectPadding.allLarge() : super.all(20);
  const ProjectPadding.allMedium() : super.all(24);
  const ProjectPadding.allXLarge() : super.all(28);

  // Vertical Top Padding
  static const EdgeInsets topSmall = EdgeInsets.only(top: 8);
  static const EdgeInsets topMedium = EdgeInsets.only(top: 12);
  static const EdgeInsets topLarge = EdgeInsets.only(top: 24);
  static const EdgeInsets topXLarge = EdgeInsets.only(top: 32);

  // Responsive Top Padding for Onboard Card
  static EdgeInsets topOnboardCard(BuildContext context) =>
      EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1);

  // Vertical Bottom Padding
  static const EdgeInsets bottomSmall = EdgeInsets.only(bottom: 8);
  static const EdgeInsets bottomMedium = EdgeInsets.only(bottom: 12);
  static const EdgeInsets bottomLarge = EdgeInsets.only(bottom: 24);
  static const EdgeInsets bottomXLarge = EdgeInsets.only(bottom: 32);

  // Horizontal Right Padding
  static const EdgeInsets rightSmall = EdgeInsets.only(right: 8);
  static const EdgeInsets rightMedium = EdgeInsets.only(right: 12);
  static const EdgeInsets rightLarge = EdgeInsets.only(right: 24);
  static const EdgeInsets rightXLarge = EdgeInsets.only(right: 32);

  // Horizontal Left Padding
  static const EdgeInsets leftSmall = EdgeInsets.only(left: 8);
  static const EdgeInsets leftMedium = EdgeInsets.only(left: 12);
  static const EdgeInsets leftLarge = EdgeInsets.only(left: 24);
  static const EdgeInsets leftXLarge = EdgeInsets.only(left: 32);

  // Vertical Padding
  static const EdgeInsets verticalVerySmall = EdgeInsets.symmetric(vertical: 4);
  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets verticalNormal = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: 24);
  static const EdgeInsets verticalXLarge = EdgeInsets.symmetric(vertical: 32);

  static const EdgeInsets symmetricVerySmall = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 16,
  );

  static const EdgeInsets symmetricSmall = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  static const EdgeInsets symmetricNormal = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  static const EdgeInsets symmetricVeryLarge = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 12,
  );

  static const EdgeInsets symmetricLarge = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 24,
  );
  static const EdgeInsets symmetricMedium = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 28,
  );

  static const EdgeInsets symmetricPrivate = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
  );

  // Special padding for product detail view
  static const EdgeInsets productDetailMain = EdgeInsets.fromLTRB(
    24,
    32,
    24,
    24,
  );
  static const EdgeInsets productDetailCard = EdgeInsets.all(24);
  static const EdgeInsets productDetailChip = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets productDetailIcon = EdgeInsets.all(6);
  static const EdgeInsets productDetailBrand = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const EdgeInsets bottomBarQuantity = EdgeInsets.symmetric(
    horizontal: 4,
    vertical: 8,
  );
  static const EdgeInsets nutritionGrid = EdgeInsets.all(14);
}
