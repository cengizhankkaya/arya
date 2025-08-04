import 'package:flutter/material.dart';
import 'package:arya/features/index.dart';

Future<void> showLogoutDialog(
  BuildContext context,
  ProfileViewModel viewModel,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Çıkış Yap'),
      content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Çıkış Yap'),
        ),
      ],
    ),
  );

  if (result == true) {
    await viewModel.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false,
      );
    }
  }
}
