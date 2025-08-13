import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AuthConstants.haveAccountText),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AuthConstants.signInText),
        ),
      ],
    );
  }
}
