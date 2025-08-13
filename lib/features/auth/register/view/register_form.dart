import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RegisterViewModel>(context);

    return SafeArea(
      child: Padding(
        padding: ProjectPadding.allSmall(),
        child: Form(
          key: vm.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.person_add,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 32),

                RegisterTextField(
                  controller: vm.nameController,
                  label: AuthConstants.nameHint,
                  icon: Icons.person,
                  validator: vm.validateName,
                ),
                const SizedBox(height: 16),

                RegisterTextField(
                  controller: vm.surnameController,
                  label: AuthConstants.surnameHint,
                  icon: Icons.person_outline,
                  validator: vm.validateSurname,
                ),
                const SizedBox(height: 16),

                RegisterTextField(
                  controller: vm.emailController,
                  label: AuthConstants.emailHint,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: vm.validateEmail,
                ),
                const SizedBox(height: 16),

                RegisterPasswordField(
                  controller: vm.passwordController,
                  label: AuthConstants.passwordHint,
                  obscureText: vm.obscurePassword,
                  onToggle: vm.togglePasswordVisibility,
                  validator: vm.validatePassword,
                ),
                const SizedBox(height: 16),

                RegisterPasswordField(
                  controller: vm.confirmPasswordController,
                  label: AuthConstants.confirmPasswordHint,
                  obscureText: vm.obscureConfirmPassword,
                  onToggle: vm.toggleConfirmPasswordVisibility,
                  validator: vm.validateConfirmPassword,
                ),
                const SizedBox(height: 24),

                if (vm.errorMessage != null)
                  RegisterErrorBox(message: vm.errorMessage!),
                const SizedBox(height: 16),
                const RegisterButton(),
                const SizedBox(height: 16),
                const RegisterFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
