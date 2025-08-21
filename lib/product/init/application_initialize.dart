import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ApplicationInitialize {
  static Future<void> init() async {
    try {
      await _initFirebase();
      debugPrint('✅ ApplicationInitialize başarıyla tamamlandı');
    } catch (e) {
      debugPrint('❌ ApplicationInitialize hatası: $e');
      rethrow;
    }
  }

  static Future<void> _initFirebase() async {
    try {
      await Firebase.initializeApp();
      debugPrint('✅ Firebase başarıyla başlatıldı');
    } catch (e) {
      debugPrint('❌ Firebase başlatma hatası: $e');
      rethrow;
    }
  }
}
