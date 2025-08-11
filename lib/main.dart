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

void main() async {
  await ApplicationInitialize.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartViewModel())],
      child: MaterialApp(
        theme: CustomLightTheme().themeData,
        darkTheme: CustomDarkTheme().themeData,
        home:
            // OnBoardView(),
            StreamBuilder(
              stream: FirebaseAuthService().authStateChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  print("Kullanıcı giriş yaptı: ${snapshot.data}");
                  return MainPage();
                } else {
                  return const LoginView();
                }
              },
            ),
      ),
    );
  }
}
