import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';

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
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
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
