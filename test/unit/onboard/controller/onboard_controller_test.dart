import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/onboard/view/controller/onboard_controller.dart';

void main() {
  group('OnboardController Tests', () {
    late OnboardController controller;

    setUp(() {
      controller = OnboardController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('OnboardController başlangıçta ilk sayfada olmalı', () {
      expect(controller.selectedIndex, 0);
      expect(controller.isFirstPage, true);
      expect(controller.isLastPage, false);
      expect(controller.totalPages, 3);
    });

    test('updateSelectedIndex() doğru çalışmalı', () {
      controller.updateSelectedIndex(2);
      expect(controller.selectedIndex, 2);

      controller.updateSelectedIndex(1);
      expect(controller.selectedIndex, 1);
    });

    test('isBackEnabled property doğru çalışmalı', () {
      expect(controller.isBackEnabled, false); // İlk sayfada

      controller.updateSelectedIndex(1);
      expect(controller.isBackEnabled, false); // Orta sayfada

      controller.updateSelectedIndex(2);
      expect(controller.isBackEnabled, true); // Son sayfada
    });

    test('isFirstPage ve isLastPage doğru çalışmalı', () {
      expect(controller.isFirstPage, true);
      expect(controller.isLastPage, false);

      controller.updateSelectedIndex(1);
      expect(controller.isFirstPage, false);
      expect(controller.isLastPage, false);

      controller.updateSelectedIndex(2);
      expect(controller.isFirstPage, false);
      expect(controller.isLastPage, true);
    });

    test('totalPages doğru değer döndürmeli', () {
      expect(controller.totalPages, 3);
    });

    test('selectedIndex getter doğru çalışmalı', () {
      expect(controller.selectedIndex, 0);

      controller.updateSelectedIndex(1);
      expect(controller.selectedIndex, 1);

      controller.updateSelectedIndex(2);
      expect(controller.selectedIndex, 2);
    });

    test(
      'updateSelectedIndex aynı indeks ile çağrıldığında değişiklik olmamalı',
      () {
        final initialIndex = controller.selectedIndex;
        controller.updateSelectedIndex(initialIndex);

        expect(controller.selectedIndex, initialIndex);
      },
    );
  });
}
