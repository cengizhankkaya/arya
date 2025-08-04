import 'package:flutter/material.dart';
import 'package:arya/features/auth/model/user_model.dart';
import 'package:arya/features/auth/service/user_service.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: FutureBuilder<UserModel?>(
        future: UserService().getUserData(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text("Kullanıcı verisi bulunamadı."));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ad: ${user.name}", style: const TextStyle(fontSize: 18)),
                Text(
                  "Soyad: ${user.surname}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Kullanıcı Adı: ${user.username}",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "Email: ${user.email}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
