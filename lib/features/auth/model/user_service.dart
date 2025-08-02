import 'package:arya/features/auth/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> creatDataUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      throw Exception('Kullanıcı verisi kaydedilemedi: $e');
    }
  }
}
