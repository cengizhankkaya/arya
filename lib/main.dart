import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'features/index.dart';
import 'product/index.dart';

void main() async {
  await ApplicationInitialize.init();
  await ApplicationInitialize.localization();
  runApp(ProductLocalization(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<bool> _hasCompletedOnboarding() => AppPrefs.getHasOnboarded();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartViewModel())],
      child: MaterialApp(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
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
