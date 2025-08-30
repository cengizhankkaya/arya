import 'package:arya/features/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginView extends StatelessWidget {
  final FirebaseAuthService? authService;

  const LoginView({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: _LoginViewBody(authService: authService ?? FirebaseAuthService()),
    );
  }
}

class _LoginViewBody extends StatelessWidget {
  final FirebaseAuthService authService;

  const _LoginViewBody({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(child: LoginForm(authService: authService)),
    );
  }
}
