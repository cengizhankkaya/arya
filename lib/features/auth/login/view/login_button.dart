import 'package:arya/features/auth/login/index.dart';
import 'package:arya/features/index.dart';
import 'package:arya/features/main_page/main_page.dart';

import 'package:arya/product/index.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return ElevatedButton(
      onPressed: viewModel.isLoading
          ? null
          : () async {
              final success = await viewModel.login();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(AuthConstants.loginSuccess)),
                );
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const MainPage()),
                  (route) => false,
                );
              }
            },
      style: ElevatedButton.styleFrom(
        padding: ProjectPadding.verticalNormal,
        shape: RoundedRectangleBorder(borderRadius: ProjectRadius.large),
      ),
      child: viewModel.isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          : const Text(
              AuthConstants.loginButtonText,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }
}
