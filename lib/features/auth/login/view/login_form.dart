import 'package:arya/features/auth/login/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arya/product/constants/project_padding.dart';

import 'email_field.dart';
import 'password_field.dart';
import 'login_button.dart';
import 'login_title.dart';
import 'forgot_password_button.dart';
import 'error_message.dart';
import 'sign_up_row.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ProjectPadding.allMedium(),
          child: Form(
            key: viewModel.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.1),
                const LoginTitle(),
                SizedBox(height: size.height * 0.08),
                const EmailField(),
                const SizedBox(height: 20),
                const PasswordField(),
                const ForgotPasswordButton(),
                if (viewModel.errorMessage != null)
                  ErrorMessage(message: viewModel.errorMessage!),
                const SizedBox(height: 24),
                const LoginButton(),
                const SizedBox(height: 24),
                _buildDivider(context),
                const SizedBox(height: 24),
                const SignUpRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('veya', style: TextStyle(color: Colors.grey[600])),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }
}
