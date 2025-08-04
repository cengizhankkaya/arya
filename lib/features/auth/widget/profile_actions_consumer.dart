// lib/features/auth/widget/dialogs/profile_actions_consumer.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arya/features/auth/view_model/profile_view_model.dart';
import 'package:arya/features/auth/widget/dialogs/logout_dialog.dart';
import 'package:arya/features/auth/widget/dialogs/delete_account_dialog.dart';

class ProfileActionsConsumer extends StatelessWidget {
  const ProfileActionsConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, child) {
        if (!viewModel.hasUser) return const SizedBox.shrink();

        return PopupMenuButton<String>(
          onSelected: (value) async {
            switch (value) {
              case 'edit':
                viewModel.toggleEditMode();
                break;
              case 'logout':
                await showLogoutDialog(context, viewModel);
                break;
              case 'delete':
                await showDeleteAccountDialog(context, viewModel);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Düzenle'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Çıkış Yap'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_forever, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hesabı Sil', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
