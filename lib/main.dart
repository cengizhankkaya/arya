import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/auth/view/login_view.dart';
import 'package:arya/features/home/home_view.dart';
import 'package:arya/product/init/application_initialize.dart';
import 'package:flutter/material.dart';

void main() async {
  await ApplicationInitialize.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder(
        stream: FirebaseAuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomeView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}
