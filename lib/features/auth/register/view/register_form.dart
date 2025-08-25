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
                LottieLoader(
                  path: LottiePaths.onRegister,
                  width: 120,
                  height: 120,
                ),
                ProjectSizedBox.heightXXLarge,

                RegisterTextField(
                  controller: vm.nameController,
                  label: AuthConstants.nameHint,
                  icon: Icons.person,
                  validator: vm.validateName,
                ),
                ProjectSizedBox.heightMedium,

                RegisterTextField(
                  controller: vm.surnameController,
                  label: AuthConstants.surnameHint,
                  icon: Icons.person_outline,
                  validator: vm.validateSurname,
                ),
                ProjectSizedBox.heightMedium,

                RegisterTextField(
                  controller: vm.emailController,
                  label: AuthConstants.emailHint,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: vm.validateEmail,
                ),
                ProjectSizedBox.heightMedium,

                RegisterPasswordField(
                  controller: vm.passwordController,
                  label: AuthConstants.passwordHint,
                  obscureText: vm.obscurePassword,
                  onToggle: vm.togglePasswordVisibility,
                  validator: vm.validatePassword,
                ),
                ProjectSizedBox.heightMedium,

                RegisterPasswordField(
                  controller: vm.confirmPasswordController,
                  label: AuthConstants.confirmPasswordHint,
                  obscureText: vm.obscureConfirmPassword,
                  onToggle: vm.toggleConfirmPasswordVisibility,
                  validator: vm.validateConfirmPassword,
                ),
                ProjectSizedBox.heightXLarge,

                if (vm.errorMessage != null)
                  RegisterErrorBox(message: vm.errorMessage!),
                ProjectSizedBox.heightMedium,
                const RegisterButton(),
                ProjectSizedBox.heightMedium,
                const RegisterFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
