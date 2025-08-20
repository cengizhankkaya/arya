import 'package:arya/features/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arya/product/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/app_shell_view_model.dart';

@RoutePage()
class AppShellView extends StatefulWidget implements AutoRouteWrapper {
  const AppShellView({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppShellViewModel(),
      child: this,
    );
  }

  @override
  State<AppShellView> createState() => _AppShellViewState();
}

class _AppShellViewState extends State<AppShellView> {
  final List<Widget> _pages = [
    CategoryScreen(),
    ProductsPage(),
    CartView(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AppShellViewModel>();
    return Scaffold(
      body: IndexedStack(index: vm.selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor:
              Theme.of(context).extension<AppColors>()?.textMuted ??
              Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          selectedLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: AppTypography.labelWeight,
          ),
          unselectedLabelStyle: Theme.of(context).textTheme.labelMedium
              ?.copyWith(fontWeight: AppTypography.bodyWeight),
          currentIndex: vm.selectedIndex,
          onTap: vm.onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'bottom.home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'bottom.store'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'bottom.cart'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'bottom.profile'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
