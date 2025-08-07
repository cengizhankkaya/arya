import 'package:arya/features/index.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileViewModel>();

    return Column(
      children: [
        TextField(
          controller: viewModel.nameController,
          decoration: const InputDecoration(labelText: 'Ad'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: viewModel.surnameController,
          decoration: const InputDecoration(labelText: 'Soyad'),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: viewModel.usernameController,
          decoration: const InputDecoration(labelText: 'Kullanıcı Adı'),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.toggleEditMode(),
                child: const Text('İptal'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.updateUserFromControllers(),
                child: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
