import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:arya/product/navigation/app_router.dart';

Future<void> showDeleteAccountDialog(
  BuildContext context,
  ProfileViewModel viewModel,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('dialogs.delete_account.title'.tr()),
      content: Text('dialogs.delete_account.content'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('general.button.cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          child: Text('general.button.delete_account'.tr()),
        ),
      ],
    ),
  );

  if (result == true) {
    await viewModel.deleteAccount();
    if (context.mounted) {
      context.router.replaceAll([const LoginRoute()]);
    }
  }
}
