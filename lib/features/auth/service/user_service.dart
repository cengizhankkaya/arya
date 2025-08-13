import 'package:arya/features/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Kullanıcı verilerini Firestore'a kaydetme
  Future<void> createDataUser(UserModel user) async {
    try {
      print('🔥 Firestore kayıt başlıyor...');
      print('📝 User ID: ${user.uid}');
      print('📧 Email: ${user.email}');
      print('👤 Name: ${user.name}');
      print('👤 Surname: ${user.surname}');
      print('👤 Username: ${user.username}');

      final userData = user.toJson();
      print('📊 User Data: $userData');

      await _firestore.collection('users').doc(user.uid).set(userData);
      print('✅ Firestore kayıt başarılı!');
    } catch (e) {
      print('❌ Firestore kayıt hatası: $e');
      print('🔍 Hata detayı: ${e.toString()}');

      if (e.toString().contains('permission-denied')) {
        throw Exception(
          'Firestore izin hatası: Güvenlik kurallarını kontrol edin',
        );
      } else if (e.toString().contains('network')) {
        throw Exception(
          'Ağ bağlantısı hatası: İnternet bağlantınızı kontrol edin',
        );
      } else {
        throw Exception('Kullanıcı verisi kaydedilemedi: $e');
      }
    }
  }

  /// Kullanıcı verilerini Firestore'dan okuma
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ Firestore okuma hatası: $e');
      if (e.toString().contains('permission-denied')) {
        throw Exception(
          'Firestore izin hatası: Güvenlik kurallarını kontrol edin',
        );
      }
      throw Exception('Kullanıcı verisi okunamadı: $e');
    }
  }

  /// Kullanıcı verilerini güncelleme
  Future<void> updateUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update(user.toJson());
    } catch (e) {
      print('❌ Firestore güncelleme hatası: $e');
      if (e.toString().contains('permission-denied')) {
        throw Exception(
          'Firestore izin hatası: Güvenlik kurallarını kontrol edin',
        );
      }
      throw Exception('Kullanıcı verisi güncellenemedi: $e');
    }
  }

  /// Kullanıcı verilerini silme
  Future<void> deleteUserData(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
    } catch (e) {
      print('❌ Firestore silme hatası: $e');
      if (e.toString().contains('permission-denied')) {
        throw Exception(
          'Firestore izin hatası: Güvenlik kurallarını kontrol edin',
        );
      }
      throw Exception('Kullanıcı verisi silinemedi: $e');
    }
  }

  /// E-posta adresine göre kullanıcı arama
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return UserModel.fromJson(query.docs.first.data());
      }
      return null;
    } catch (e) {
      print('❌ E-posta arama hatası: $e');
      if (e.toString().contains('permission-denied')) {
        throw Exception(
          'Firestore izin hatası: Güvenlik kurallarını kontrol edin',
        );
      }
      throw Exception('E-posta ile kullanıcı aranamadı: $e');
    }
  }

  /// Kullanıcı adına göre kullanıcı arama
  Future<UserModel?> getUserByUsername(String username) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return UserModel.fromJson(query.docs.first.data());
      }
      return null;
    } catch (e) {
      print('❌ Kullanıcı adı arama hatası: $e');
      if (e.toString().contains('permission-denied')) {
        throw Exception(
          'Firestore izin hatası: Güvenlik kurallarını kontrol edin',
        );
      }
      throw Exception('Kullanıcı adı ile kullanıcı aranamadı: $e');
    }
  }
}
