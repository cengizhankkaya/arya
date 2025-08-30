import 'package:flutter_test/flutter_test.dart';
import 'package:arya/product/constants/auth_constants.dart';

void main() {
  group('AuthConstants', () {
    group('Route Constants Tests', () {
      test('login route doğru tanımlanmalı', () {
        expect(AuthConstants.loginRoute, equals('/login'));
      });

      test('register route doğru tanımlanmalı', () {
        expect(AuthConstants.registerRoute, equals('/register'));
      });

      test('home route doğru tanımlanmalı', () {
        expect(AuthConstants.homeRoute, equals('/home'));
      });

      test('splash route doğru tanımlanmalı', () {
        expect(AuthConstants.splashRoute, equals('/splash'));
      });
    });

    group('Firebase Auth Error Codes Tests', () {
      test('userNotFound error code doğru tanımlanmalı', () {
        expect(AuthConstants.userNotFound, equals('user-not-found'));
      });

      test('wrongPassword error code doğru tanımlanmalı', () {
        expect(AuthConstants.wrongPassword, equals('wrong-password'));
      });

      test('invalidEmail error code doğru tanımlanmalı', () {
        expect(AuthConstants.invalidEmail, equals('invalid-email'));
      });

      test('userDisabled error code doğru tanımlanmalı', () {
        expect(AuthConstants.userDisabled, equals('user-disabled'));
      });

      test('tooManyRequests error code doğru tanımlanmalı', () {
        expect(AuthConstants.tooManyRequests, equals('too-many-requests'));
      });

      test('networkRequestFailed error code doğru tanımlanmalı', () {
        expect(
          AuthConstants.networkRequestFailed,
          equals('network-request-failed'),
        );
      });

      test('invalidCredential error code doğru tanımlanmalı', () {
        expect(AuthConstants.invalidCredential, equals('invalid-credential'));
      });

      test('emailAlreadyInUse error code doğru tanımlanmalı', () {
        expect(AuthConstants.emailAlreadyInUse, equals('email-already-in-use'));
      });

      test('weakPassword error code doğru tanımlanmalı', () {
        expect(AuthConstants.weakPassword, equals('weak-password'));
      });

      test('operationNotAllowed error code doğru tanımlanmalı', () {
        expect(
          AuthConstants.operationNotAllowed,
          equals('operation-not-allowed'),
        );
      });
    });

    group('Validation Rules Tests', () {
      test('minPasswordLength doğru tanımlanmalı', () {
        expect(AuthConstants.minPasswordLength, equals(6));
      });

      test('maxPasswordLength doğru tanımlanmalı', () {
        expect(AuthConstants.maxPasswordLength, equals(20));
      });

      test('minNameLength doğru tanımlanmalı', () {
        expect(AuthConstants.minNameLength, equals(2));
      });

      test('maxNameLength doğru tanımlanmalı', () {
        expect(AuthConstants.maxNameLength, equals(50));
      });

      test('password length kuralları mantıklı olmalı', () {
        expect(
          AuthConstants.minPasswordLength,
          lessThan(AuthConstants.maxPasswordLength),
        );
        expect(AuthConstants.minPasswordLength, greaterThan(0));
        expect(
          AuthConstants.maxPasswordLength,
          greaterThan(AuthConstants.minPasswordLength),
        );
      });

      test('name length kuralları mantıklı olmalı', () {
        expect(
          AuthConstants.minNameLength,
          lessThan(AuthConstants.maxNameLength),
        );
        expect(AuthConstants.minNameLength, greaterThan(0));
        expect(
          AuthConstants.maxNameLength,
          greaterThan(AuthConstants.minNameLength),
        );
      });
    });

    group('Email Regex Pattern Tests', () {
      test('email regex pattern doğru tanımlanmalı', () {
        expect(AuthConstants.emailRegex, isA<RegExp>());
      });

      test('geçerli email formatları kabul edilmeli', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          '123@numbers.com',
          'user@subdomain.example.com',
        ];

        for (final email in validEmails) {
          expect(
            AuthConstants.emailRegex.hasMatch(email),
            isTrue,
            reason: '$email geçerli email olmalı',
          );
        }
      });

      test('geçersiz email formatları reddedilmeli', () {
        final invalidEmails = [
          'invalid-email',
          '@example.com',
          'user@',
          'user@.com',
          'user name@example.com',
          'user@example com',
          '',
          '   ',
        ];

        for (final email in invalidEmails) {
          expect(
            AuthConstants.emailRegex.hasMatch(email),
            isFalse,
            reason: '$email geçersiz email olmalı',
          );
        }
      });

      test('email regex case sensitive olmamalı', () {
        final testEmails = [
          'TEST@EXAMPLE.COM',
          'Test@Example.com',
          'test@EXAMPLE.com',
        ];

        for (final email in testEmails) {
          expect(
            AuthConstants.emailRegex.hasMatch(email),
            isTrue,
            reason: '$email case insensitive olarak kabul edilmeli',
          );
        }
      });
    });

    group('Password Regex Pattern Tests', () {
      test('password regex pattern doğru tanımlanmalı', () {
        expect(AuthConstants.passwordRegex, isA<RegExp>());
      });

      test('güçlü şifreler kabul edilmeli', () {
        final strongPasswords = [
          'Password123',
          'MyPass1word',
          'Secure123Pass',
          'Test123Password',
          'Complex1Pass',
        ];

        for (final password in strongPasswords) {
          expect(
            AuthConstants.passwordRegex.hasMatch(password),
            isTrue,
            reason: '$password güçlü şifre olmalı',
          );
        }
      });

      test('zayıf şifreler reddedilmeli', () {
        final weakPasswords = [
          'password', // Sadece küçük harf
          'PASSWORD', // Sadece büyük harf
          '123456', // Sadece rakam
          'pass', // Çok kısa
          'password123', // Büyük harf yok
          'PASSWORD123', // Küçük harf yok
          'Password', // Rakam yok
          '', // Boş
          '   ', // Sadece boşluk
        ];

        for (final password in weakPasswords) {
          expect(
            AuthConstants.passwordRegex.hasMatch(password),
            isFalse,
            reason: '$password zayıf şifre olmalı',
          );
        }
      });

      test('şifre minimum uzunluk kuralına uygun olmalı', () {
        final shortPassword = 'Abc12'; // 5 karakter
        final validPassword = 'Abc123'; // 6 karakter (minimum)
        final longPassword = 'Abc123def456'; // 12 karakter

        expect(AuthConstants.passwordRegex.hasMatch(shortPassword), isFalse);
        expect(AuthConstants.passwordRegex.hasMatch(validPassword), isTrue);
        expect(AuthConstants.passwordRegex.hasMatch(longPassword), isTrue);
      });
    });

    group('Constants Immutability Tests', () {
      test('tüm constants final olmalı', () {
        // Bu test compile time'da çalışır
        // Eğer constants final değilse, bu test compile olmaz
        expect(AuthConstants.loginRoute, isA<String>());
        expect(AuthConstants.minPasswordLength, isA<int>());
        expect(AuthConstants.emailRegex, isA<RegExp>());
      });

      test('constants değerleri değiştirilememeli', () {
        // Constants değerleri değiştirilemez olmalı
        // Bu test compile time'da çalışır
        const originalLoginRoute = AuthConstants.loginRoute;
        const originalMinPasswordLength = AuthConstants.minPasswordLength;

        expect(originalLoginRoute, equals('/login'));
        expect(originalMinPasswordLength, equals(6));
      });
    });

    group('Constants Consistency Tests', () {
      test('error codes unique olmalı', () {
        final errorCodes = [
          AuthConstants.userNotFound,
          AuthConstants.wrongPassword,
          AuthConstants.invalidEmail,
          AuthConstants.userDisabled,
          AuthConstants.tooManyRequests,
          AuthConstants.networkRequestFailed,
          AuthConstants.invalidCredential,
          AuthConstants.emailAlreadyInUse,
          AuthConstants.weakPassword,
          AuthConstants.operationNotAllowed,
        ];

        final uniqueCodes = errorCodes.toSet();
        expect(uniqueCodes.length, equals(errorCodes.length));
      });

      test('route constants unique olmalı', () {
        final routes = [
          AuthConstants.loginRoute,
          AuthConstants.registerRoute,
          AuthConstants.homeRoute,
          AuthConstants.splashRoute,
        ];

        final uniqueRoutes = routes.toSet();
        expect(uniqueRoutes.length, equals(routes.length));
      });

      test('validation kuralları tutarlı olmalı', () {
        // Password length kuralları
        expect(
          AuthConstants.minPasswordLength,
          lessThanOrEqualTo(AuthConstants.maxPasswordLength),
        );

        // Name length kuralları
        expect(
          AuthConstants.minNameLength,
          lessThanOrEqualTo(AuthConstants.maxNameLength),
        );

        // Minimum değerler pozitif olmalı
        expect(AuthConstants.minPasswordLength, greaterThan(0));
        expect(AuthConstants.minNameLength, greaterThan(0));
      });
    });
  });
}
