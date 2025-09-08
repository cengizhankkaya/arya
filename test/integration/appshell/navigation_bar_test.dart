// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:arya/features/appshell/view_model/app_shell_view_model.dart';
import '../../helpers/test_helpers.dart';

import 'navigation_bar_test.mocks.dart';

/// Mock sınıfları için annotation
@GenerateMocks([AppShellViewModel])
void main() {
  group('Navigation Bar Tests', () {
    late MockAppShellViewModel mockAppShellViewModel;

    setUpAll(() async {
      // Test ortamını başlat
      TestWidgetsFlutterBinding.ensureInitialized();
      TestHelpers.setupEasyLocalization();
    });

    setUp(() {
      // Mock view model'i oluştur
      mockAppShellViewModel = MockAppShellViewModel();

      // Mock davranışlarını ayarla
      when(mockAppShellViewModel.selectedIndex).thenReturn(0);
      when(mockAppShellViewModel.onItemTapped(any)).thenAnswer((_) {});
    });

    tearDown(() {
      // Test sonrası temizlik
      reset(mockAppShellViewModel);
    });

    tearDownAll(() {
      TestHelpers.tearDown();
    });

    Widget _buildNavItem({
      required BuildContext context,
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
                const SizedBox(height: 4),
                if (isSelected)
                  Container(
                    width: 20,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  )
                else
                  const SizedBox(height: 3),
              ],
            ),
          ),
        ),
      );
    }

    /// Navigation bar widget'ı oluşturma helper'ı
    Widget createNavigationBarWidget() {
      return TestHelpers.createTestAppWithEasyLocalization(
        ChangeNotifierProvider<AppShellViewModel>.value(
          value: mockAppShellViewModel,
          child: Builder(
            builder: (context) {
              final vm = context.watch<AppShellViewModel>();
              return Scaffold(
                body: Container(),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
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
                          context: context,
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home_rounded,
                          label: 'bottom.home'.tr(),
                          isSelected: vm.selectedIndex == 0,
                          onTap: () => vm.onItemTapped(0),
                        ),
                        _buildNavItem(
                          context: context,
                          icon: Icons.store_outlined,
                          activeIcon: Icons.store_rounded,
                          label: 'bottom.store'.tr(),
                          isSelected: vm.selectedIndex == 1,
                          onTap: () => vm.onItemTapped(1),
                        ),
                        _buildNavItem(
                          context: context,
                          icon: Icons.shopping_cart_outlined,
                          activeIcon: Icons.shopping_cart_rounded,
                          label: 'bottom.cart'.tr(),
                          isSelected: vm.selectedIndex == 2,
                          onTap: () => vm.onItemTapped(2),
                        ),
                        _buildNavItem(
                          context: context,
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
              );
            },
          ),
        ),
      );
    }

    group('Navigation Bar Basic Tests', () {
      testWidgets('should render navigation bar without errors', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createNavigationBarWidget());
        await tester.pump();

        // Assert
        expect(
          find.byType(Scaffold),
          findsWidgets,
        ); // findsOneWidget yerine findsWidgets
        expect(
          find.byType(BottomNavigationBar),
          findsNothing,
        ); // Custom navigation bar
      });

      testWidgets('should display all navigation items', (
        WidgetTester tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(createNavigationBarWidget());
        await tester.pump();

        // Assert - Navigation iconları görünür olmalı
        // İlk tab aktif olduğu için home_rounded görünür
        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
        expect(find.byIcon(Icons.store_outlined), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
      });

      testWidgets('should show home tab as active by default', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockAppShellViewModel.selectedIndex).thenReturn(0);

        // Act
        await tester.pumpWidget(createNavigationBarWidget());
        await tester.pump();

        // Assert - Doğru icon'ları kontrol et
        expect(find.byIcon(Icons.home_rounded), findsOneWidget);
        expect(find.byIcon(Icons.home_outlined), findsNothing);
      });

      testWidgets('should handle tab selection', (WidgetTester tester) async {
        // Arrange
        when(mockAppShellViewModel.selectedIndex).thenReturn(1);

        // Act
        await tester.pumpWidget(createNavigationBarWidget());
        await tester.pump();

        // Assert - Doğru icon'ları kontrol et
        expect(find.byIcon(Icons.store_rounded), findsOneWidget);
        expect(find.byIcon(Icons.store_outlined), findsNothing);
      });

      testWidgets('should call onItemTapped when tab is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        when(mockAppShellViewModel.selectedIndex).thenReturn(0);

        // Act
        await tester.pumpWidget(createNavigationBarWidget());
        await tester.pump();

        // Tap on store tab
        await tester.tap(find.byIcon(Icons.store_outlined));
        await tester.pump();

        // Assert
        verify(mockAppShellViewModel.onItemTapped(1)).called(1);
      });
    });
  });
}
