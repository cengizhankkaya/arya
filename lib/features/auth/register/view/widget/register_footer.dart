import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('auth.have_account'.tr()),
        TextButton(
          onPressed: () => context.router.pop(),
          child: Text('auth.sign_in'.tr()),
        ),
      ],
    );
  }
}
