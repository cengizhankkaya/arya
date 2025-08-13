import 'package:arya/features/auth/login/view/login_view.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/main_page/main_page.dart';

import 'package:arya/features/onboard/view/onboard_view.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/product/init/application_initialize.dart';
import 'package:arya/product/theme/custom_dark_theme.dart';
import 'package:arya/product/theme/custom_light_theme.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arya/product/utility/storage/app_prefs.dart';

void main() async {
  await ApplicationInitialize.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool> _hasCompletedOnboarding() => AppPrefs.getHasOnboarded();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartViewModel())],
      child: MaterialApp(
        theme: CustomLightTheme().themeData,
        darkTheme: CustomDarkTheme().themeData,
        home: FutureBuilder<bool>(
          future: _hasCompletedOnboarding(),
          builder: (context, onboardingSnapshot) {
            if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final hasCompletedOnboarding = onboardingSnapshot.data ?? false;
            if (!hasCompletedOnboarding) {
              return const OnBoardView();
            }
            return StreamBuilder(
              stream: FirebaseAuthService().authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return MainPage();
                } else {
                  return const LoginView();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
