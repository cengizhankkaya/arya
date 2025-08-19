import 'package:arya/features/index.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        return TextFormField(
          controller: viewModel.passwordController,
          obscureText: viewModel.obscurePassword,
          decoration: InputDecoration(
            labelText: AuthConstants.passwordHint,
            hintText: AuthConstants.passwordHintText,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                viewModel.obscurePassword
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: viewModel.togglePasswordVisibility,
            ),
            border: OutlineInputBorder(borderRadius: ProjectRadius.large),
          ),
          validator: viewModel.validatePassword,
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}
