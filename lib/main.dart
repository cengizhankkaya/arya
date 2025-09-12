import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'product/index.dart';
import 'product/utility/theme/theme_view_model.dart';

void main() async {
  await ApplicationInitialize.init();
  runApp(ProductLocalization(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: CustomLightTheme().themeData,
            darkTheme: CustomDarkTheme().themeData,
            themeMode: themeViewModel.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            routerConfig: appRouter.config(
              reevaluateListenable: ReevaluateListenable.stream(
                FirebaseAuthService().authStateChanges,
              ),
              navigatorObservers: () => [AutoRouteObserver()],
            ),
          );
        },
      ),
    );
  }
}
