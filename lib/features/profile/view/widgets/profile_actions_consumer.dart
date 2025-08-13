import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Düzenle'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Çıkış Yap'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hesabı Sil',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
