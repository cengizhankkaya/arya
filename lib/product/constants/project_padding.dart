import 'package:flutter/widgets.dart';

final class ProjectPadding extends EdgeInsets {
  const ProjectPadding._() : super.all(0);

  const ProjectPadding.allVerySmall() : super.all(12);
  const ProjectPadding.allSmall() : super.all(16);
  const ProjectPadding.allNormal() : super.all(20);
  const ProjectPadding.allMedium() : super.all(24);
  const ProjectPadding.allLarge() : super.all(28);

  // Vertical Top Padding
  static const EdgeInsets topSmall = EdgeInsets.only(top: 8);
  static const EdgeInsets topMedium = EdgeInsets.only(top: 12);
  static const EdgeInsets topLarge = EdgeInsets.only(top: 24);
  static const EdgeInsets topXLarge = EdgeInsets.only(top: 32);

  // Vertical Bottom Padding
  static const EdgeInsets bottomSmall = EdgeInsets.only(bottom: 8);
  static const EdgeInsets bottomMedium = EdgeInsets.only(bottom: 12);
  static const EdgeInsets bottomLarge = EdgeInsets.only(bottom: 24);
  static const EdgeInsets bottomXLarge = EdgeInsets.only(bottom: 32);

  // Vertical Padding
  static const EdgeInsets verticalSmall = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets verticalMedium = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets verticalNormal = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets verticalLarge = EdgeInsets.symmetric(vertical: 24);
  static const EdgeInsets verticalXLarge = EdgeInsets.symmetric(vertical: 32);
}
