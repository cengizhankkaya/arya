import 'package:arya/features/auth/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';

Future<void> showDeleteAccountDialog(
  BuildContext context,
  ProfileViewModel viewModel,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Hesabı Sil'),
      content: const Text(
        'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz!',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('İptal'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Hesabı Sil'),
        ),
      ],
    ),
  );

  if (result == true) {
    await viewModel.deleteAccount();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false,
      );
    }
  }
}
