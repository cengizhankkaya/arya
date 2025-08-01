import 'package:flutter/material.dart';

class OnboardConstants {
  // Button texts
  static const String startText = 'Start';
  static const String nextText = 'Next';
  static const String skipText = 'Skip';

  // Animation durations
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve pageTransitionCurve = Curves.easeInOut;

  // Colors
  static const Color skipButtonColor = Colors.black;
  static const Color backButtonColor = Colors.black;

  // AppBar settings
  static const double appBarElevation = 0.0;
}
