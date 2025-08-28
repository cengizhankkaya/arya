import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/model/user_model.dart';

void main() {
  group('UserModel', () {
    group('Constructor Tests', () {
      test('UserModel constructor tüm alanları set etmeli', () {
        // Arrange (Hazırlık) - Test verilerini hazırla
        const uid = 'user123';
        const name = 'John';
        const surname = 'Doe';
        const username = 'johndoe';
        const email = 'john@example.com';

        // ACT (Eylem) - Test edilecek kodu çalıştır
        const user = UserModel(
          uid: uid,
          name: name,
          surname: surname,
          username: username,
          email: email,
        );

        // ASSERT (Doğrulama) - Sonucu kontrol et
        expect(user.uid, equals(uid));
        expect(user.name, equals(name));
        expect(user.surname, equals(surname));
        expect(user.username, equals(username));
        expect(user.email, equals(email));
      });

      test('UserModel null değerlerle oluşturulabilmeli', () {
        // ARRANGE (Hazırlık) - Null değerler
        const uid = null;
        const name = null;
        const surname = null;
        const username = null;
        const email = null;

        // ACT (Eylem) - Null değerlerle UserModel oluştur
        const user = UserModel(
          uid: uid,
          name: name,
          surname: surname,
          username: username,
          email: email,
        );

        // ASSERT (Doğrulama) - Tüm değerler null olmalı
        expect(user.uid, isNull);
        expect(user.name, isNull);
        expect(user.surname, isNull);
        expect(user.username, isNull);
        expect(user.email, isNull);
      });

      test('UserModel boş string değerlerle oluşturulabilmeli', () {
        // ARRANGE (Hazırlık) - Boş string değerler
        const uid = '';
        const name = '';
        const surname = '';
        const username = '';
        const email = '';

        // ACT (Eylem) - Boş string değerlerle UserModel oluştur
        const user = UserModel(
          uid: uid,
          name: name,
          surname: surname,
          username: username,
          email: email,
        );

        // ASSERT (Doğrulama) - Tüm değerler boş string olmalı
        expect(user.uid, equals(''));
        expect(user.name, equals(''));
        expect(user.surname, equals(''));
        expect(user.username, equals(''));
        expect(user.email, equals(''));
      });

      test('UserModel kısmi alanlarla oluşturulabilmeli', () {
        // ARRANGE (Hazırlık) - Sadece gerekli alanlar
        const uid = 'user123';
        const email = 'john@example.com';

        // ACT (Eylem) - Kısmi alanlarla UserModel oluştur
        const user = UserModel(uid: uid, email: email);

        // ASSERT (Doğrulama) - Sadece belirtilen alanlar set edilmeli
        expect(user.uid, equals(uid));
        expect(user.email, equals(email));
        expect(user.name, isNull);
        expect(user.surname, isNull);
        expect(user.username, isNull);
      });
    });

    group('Getter Tests', () {
      test('fullName getter doğru çalışmalı', () {
        // Arrange
        const user = UserModel(name: 'John', surname: 'Doe');

        // ACT (Eylem) - getter çağrılır
        final fullName = user.fullName;

        // Assert
        expect(fullName, equals('John Doe'));
      });

      test('fullName getter tek isim ile çalışmalı', () {
        // Arrange
        const user = UserModel(name: 'John');

        // ACT (Eylem) - getter çağrılır
        final fullName = user.fullName;

        // Assert
        expect(fullName, equals('John'));
      });

      test('fullName getter sadece soyisim ile çalışmalı', () {
        // Arrange
        const user = UserModel(surname: 'Doe');

        // ACT (Eylem) - getter çağrılır
        final fullName = user.fullName;

        // Assert
        expect(fullName, equals('Doe'));
      });

      test('fullName getter hiç isim yoksa fallback döndürmeli', () {
        // Arrange
        const user = UserModel();

        // ACT (Eylem) - getter çağrılır
        final fullName = user.fullName;

        // Assert
        expect(fullName, equals('İsimsiz Kullanıcı'));
      });

      test('fullName getter boş string isimlerle fallback döndürmeli', () {
        // Arrange
        const user = UserModel(name: '', surname: '');

        // ACT (Eylem) - getter çağrılır
        final fullName = user.fullName;

        // Assert
        expect(fullName, equals('İsimsiz Kullanıcı'));
      });

      test('displayName getter username öncelikli olmalı', () {
        // ARRANGE (Hazırlık)
        const user = UserModel(
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
        );

        // ACT (Eylem) - displayName getter'ı çağır
        final displayName = user.displayName;

        // ASSERT (Doğrulama) - Username öncelikli olmalı
        expect(displayName, equals('johndoe'));
      });

      test('displayName getter username yoksa fullName döndürmeli', () {
        // ARRANGE (Hazırlık)
        const user = UserModel(name: 'John', surname: 'Doe');

        // ACT (Eylem) - displayName getter'ı çağır
        final displayName = user.displayName;

        // ASSERT (Doğrulama) - FullName döndürmeli
        expect(displayName, equals('John Doe'));
      });

      test('displayName getter hiç isim yoksa fallback döndürmeli', () {
        // ARRANGE (Hazırlık)
        const user = UserModel();

        // ACT (Eylem) - displayName getter'ı çağır
        final displayName = user.displayName;

        // ASSERT (Doğrulama) - Fallback döndürmeli
        expect(displayName, equals('İsimsiz Kullanıcı'));
      });

      test('displayName getter boş username ile fullName döndürmeli', () {
        // ARRANGE (Hazırlık)
        const user = UserModel(name: 'John', surname: 'Doe', username: '');

        // ACT (Eylem) - displayName getter'ı çağır
        final displayName = user.displayName;

        // ASSERT (Doğrulama) - FullName döndürmeli
        expect(displayName, equals('John Doe'));
      });

      test('isValid getter doğru çalışmalı', () {
        // ARRANGE (Hazırlık) - Valid user
        const validUser = UserModel(uid: 'user123', email: 'john@example.com');

        // ARRANGE (Hazırlık) - Invalid user
        const invalidUser = UserModel(name: 'John', surname: 'Doe');

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(validUser.isValid, isTrue); // UID + Email var
        expect(invalidUser.isValid, isFalse); // UID yok
      });

      test('isValid getter boş string ile false döndürmeli', () {
        // ARRANGE (Hazırlık) - Boş string değerler
        const userWithEmptyUid = UserModel(uid: '', email: 'john@example.com');
        const userWithEmptyEmail = UserModel(uid: 'user123', email: '');

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(userWithEmptyUid.isValid, isFalse);
        expect(userWithEmptyEmail.isValid, isFalse);
      });

      test('isComplete getter doğru çalışmalı', () {
        // ARRANGE (Hazırlık) - Complete user
        const completeUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john@example.com',
        );

        // ARRANGE (Hazırlık) - Incomplete user
        const incompleteUser = UserModel(
          uid: 'user123',
          email: 'john@example.com',
          // name ve surname eksik
        );

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(completeUser.isComplete, isTrue); // Tüm alanlar var
        expect(incompleteUser.isComplete, isFalse); // name/surname eksik
      });

      test('isComplete getter boş string ile false döndürmeli', () {
        // ARRANGE (Hazırlık) - Boş string değerler
        const userWithEmptyName = UserModel(
          uid: 'user123',
          name: '',
          surname: 'Doe',
          email: 'john@example.com',
        );

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(userWithEmptyName.isComplete, isFalse);
      });
    });

    group('Method Tests', () {
      test('copyWith metodu doğru çalışmalı', () {
        // ARRANGE (Hazırlık) - Orijinal user
        const originalUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john@example.com',
        );

        // ACT (Eylem) - copyWith ile güncelle
        final updatedUser = originalUser.copyWith(
          name: 'Jane',
          email: 'jane@example.com',
        );

        // ASSERT (Doğrulama) - Değişen ve değişmeyen alanlar
        expect(updatedUser.name, equals('Jane')); // Değişti
        expect(updatedUser.email, equals('jane@example.com')); // Değişti
        expect(updatedUser.uid, equals('user123')); // Değişmedi
        expect(updatedUser.surname, equals('Doe')); // Değişmedi
      });

      test('copyWith metodu null değerlerle çalışmalı', () {
        // ARRANGE (Hazırlık) - Orijinal user
        const originalUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john@example.com',
        );

        // ACT (Eylem) - copyWith ile null değerler set et
        final updatedUser = originalUser.copyWith(name: null, surname: null);

        // ASSERT (Doğrulama) - copyWith null değerleri kabul etmez, orijinal değerleri korur
        expect(updatedUser.name, equals('John')); // Orijinal değer korundu
        expect(updatedUser.surname, equals('Doe')); // Orijinal değer korundu
        expect(updatedUser.uid, equals('user123')); // Değişmedi
        expect(updatedUser.email, equals('john@example.com')); // Değişmedi
      });

      test(
        'copyWith metodu hiç parametre verilmeden orijinal user döndürmeli',
        () {
          // ARRANGE (Hazırlık) - Orijinal user
          const originalUser = UserModel(
            uid: 'user123',
            name: 'John',
            surname: 'Doe',
            email: 'john@example.com',
          );

          // ACT (Eylem) - copyWith parametresiz çağır
          final copiedUser = originalUser.copyWith();

          // ASSERT (Doğrulama) - Aynı değerler döndürmeli
          expect(copiedUser.uid, equals(originalUser.uid));
          expect(copiedUser.name, equals(originalUser.name));
          expect(copiedUser.surname, equals(originalUser.surname));
          expect(copiedUser.email, equals(originalUser.email));
        },
      );

      test('fromJson metodu doğru çalışmalı', () {
        // ARRANGE (Hazırlık) - JSON data
        const jsonData = {
          'uid': 'user123',
          'name': 'John',
          'surname': 'Doe',
          'username': 'johndoe',
          'email': 'john@example.com',
        };

        // ACT (Eylem) - fromJson çağır
        final user = UserModel.fromJson(jsonData);

        // ASSERT (Doğrulama) - UserModel doğru oluşturulmalı
        expect(user.uid, equals('user123'));
        expect(user.name, equals('John'));
        expect(user.surname, equals('Doe'));
        expect(user.username, equals('johndoe'));
        expect(user.email, equals('john@example.com'));
      });

      test('fromJson metodu eksik alanlarla çalışmalı', () {
        // ARRANGE (Hazırlık) - Kısmi JSON data
        const jsonData = {'uid': 'user123', 'email': 'john@example.com'};

        // ACT (Eylem) - fromJson çağır
        final user = UserModel.fromJson(jsonData);

        // ASSERT (Doğrulama) - Sadece mevcut alanlar set edilmeli
        expect(user.uid, equals('user123'));
        expect(user.email, equals('john@example.com'));
        expect(user.name, isNull);
        expect(user.surname, isNull);
        expect(user.username, isNull);
      });

      test('toJson metodu doğru çalışmalı', () {
        // ARRANGE (Hazırlık) - UserModel
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
          email: 'john@example.com',
        );

        // ACT (Eylem) - toJson çağır
        final jsonData = user.toJson();

        // ASSERT (Doğrulama) - JSON formatı doğru olmalı
        expect(jsonData['uid'], equals('user123'));
        expect(jsonData['name'], equals('John'));
        expect(jsonData['surname'], equals('Doe'));
        expect(jsonData['username'], equals('johndoe'));
        expect(jsonData['email'], equals('john@example.com'));
      });

      test('toJson metodu null değerleri dahil etmemeli', () {
        // ARRANGE (Hazırlık) - Kısmi UserModel
        const user = UserModel(uid: 'user123', email: 'john@example.com');

        // ACT (Eylem) - toJson çağır
        final jsonData = user.toJson();

        // ASSERT (Doğrulama) - Sadece mevcut alanlar dahil edilmeli
        expect(jsonData['uid'], equals('user123'));
        expect(jsonData['email'], equals('john@example.com'));
        expect(jsonData.containsKey('name'), isFalse);
        expect(jsonData.containsKey('surname'), isFalse);
        expect(jsonData.containsKey('username'), isFalse);
      });

      test('toJson metodu boş string username dahil etmemeli', () {
        // ARRANGE (Hazırlık) - Boş username ile UserModel
        const user = UserModel(
          uid: 'user123',
          username: '',
          email: 'john@example.com',
        );

        // ACT (Eylem) - toJson çağır
        final jsonData = user.toJson();

        // ASSERT (Doğrulama) - Boş username dahil edilmemeli
        expect(jsonData.containsKey('username'), isFalse);
      });
    });

    group('Utility Tests', () {
      test('toString metodu doğru çalışmalı', () {
        // ARRANGE (Hazırlık)
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
          email: 'john@example.com',
        );

        // ACT (Eylem) - toString çağır
        final stringRepresentation = user.toString();

        // ASSERT (Doğrulama) - String formatı doğru olmalı
        expect(stringRepresentation, contains('UserModel'));
        expect(stringRepresentation, contains('user123'));
        expect(stringRepresentation, contains('John'));
        expect(stringRepresentation, contains('Doe'));
        expect(stringRepresentation, contains('johndoe'));
        expect(stringRepresentation, contains('john@example.com'));
      });

      test('toString metodu null değerlerle çalışmalı', () {
        // ARRANGE (Hazırlık) - Kısmi UserModel
        const user = UserModel(uid: 'user123', email: 'john@example.com');

        // ACT (Eylem) - toString çağır
        final stringRepresentation = user.toString();

        // ASSERT (Doğrulama) - Null değerler dahil edilmeli
        expect(stringRepresentation, contains('user123'));
        expect(stringRepresentation, contains('john@example.com'));
        expect(stringRepresentation, contains('null'));
      });

      test('hashCode metodu doğru çalışmalı', () {
        // ARRANGE (Hazırlık) - İki aynı user
        const user1 = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john@example.com',
        );

        const user2 = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john@example.com',
        );

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(
          user1.hashCode,
          equals(user2.hashCode),
        ); // Aynı değerler = aynı hash
        expect(user1.hashCode, isA<int>()); // hashCode int olmalı
      });

      test('hashCode metodu farklı userlar için farklı olmalı', () {
        // ARRANGE (Hazırlık) - Farklı userlar
        const user1 = UserModel(
          uid: 'user123',
          name: 'John',
          email: 'john@example.com',
        );

        const user2 = UserModel(
          uid: 'user456',
          name: 'Jane',
          email: 'jane@example.com',
        );

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(user1.hashCode, isNot(equals(user2.hashCode)));
      });

      test('== operator doğru çalışmalı', () {
        // ARRANGE (Hazırlık) - İki aynı user
        const user1 = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
          email: 'john@example.com',
        );

        const user2 = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
          email: 'john@example.com',
        );

        // ARRANGE (Hazırlık) - Farklı user
        const user3 = UserModel(
          uid: 'user456',
          name: 'Jane',
          surname: 'Smith',
          email: 'jane@example.com',
        );

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(user1 == user2, isTrue); // Aynı değerler = eşit
        expect(user1 == user3, isFalse); // Farklı değerler = eşit değil
        expect(user1, equals(user2)); // equals() ile de test et
      });

      test('== operator null değerlerle çalışmalı', () {
        // ARRANGE (Hazırlık) - Null değerlerle userlar
        const user1 = UserModel(uid: 'user123', email: 'john@example.com');

        const user2 = UserModel(uid: 'user123', email: 'john@example.com');

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(user1 == user2, isTrue);
      });

      test('== operator farklı türlerle false döndürmeli', () {
        // ARRANGE (Hazırlık) - UserModel ve String
        const user = UserModel(uid: 'user123', email: 'john@example.com');

        const string = 'user123';

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(user == string, isFalse);
      });
    });

    group('Edge Cases Tests', () {
      test('çok uzun string değerlerle çalışmalı', () {
        // ARRANGE (Hazırlık) - Çok uzun string
        final longString = 'a' * 1000;
        final user = UserModel(
          uid: longString,
          name: longString,
          surname: longString,
          username: longString,
          email: '$longString@example.com',
        );

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(user.uid, equals(longString));
        expect(user.fullName, equals('$longString $longString'));
        expect(user.displayName, equals(longString));
      });

      test('özel karakterlerle çalışmalı', () {
        // ARRANGE (Hazırlık) - Özel karakterler
        const specialChars = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
        const user = UserModel(
          uid: specialChars,
          name: specialChars,
          email: '$specialChars@example.com',
        );

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(user.uid, equals(specialChars));
        expect(user.name, equals(specialChars));
        expect(user.email, equals('$specialChars@example.com'));
      });

      test('Unicode karakterlerle çalışmalı', () {
        // ARRANGE (Hazırlık) - Unicode karakterler
        const unicodeName = 'José María';
        const unicodeSurname = 'García-López';
        const user = UserModel(name: unicodeName, surname: unicodeSurname);

        // ACT & ASSERT (Eylem ve Doğrulama)
        expect(user.fullName, equals('$unicodeName $unicodeSurname'));
        expect(user.displayName, equals('$unicodeName $unicodeSurname'));
      });
    });
  });
}
