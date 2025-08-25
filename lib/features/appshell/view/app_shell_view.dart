import 'package:arya/features/index.dart';
import 'package:arya/product/index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = bottomInset > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          IndexedStack(index: vm.selectedIndex, children: _pages),
          if (!isKeyboardVisible)
            Positioned(
              left: 16,
              right: 16,
              bottom: 50,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: ProjectRadius.xBig,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.04),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: ProjectRadius.xBig,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: ProjectRadius.xBig,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNavItem(
                              icon: Icons.home_outlined,
                              activeIcon: Icons.home_rounded,
                              label: 'bottom.home'.tr(),
                              isSelected: vm.selectedIndex == 0,
                              onTap: () => vm.onItemTapped(0),
                            ),
                            _buildNavItem(
                              icon: Icons.store_outlined,
                              activeIcon: Icons.store_rounded,
                              label: 'bottom.store'.tr(),
                              isSelected: vm.selectedIndex == 1,
                              onTap: () => vm.onItemTapped(1),
                            ),
                            _buildNavItem(
                              icon: Icons.shopping_cart_outlined,
                              activeIcon: Icons.shopping_cart_rounded,
                              label: 'bottom.cart'.tr(),
                              isSelected: vm.selectedIndex == 2,
                              onTap: () => vm.onItemTapped(2),
                            ),
                            _buildNavItem(
                              icon: Icons.person_outline,
                              activeIcon: Icons.person_rounded,
                              label: 'bottom.profile'.tr(),
                              isSelected: vm.selectedIndex == 3,
                              onTap: () => vm.onItemTapped(3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.18,
            minHeight: MediaQuery.of(context).size.height * 0.06,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 28,
                color: isSelected
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.6),
              ),
              ProjectSizedBox.heightVerySmall, // 4px boşluk
              if (isSelected)
                Container(
                  width: 20,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: ProjectRadius.verySmall,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                )
              else
                ProjectSizedBox.customHeight(3), // 3px özel boyut
            ],
          ),
        ),
      ),
    );
  }
}
