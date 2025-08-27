import 'package:arya/product/index.dart';
import 'package:arya/features/auth/widget/dialogs/forgot_password_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const ForgotPasswordDialog(),
          );
        },
        child: Text(
          'auth.forgot_password'.tr(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: AppTypography.labelWeight,
          ),
        ),
      ),
    );
  }
}
