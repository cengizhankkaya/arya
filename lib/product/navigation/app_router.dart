import 'package:auto_route/auto_route.dart';
import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
part 'app_router.gr.dart';

class OnboardingGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final hasCompletedOnboarding = await AppPrefs.getHasOnboarded();
    if (!hasCompletedOnboarding) {
      await resolver.redirectUntil(const OnBoardRoute());
      return;
    }
    resolver.next(true);
  }
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isAuthenticated = FirebaseAuthService().currentUser != null;
    if (!isAuthenticated) {
      await resolver.redirectUntil(const LoginRoute());
      return;
    }
    resolver.next(true);
  }
}

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});

  final OnboardingGuard _onboardingGuard = OnboardingGuard();
  final AuthGuard _authGuard = AuthGuard();

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: OnBoardRoute.page, path: '/onboard', initial: false),
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
      guards: [_onboardingGuard],
    ),
    AutoRoute(
      page: RegisterRoute.page,
      path: '/register',
      guards: [_onboardingGuard],
    ),
    AutoRoute(
      page: AppShellRoute.page,
      path: '/',
      guards: [_onboardingGuard, _authGuard],
    ),
    AutoRoute(
      page: CategoryRoute.page,
      path: '/categories',
      guards: [_onboardingGuard, _authGuard],
    ),
    AutoRoute(
      page: ProductsRoute.page,
      path: '/products',
      guards: [_onboardingGuard, _authGuard],
    ),
    AutoRoute(
      page: CartRoute.page,
      path: '/cart',
      guards: [_onboardingGuard, _authGuard],
    ),
    AutoRoute(
      page: ProfileRoute.page,
      path: '/profile',
      guards: [_onboardingGuard, _authGuard],
    ),
    AutoRoute(
      page: AddProductRoute.page,
      path: '/add-product',
      guards: [_onboardingGuard, _authGuard],
    ),
    AutoRoute(
      page: ProductDetailRoute.page,
      path: '/product-detail',
      guards: [_onboardingGuard, _authGuard],
    ),
    AutoRoute(
      page: OffCredentialsRoute.page,
      path: '/off-credentials',
      guards: [_onboardingGuard, _authGuard],
    ),
  ];
}
