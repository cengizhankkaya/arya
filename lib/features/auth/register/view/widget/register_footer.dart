import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AuthConstants.haveAccountText),
        TextButton(
          onPressed: () => context.router.pop(),
          child: const Text(AuthConstants.signInText),
        ),
      ],
    );
  }
}
