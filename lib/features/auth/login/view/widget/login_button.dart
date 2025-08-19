import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:arya/product/navigation/app_router.dart';

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
                context.router.replaceAll([const MainPageRoute()]);
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
          : Text(
              AuthConstants.loginButtonText,
              style: Theme.of(context).textTheme.labelLarge,
            ),
    );
  }
}
