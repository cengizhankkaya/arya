import 'package:auto_route/auto_route.dart';
import 'package:arya/features/index.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: OnBoardRoute.page, path: '/onboard', initial: false),
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: RegisterRoute.page, path: '/register'),
    AutoRoute(page: MainPageRoute.page, path: '/'),
    AutoRoute(page: CategoryRoute.page, path: '/categories'),
    AutoRoute(page: ProductsRoute.page, path: '/products'),
    AutoRoute(page: CartRoute.page, path: '/cart'),
    AutoRoute(page: ProfileRoute.page, path: '/profile'),
    AutoRoute(page: AddProductRoute.page, path: '/add-product'),
    AutoRoute(page: ProductDetailRoute.page, path: '/product-detail'),
    AutoRoute(page: OffCredentialsRoute.page, path: '/off-credentials'),
  ];
}
