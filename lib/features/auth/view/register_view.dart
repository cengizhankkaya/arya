import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/register_view_model.dart';
import '../auth_constants.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: const _RegisterViewBody(),
    );
  }
}

class _RegisterViewBody extends StatelessWidget {
  const _RegisterViewBody();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AuthConstants.registerTitle),
        centerTitle: true,
      ),
      body: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo veya başlık
                  const Icon(Icons.person_add, size: 80, color: Colors.blue),
                  const SizedBox(height: 32),
                  // // Ad alanı
                  TextFormField(
                    controller: viewModel.nameController,
                    decoration: InputDecoration(
                      labelText: AuthConstants.nameHint,
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: viewModel.validateName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  // Soyad alanı
                  TextFormField(
                    controller: viewModel.surnameController,
                    decoration: InputDecoration(
                      labelText: 'Soyad',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: viewModel.validateSurname,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  // E-posta alanı
                  TextFormField(
                    controller: viewModel.emailController,
                    decoration: InputDecoration(
                      labelText: AuthConstants.emailHint,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: viewModel.validateEmail,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  // Şifre alanı
                  TextFormField(
                    controller: viewModel.passwordController,
                    decoration: InputDecoration(
                      labelText: AuthConstants.passwordHint,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: viewModel.togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: viewModel.obscurePassword,
                    validator: viewModel.validatePassword,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  // Şifre tekrar alanı
                  TextFormField(
                    controller: viewModel.confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: AuthConstants.confirmPasswordHint,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewModel.obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: viewModel.toggleConfirmPasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: viewModel.obscureConfirmPassword,
                    validator: viewModel.validateConfirmPassword,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),

                  // Hata mesajı
                  if (viewModel.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        viewModel.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (viewModel.errorMessage != null)
                    const SizedBox(height: 16),

                  // Kayıt ol butonu
                  ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            final success = await viewModel.register();
                            if (success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(AuthConstants.registerSuccess),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.of(
                                context,
                              ).pop(); // Login sayfasına dön
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            AuthConstants.registerButtonText,
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 16),
                  // Giriş sayfasına yönlendirme
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AuthConstants.haveAccountText),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Login sayfasına dön
                        },
                        child: const Text(AuthConstants.signInText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
