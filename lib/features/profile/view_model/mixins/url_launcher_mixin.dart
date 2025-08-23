import 'package:arya/product/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

mixin UrlLauncherMixin<T extends StatefulWidget> on State<T> {
  Future<void> launchOpenFoodFacts(BuildContext context) async {
    try {
      const url = 'https://world.openfoodfacts.org/';
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // URL açılamazsa kullanıcıya bilgi ver
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('URL açılamadı: $url'),
              backgroundColor: AppColors.of(context).red,
            ),
          );
        }
      }
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
