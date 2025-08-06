import 'package:flutter/material.dart';

/// This enum defines the supported locales for the application.
enum Locales {
  /// Turkish locale.
  tr(Locale('tr', 'TR')),

  /// English locale.
  en(Locale('en', 'US'));

  /// This is the locale used for Turkish language.
  final Locale locale;
  const Locales(this.locale);
}
