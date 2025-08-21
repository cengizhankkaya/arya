import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class SignUpRow extends StatelessWidget {
  const SignUpRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AuthConstants.noAccountText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(padding: ProjectPadding.verticalNormal),
          onPressed: () {
            context.router.push(const RegisterRoute());
          },
          child: Text(
            AuthConstants.signUpText,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
