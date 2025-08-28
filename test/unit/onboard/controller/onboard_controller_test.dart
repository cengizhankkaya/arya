import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:arya/features/onboard/view/controller/onboard_controller.dart';

void main() {
  group('OnboardController Tests', () {
    late OnboardController controller;

    setUp(() {
      controller = OnboardController();
    });

    tearDown(() {
      // Controller zaten dispose edilmiş olabilir, güvenli dispose
      try {
        controller.dispose();
      } catch (e) {
        // Controller zaten dispose edilmiş, hata verme
      }
    });

    group('Initial State Tests', () {
      test('OnboardController başlangıçta ilk sayfada olmalı', () {
        expect(controller.selectedIndex, 0);
        expect(controller.isFirstPage, true);
        expect(controller.isLastPage, false);
        expect(controller.totalPages, 3);
        expect(controller.isBackEnabled, false);
      });

      test('totalPages doğru değer döndürmeli', () {
        expect(controller.totalPages, 3);
      });
    });

    group('updateSelectedIndex Tests', () {
      test('updateSelectedIndex() doğru çalışmalı', () {
        controller.updateSelectedIndex(2);
        expect(controller.selectedIndex, 2);

        controller.updateSelectedIndex(1);
        expect(controller.selectedIndex, 1);
      });

      test(
        'updateSelectedIndex aynı indeks ile çağrıldığında değişiklik olmamalı',
        () {
          final initialIndex = controller.selectedIndex;
          controller.updateSelectedIndex(initialIndex);

          expect(controller.selectedIndex, initialIndex);
        },
      );

      test(
        'updateSelectedIndex geçersiz indeks ile çağrıldığında değişiklik olmamalı',
        () {
          final initialIndex = controller.selectedIndex;

          // Negatif indeks
          controller.updateSelectedIndex(-1);
          expect(controller.selectedIndex, initialIndex);

          // Çok büyük indeks
          controller.updateSelectedIndex(10);
          expect(controller.selectedIndex, initialIndex);
        },
      );
    });

    group('Navigation Tests', () {
      test('nextPage() doğru çalışmalı', () {
        expect(controller.selectedIndex, 0);

        controller.nextPage();
        expect(controller.selectedIndex, 1);
        expect(controller.isFirstPage, false);
        expect(controller.isLastPage, false);

        controller.nextPage();
        expect(controller.selectedIndex, 2);
        expect(controller.isFirstPage, false);
        expect(controller.isLastPage, true);
      });

      test('nextPage() son sayfada çağrıldığında değişiklik olmamalı', () {
        controller.updateSelectedIndex(2); // Son sayfaya git
        expect(controller.selectedIndex, 2);

        controller.nextPage(); // Son sayfada next çağır
        expect(controller.selectedIndex, 2); // Değişmemeli
      });

      test('previousPage() doğru çalışmalı', () {
        controller.updateSelectedIndex(2); // Son sayfaya git
        expect(controller.selectedIndex, 2);

        controller.previousPage();
        expect(controller.selectedIndex, 1);
        expect(controller.isFirstPage, false);
        expect(controller.isLastPage, false);

        controller.previousPage();
        expect(controller.selectedIndex, 0);
        expect(controller.isFirstPage, true);
        expect(controller.isLastPage, false);
      });

      test('previousPage() ilk sayfada çağrıldığında değişiklik olmamalı', () {
        expect(controller.selectedIndex, 0);

        controller.previousPage(); // İlk sayfada previous çağır
        expect(controller.selectedIndex, 0); // Değişmemeli
      });

      test('goToPage() doğru çalışmalı', () {
        controller.goToPage(2);
        expect(controller.selectedIndex, 2);
        expect(controller.isLastPage, true);

        controller.goToPage(1);
        expect(controller.selectedIndex, 1);
        expect(controller.isFirstPage, false);
        expect(controller.isLastPage, false);

        controller.goToPage(0);
        expect(controller.selectedIndex, 0);
        expect(controller.isFirstPage, true);
      });

      test(
        'goToPage() geçersiz indeks ile çağrıldığında değişiklik olmamalı',
        () {
          final initialIndex = controller.selectedIndex;

          // Negatif indeks
          controller.goToPage(-1);
          expect(controller.selectedIndex, initialIndex);

          // Çok büyük indeks
          controller.goToPage(10);
          expect(controller.selectedIndex, initialIndex);
        },
      );

      test('skipToLastPage() doğru çalışmalı', () {
        expect(controller.selectedIndex, 0);

        controller.skipToLastPage();
        expect(controller.selectedIndex, 2);
        expect(controller.isLastPage, true);
        expect(controller.isFirstPage, false);
      });
    });

    group('State Properties Tests', () {
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

      test('selectedIndex getter doğru çalışmalı', () {
        expect(controller.selectedIndex, 0);

        controller.updateSelectedIndex(1);
        expect(controller.selectedIndex, 1);

        controller.updateSelectedIndex(2);
        expect(controller.selectedIndex, 2);
      });
    });

    group('PageController Tests', () {
      test('pageController doğru şekilde oluşturulmalı', () {
        expect(controller.pageController, isNotNull);
        expect(controller.pageController.initialPage, 0);
      });

      test('pageController dispose edildiğinde hata vermemeli', () {
        expect(() => controller.dispose(), returnsNormally);
      });
    });

    group('Edge Cases Tests', () {
      test('çok hızlı navigation çağrıları düzgün çalışmalı', () {
        controller.nextPage();
        controller.nextPage();
        controller.previousPage();
        controller.nextPage();

        expect(controller.selectedIndex, 2);
        expect(controller.isLastPage, true);
      });

      test('dispose sonrası method çağrıları hata vermeli', () {
        controller.dispose();

        // Dispose sonrası method çağrıları hata vermeli (ChangeNotifier davranışı)
        expect(
          () => controller.updateSelectedIndex(1),
          throwsA(isA<FlutterError>()),
        );
        expect(() => controller.nextPage(), throwsA(isA<FlutterError>()));
        expect(() => controller.previousPage(), throwsA(isA<FlutterError>()));
      });
    });

    group('Integration Tests', () {
      test('tam onboarding flow doğru çalışmalı', () {
        // İlk sayfa
        expect(controller.selectedIndex, 0);
        expect(controller.isFirstPage, true);
        expect(controller.isBackEnabled, false);

        // İkinci sayfa
        controller.nextPage();
        expect(controller.selectedIndex, 1);
        expect(controller.isFirstPage, false);
        expect(controller.isLastPage, false);
        expect(controller.isBackEnabled, false);

        // Son sayfa
        controller.nextPage();
        expect(controller.selectedIndex, 2);
        expect(controller.isFirstPage, false);
        expect(controller.isLastPage, true);
        expect(controller.isBackEnabled, true);

        // Geri git
        controller.previousPage();
        expect(controller.selectedIndex, 1);
        expect(controller.isFirstPage, false);
        expect(controller.isLastPage, false);
        expect(controller.isBackEnabled, false);

        // İlk sayfaya dön
        controller.previousPage();
        expect(controller.selectedIndex, 0);
        expect(controller.isFirstPage, true);
        expect(controller.isLastPage, false);
        expect(controller.isBackEnabled, false);
      });
    });
  });
}
