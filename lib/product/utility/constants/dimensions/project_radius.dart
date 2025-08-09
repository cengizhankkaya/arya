import 'package:flutter/material.dart';

@immutable
class ProjectRadius {
  const ProjectRadius._();

  static const BorderRadius small = BorderRadius.all(Radius.circular(4));
  static const BorderRadius normal = BorderRadius.all(Radius.circular(6));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(8));
  static const BorderRadius large = BorderRadius.all(Radius.circular(12));
  static const BorderRadius xLarge = BorderRadius.all(Radius.circular(16));
}
