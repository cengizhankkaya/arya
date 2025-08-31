import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/onboard/view/controller/onboard_controller.dart';

void main() {
  group('Onboard Navigation Integration Tests', () {
    // Test 1: OnboardController test ortamında oluşturulabiliyor mu?
    testWidgets('OnboardController test ortamında oluşturulabilmeli', (
      tester,
    ) async {
      // ARRANGE: OnboardController oluştur
      final controller = OnboardController();

      // ASSERT: Controller başarıyla oluşturuldu mu?
      expect(controller, isNotNull);
      expect(controller, isA<OnboardController>());
    });

    // Test 2: OnboardController başlangıç durumu doğru mu?
    testWidgets('OnboardController başlangıç durumu doğru olmalı', (
      tester,
    ) async {
      // ARRANGE: OnboardController oluştur
      final controller = OnboardController();

      // ASSERT: Başlangıç durumu doğru mu?
      expect(controller.selectedIndex, 0);
      expect(controller.isFirstPage, true);
      expect(controller.isLastPage, false);
      expect(controller.totalPages, 3);
    });

    // Test 3: OnboardController state management çalışıyor mu?
    testWidgets('OnboardController state management çalışmalı', (tester) async {
      // ARRANGE: OnboardController oluştur
      final controller = OnboardController();

      // ACT: State'i güncelle
      controller.updateSelectedIndex(1);

      // ASSERT: State güncellendi mi?
      expect(controller.selectedIndex, 1);
      expect(controller.isFirstPage, false);
      expect(controller.isLastPage, false);
    });

    // Test 4: OnboardController son sayfa durumu doğru mu?
    testWidgets('OnboardController son sayfa durumu doğru olmalı', (
      tester,
    ) async {
      // ARRANGE: OnboardController oluştur
      final controller = OnboardController();

      // ACT: Son sayfaya git
      controller.updateSelectedIndex(2);

      // ASSERT: Son sayfa durumu doğru mu?
      expect(controller.selectedIndex, 2);
      expect(controller.isFirstPage, false);
      expect(controller.isLastPage, true);
    });

    // Test 5: OnboardController back enabled property doğru mu?
    testWidgets('OnboardController back enabled property doğru çalışmalı', (
      tester,
    ) async {
      // ARRANGE: OnboardController oluştur
      final controller = OnboardController();

      // ASSERT: İlk sayfada back enabled false olmalı
      expect(controller.isBackEnabled, false);

      // ACT: Orta sayfaya git
      controller.updateSelectedIndex(1);

      // ASSERT: Orta sayfada back enabled false olmalı
      expect(controller.isBackEnabled, false);

      // ACT: Son sayfaya git
      controller.updateSelectedIndex(2);

      // ASSERT: Son sayfada back enabled true olmalı
      expect(controller.isBackEnabled, true);
    });

    // Test 6: OnboardController page count doğru mu?
    testWidgets('OnboardController page count doğru olmalı', (tester) async {
      // ARRANGE: OnboardController oluştur
      final controller = OnboardController();

      // ASSERT: Sayfa sayısı doğru mu?
      expect(controller.totalPages, 3);
      expect(controller.totalPages, isPositive);
      expect(controller.totalPages, isA<int>());
    });

    // Test 7: OnboardController index bounds kontrolü
    testWidgets('OnboardController index bounds kontrolü doğru olmalı', (
      tester,
    ) async {
      // ARRANGE: OnboardController oluştur
      final controller = OnboardController();

      // ASSERT: Index bounds doğru mu?
      expect(controller.selectedIndex, greaterThanOrEqualTo(0));
      expect(controller.selectedIndex, lessThan(controller.totalPages));
    });
  });
}
