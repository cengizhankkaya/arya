import 'package:arya/product/index.dart';
import 'package:arya/features/auth/widget/dialogs/forgot_password_dialog.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ForgotPasswordButton extends StatelessWidget {
  final FirebaseAuthService? authService;

  const ForgotPasswordButton({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ForgotPasswordDialog(
              authService: authService ?? FirebaseAuthService(),
            ),
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
