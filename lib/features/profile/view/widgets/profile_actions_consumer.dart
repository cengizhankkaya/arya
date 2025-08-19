import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:arya/product/navigation/app_router.dart';

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
              case 'off':
                context.router.push(const OffCredentialsRoute());
                break;
              case 'language':
                await showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('dialogs.language.title'.tr()),
                    actions: [
                      TextButton(
                        onPressed: () {
                          ProductLocalization.updateLanguage(
                            context: context,
                            value: Locales.tr,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('dialogs.language.turkish'.tr()),
                      ),
                      TextButton(
                        onPressed: () {
                          ProductLocalization.updateLanguage(
                            context: context,
                            value: Locales.en,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('dialogs.language.english'.tr()),
                      ),
                    ],
                  ),
                );
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
                  Text('general.button.edit'.tr()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'language',
              child: Row(
                children: [
                  Icon(Icons.language),
                  SizedBox(width: 8),
                  Text('settings.language'.tr()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'off',
              child: Row(
                children: [
                  Icon(Icons.key),
                  SizedBox(width: 8),
                  Text('appbar.off_account'.tr()),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('general.button.logout'.tr()),
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
                    'general.button.delete_account'.tr(),
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
