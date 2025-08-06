import 'package:arya/features/index.dart';
import 'package:arya/features/store/view/store_view.dart';
import 'package:arya/features/store/view_model/cart_view_model.dart';
import 'package:arya/product/init/application_initialize.dart';

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
              return ProductsPage();
            } else {
              return const LoginView();
            }
          },
        ),
      ),
    );
  }
}
