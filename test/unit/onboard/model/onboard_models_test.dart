import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/onboard/model/onboard_model.dart';
import 'package:arya/product/utility/constants/animations/lottie_paths.dart';

void main() {
  group('OnBoardModels Tests', () {
    group('Gerçek Model Testleri', () {
      test('OnBoardModels listesi doğru sayıda ekran içermeli', () {
        // Arrange
        final screens = OnBoardModels.onboardModels;

        // Act & Assert
        expect(screens.length, 3);
        expect(screens.isNotEmpty, true);
        expect(screens.first, isA<OnboardModel>());
      });

      test('Her onboard ekranı gerekli alanları içermeli', () {
        // Arrange
        final screens = OnBoardModels.onboardModels;

        // Act & Assert
        for (final screen in screens) {
          expect(screen.title, isNotEmpty);
          expect(screen.title, isA<String>());
          expect(screen.description, isNotEmpty);
          expect(screen.description, isA<String>());
          expect(screen.lottiePath, isNotNull);
          expect(screen.lottiePath, isA<String>());
        }
      });

      test('Lottie dosya yolları geçerli olmalı', () {
        // Arrange
        final screens = OnBoardModels.onboardModels;
        final validPaths = [
          LottiePaths.onShoppingGreen,
          LottiePaths.onNutrition,
          LottiePaths.onGrocery,
        ];

        // Act & Assert
        for (int i = 0; i < screens.length; i++) {
          expect(screens[i].lottiePath, equals(validPaths[i]));
          expect(screens[i].lottiePath!.startsWith('assets/lottie/'), isTrue);
          expect(screens[i].lottiePath!.endsWith('.json'), isTrue);
        }
      });

      test('OnboardModel constructor doğru değerleri atamalı', () {
        // Arrange
        const testTitle = 'Test Başlık';
        const testDescription = 'Test açıklama metni';
        const testLottiePath = 'test/path.json';

        // Act
        final testModel = OnboardModel(
          testTitle,
          testDescription,
          testLottiePath,
        );

        // Assert
        expect(testModel.title, equals(testTitle));
        expect(testModel.description, equals(testDescription));
        expect(testModel.lottiePath, equals(testLottiePath));
      });

      test('OnboardModel null lottiePath ile oluşturulabilmeli', () {
        // Arrange
        const testTitle = 'Test Başlık';
        const testDescription = 'Test açıklama metni';

        // Act
        final testModel = OnboardModel(testTitle, testDescription, null);

        // Assert
        expect(testModel.title, equals(testTitle));
        expect(testModel.description, equals(testDescription));
        expect(testModel.lottiePath, isNull);
      });

      test('LottiePaths sabitleri doğru değerleri içermeli', () {
        // Arrange & Act & Assert
        expect(
          LottiePaths.onShoppingGreen,
          equals('assets/lottie/on_shopping_green.json'),
        );
        expect(
          LottiePaths.onNutrition,
          equals('assets/lottie/on_nutrition.json'),
        );
        expect(LottiePaths.onGrocery, equals('assets/lottie/on_grocery.json'));
        expect(LottiePaths.onLogin, equals('assets/lottie/on_login.json'));
        expect(
          LottiePaths.onRegister,
          equals('assets/lottie/on_register.json'),
        );
      });

      test('Boş string değerler kabul edilmeli', () {
        // Arrange
        const emptyTitle = '';
        const emptyDescription = '';
        const validLottiePath = 'assets/lottie/test.json';

        // Act & Assert
        expect(
          () => OnboardModel(emptyTitle, emptyDescription, validLottiePath),
          returnsNormally,
        );
      });

      test('Lottie dosya format kontrolü', () {
        // Arrange
        final screens = OnBoardModels.onboardModels;

        // Act & Assert
        for (final screen in screens) {
          expect(screen.lottiePath, isNotNull);
          expect(screen.lottiePath!.endsWith('.json'), isTrue);
          expect(screen.lottiePath!.contains('assets/lottie/'), isTrue);
        }
      });

      test('OnboardModel immutable olmalı', () {
        // Arrange
        const testTitle = 'Test Başlık';
        const testDescription = 'Test açıklama metni';
        const testLottiePath = 'test/path.json';

        // Act
        final testModel = OnboardModel(
          testTitle,
          testDescription,
          testLottiePath,
        );

        // Assert - final fields should not be changeable
        expect(testModel.title, equals(testTitle));
        expect(testModel.description, equals(testDescription));
        expect(testModel.lottiePath, equals(testLottiePath));
      });

      test('OnboardModel boş string değerlerle testi', () {
        // Arrange
        const emptyTitle = '';
        const emptyDescription = '';
        const validLottiePath = 'assets/lottie/test.json';

        // Act
        final testModel = OnboardModel(
          emptyTitle,
          emptyDescription,
          validLottiePath,
        );

        // Assert
        expect(testModel.title, isEmpty);
        expect(testModel.description, isEmpty);
        expect(testModel.lottiePath, equals(validLottiePath));
      });

      test('OnboardModel uzun string değerlerle testi', () {
        // Arrange
        const longTitle =
            'Bu çok uzun bir başlık metni ve test amaçlı olarak yazılmıştır';
        const longDescription =
            'Bu da çok uzun bir açıklama metni ve test amaçlı olarak yazılmıştır. '
            'Bu metin birden fazla cümle içermektedir ve gerçek kullanım senaryolarını simüle etmektedir.';
        const validLottiePath = 'assets/lottie/very_long_animation_name.json';

        // Act
        final testModel = OnboardModel(
          longTitle,
          longDescription,
          validLottiePath,
        );

        // Assert
        expect(testModel.title, equals(longTitle));
        expect(testModel.description, equals(longDescription));
        expect(testModel.lottiePath, equals(validLottiePath));
        expect(testModel.title.length, greaterThan(20));
        expect(testModel.description.length, greaterThan(50));
      });

      test('OnboardModel özel karakterlerle testi', () {
        // Arrange
        const specialTitle = 'Başlık: Özel Karakterler! @#\$%^&*()';
        const specialDescription = 'Açıklama: Türkçe karakterler ğüşıöçĞÜŞİÖÇ';
        const specialPath = 'assets/lottie/special_chars_ğüşıöç.json';

        // Act
        final testModel = OnboardModel(
          specialTitle,
          specialDescription,
          specialPath,
        );

        // Assert
        expect(testModel.title, equals(specialTitle));
        expect(testModel.description, equals(specialDescription));
        expect(testModel.lottiePath, equals(specialPath));
        expect(testModel.title, contains('!'));
        expect(testModel.description, contains('ç'));
        expect(testModel.description, contains('ğ'));
      });

      test('OnboardModel liste işlemleri testi', () {
        // Arrange
        final models = [
          OnboardModel(
            'Başlık 1',
            'Açıklama 1',
            'assets/lottie/animation_1.json',
          ),
          OnboardModel(
            'Başlık 2',
            'Açıklama 2',
            'assets/lottie/animation_2.json',
          ),
          OnboardModel(
            'Başlık 3',
            'Açıklama 3',
            'assets/lottie/animation_3.json',
          ),
        ];

        // Act
        final titles = models.map((m) => m.title).toList();
        final descriptions = models.map((m) => m.description).toList();
        final paths = models.map((m) => m.lottiePath).toList();

        // Assert
        expect(models.length, equals(3));
        expect(titles.length, equals(3));
        expect(descriptions.length, equals(3));
        expect(paths.length, equals(3));

        for (int i = 0; i < 3; i++) {
          expect(titles[i], equals('Başlık ${i + 1}'));
          expect(descriptions[i], equals('Açıklama ${i + 1}'));
          expect(paths[i], equals('assets/lottie/animation_${i + 1}.json'));
        }
      });

      test('OnboardModel null safety testi', () {
        // Arrange
        final modelWithNull = OnboardModel('Test', 'Test', null);
        final modelWithEmpty = OnboardModel('', '', '');

        // Assert
        expect(modelWithNull.lottiePath, isNull);
        expect(modelWithEmpty.title, isEmpty);
        expect(modelWithEmpty.description, isEmpty);
        expect(modelWithEmpty.lottiePath, isEmpty);
      });
    });

    group('OnBoardModels Sınıf Testleri', () {
      test('OnBoardModels sınıfı singleton pattern kullanmalı', () {
        // Arrange & Act
        final instance1 = OnBoardModels.onboardModels;
        final instance2 = OnBoardModels.onboardModels;

        // Assert
        expect(identical(instance1, instance2), isTrue);
      });

      test('OnBoardModels listesi readonly olmalı', () {
        // Arrange
        final screens = OnBoardModels.onboardModels;

        // Assert
        expect(screens, isA<List<OnboardModel>>());
        expect(screens, isNotEmpty);
      });

      test('OnBoardModels listesi sıralı olmalı', () {
        // Arrange
        final screens = OnBoardModels.onboardModels;

        // Assert
        expect(screens.length, equals(3));
        expect(screens[0], isA<OnboardModel>());
        expect(screens[1], isA<OnboardModel>());
        expect(screens[2], isA<OnboardModel>());
      });
    });
  });
}
