import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/auth/view/profile_view.dart';
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
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('Hoş Geldiniz!')),
    );
  }
}
