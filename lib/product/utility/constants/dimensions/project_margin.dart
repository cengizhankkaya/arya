import 'package:flutter/material.dart';

@immutable
class ProjectMargin {
  const ProjectMargin._();

  static const EdgeInsets verySmall = EdgeInsets.all(4);
  static const EdgeInsets small = EdgeInsets.all(8);
  static const EdgeInsets normal = EdgeInsets.all(12);
  static const EdgeInsets medium = EdgeInsets.all(16);
  static const EdgeInsets large = EdgeInsets.all(20);
  static const EdgeInsets xLarge = EdgeInsets.all(24);

  // Özel örnek
  static const EdgeInsets topMedium = EdgeInsets.only(top: 16);
}
