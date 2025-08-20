import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'features/index.dart';
import 'product/index.dart';
import 'package:auto_route/auto_route.dart';
import 'product/navigation/app_router.dart';

void main() async {
  await ApplicationInitialize.init();
  await ApplicationInitialize.localization();
  runApp(ProductLocalization(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartViewModel())],
      child: MaterialApp.router(
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        theme: CustomLightTheme().themeData,
        darkTheme: CustomDarkTheme().themeData,
        routerConfig: appRouter.config(
          // auth durumları için guard'ların reevaluate edilebilmesi
          // için stream'i dinletiyoruz
          reevaluateListenable: ReevaluateListenable.stream(
            FirebaseAuthService().authStateChanges,
          ),
          navigatorObservers: () => [AutoRouteObserver()],
        ),
      ),
    );
  }
}
