import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatelessWidget {
  final FirebaseAuthService? authService;

  const LoginForm({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ProjectPadding.allMedium(),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProjectSizedBox.heightXLarge,
                const LoginTitle(),
                ProjectSizedBox.heightXLarge,
                const EmailField(),
                ProjectSizedBox.heightLarge,
                const PasswordField(),
                ForgotPasswordButton(
                  authService: authService ?? FirebaseAuthService(),
                ),
                if (viewModel.errorMessage != null)
                  ErrorMessage(message: viewModel.errorMessage!),
                ProjectSizedBox.heightXLarge,
                const LoginButton(),
                ProjectSizedBox.heightXLarge,
                _buildDivider(context),
                ProjectSizedBox.heightXLarge,
                const SignUpRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: scheme.outlineVariant)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ProjectSizedBox.customWidth(16).width!,
          ),
          child: Text(
            'veya',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
        Expanded(child: Divider(color: scheme.outlineVariant)),
      ],
    );
  }
}
