import 'package:arya/product/utility/constants/enums/locales.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';

/// This class is used to initialize the product localization for the application.
@immutable
final class ProductLocalization extends EasyLocalization {
  /// ProductLocalization need to [child] for a wrap locale item
  ProductLocalization({required super.child, super.key})
    : super(
        supportedLocales: _supportedLocales,
        path: _translationPath,
        useOnlyLangCode: true,
        startLocale: _getInitialLocale(),
      );

  static final List<Locale> _supportedLocales = [
    Locales.tr.locale,
    Locales.en.locale,
  ];

  static const String _translationPath = 'assets/translations';

  /// Telefon dilini algılar ve uygun locale'i döndürür
  /// Eğer telefon dili Türkçe ise Türkçe, değilse İngilizce döndürür
  static Locale _getInitialLocale() {
    try {
      final deviceLocale = PlatformDispatcher.instance.locale;
      final languageCode = deviceLocale.languageCode.toLowerCase();

      // Telefon dili Türkçe ise Türkçe döndür
      if (languageCode == 'tr') {
        return Locales.tr.locale;
      }

      // Diğer tüm diller için İngilizce döndür
      return Locales.en.locale;
    } catch (e) {
      // Hata durumunda varsayılan olarak İngilizce döndür
      return Locales.en.locale;
    }
  }

  static Future<void> updateLanguage({
    required BuildContext context,
    required Locales value,
  }) => context.setLocale(value.locale);
}
