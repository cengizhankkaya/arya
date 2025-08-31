import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/firebase_options.dart';

class ApplicationInitialize {
  static Future<void> init() async {
    try {
      await _initFlutterBinding();
      await _initLocalization();
      await _initFirebase();
      debugPrint('✅ ApplicationInitialize başarıyla tamamlandı');
    } catch (e) {
      debugPrint('❌ ApplicationInitialize hatası: $e');
      rethrow;
    }
  }

  static Future<void> _initFlutterBinding() async {
    WidgetsFlutterBinding.ensureInitialized();
    debugPrint('✅ Flutter binding başarıyla başlatıldı');
  }

  static Future<void> _initLocalization() async {
    await EasyLocalization.ensureInitialized();
    debugPrint('✅ Localization başarıyla başlatıldı');
  }

  static Future<void> _initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ Firebase başarıyla başlatıldı');
    } catch (e) {
      debugPrint('❌ Firebase başlatma hatası: $e');
      rethrow;
    }
  }
}
