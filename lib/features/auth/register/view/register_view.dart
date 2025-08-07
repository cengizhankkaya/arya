import 'package:arya/features/auth/auth_constants.dart';
import 'package:arya/features/auth/register/view/register_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/register_view_model.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AuthConstants.registerTitle),
          centerTitle: true,
        ),
        body: const RegisterForm(),
      ),
    );
  }
}
