import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WelcomeDialog extends StatelessWidget {
  final VoidCallback onNavigateToCredentials;

  const WelcomeDialog({super.key, required this.onNavigateToCredentials});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('welcome_dialog.title'.tr()),
      content: Text('welcome_dialog.content'.tr()),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('welcome_dialog.later'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onNavigateToCredentials();
          },
          child: Text('welcome_dialog.enter_credentials'.tr()),
        ),
      ],
    );
  }
}
