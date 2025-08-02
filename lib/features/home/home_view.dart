import 'package:arya/features/auth/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuthService authService = FirebaseAuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          TextButton(
            onPressed: () async {
              await authService.signOut();
            },
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
      body: const Center(child: Text('Hoş Geldiniz!')),
    );
  }
}
