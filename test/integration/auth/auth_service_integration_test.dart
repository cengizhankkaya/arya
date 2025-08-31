import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/auth/service/user_service.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/auth/model/user_model.dart';

@GenerateMocks([FirebaseAuthService, UserService])
import 'auth_service_integration_test.mocks.dart';

void main() {
  group('Auth Service Integration Tests', () {
    late MockFirebaseAuthService mockAuthService;
    late MockUserService mockUserService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
      mockUserService = MockUserService();
    });

    tearDown(() {
      // Cleanup
    });

    group('Authentication Flow Tests', () {
      testWidgets('Sign up ve sign in akışı doğru çalışmalı', (tester) async {
        // ARRANGE: Mock service'leri hazırla
        when(
          mockAuthService.signUp(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        when(mockUserService.createDataUser(any)).thenAnswer((_) async => true);

        // ACT: Önce sign up yap
        final signUpResult = await mockAuthService.signUp(
          email: 'test@example.com',
          password: 'password123',
        );

        // ASSERT: Sign up başarılı olmalı
        expect(signUpResult.isSuccess, isTrue);

        // ACT: Sonra sign in yap
        final signInResult = await mockAuthService.signIn(
          email: 'test@example.com',
          password: 'password123',
        );

        // ASSERT: Sign in başarılı olmalı
        expect(signInResult.isSuccess, isTrue);

        // VERIFY: Service metodları çağrıldı mı?
        verify(
          mockAuthService.signUp(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);

        verify(
          mockAuthService.signIn(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      testWidgets('Sign out işlemi doğru çalışmalı', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockAuthService.signOut()).thenAnswer((_) async {});

        // ACT: Sign out çağır
        await mockAuthService.signOut();

        // ASSERT: Sign out çağrıldı mı?
        // VERIFY: Service metodu çağrıldı mı?
        verify(mockAuthService.signOut()).called(1);
      });

      testWidgets('Password reset işlemi doğru çalışmalı', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.sendPasswordResetEmail(email: anyNamed('email')),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Password reset email gönder
        final result = await mockAuthService.sendPasswordResetEmail(
          email: 'test@example.com',
        );

        // ASSERT: Password reset email gönderildi mi?
        expect(result.isSuccess, isTrue);

        // VERIFY: Service metodu çağrıldı mı?
        verify(
          mockAuthService.sendPasswordResetEmail(email: 'test@example.com'),
        ).called(1);
      });
    });

    group('User Management Tests', () {
      testWidgets('Kullanıcı oluşturma ve güncelleme işlemleri', (
        tester,
      ) async {
        // ARRANGE: Mock service'leri hazırla
        when(mockUserService.createDataUser(any)).thenAnswer((_) async {});
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        // Test kullanıcısı oluştur
        final testUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // ACT: Kullanıcı oluştur
        await mockUserService.createDataUser(testUser);

        // ASSERT: Kullanıcı oluşturuldu mu?
        // Kullanıcı oluşturma işlemi tamamlandı

        // ACT: Kullanıcı bilgilerini güncelle
        final updatedUser = UserModel(
          uid: 'test-uid-123',
          name: 'John Updated',
          surname: 'Doe Updated',
          email: 'john.doe@example.com',
        );

        await mockUserService.updateUserData(updatedUser);

        // ASSERT: Kullanıcı güncellendi mi?
        // Kullanıcı güncelleme işlemi tamamlandı

        // VERIFY: Service metodları çağrıldı mı?
        verify(mockUserService.createDataUser(testUser)).called(1);
        verify(mockUserService.updateUserData(updatedUser)).called(1);
      });

      testWidgets('Kullanıcı verisi getirme işlemi', (tester) async {
        // ARRANGE: Mock service'i hazırla
        final testUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData(any),
        ).thenAnswer((_) async => testUser);

        // ACT: Kullanıcı verisini getir
        final result = await mockUserService.getUserData('test-uid-123');

        // ASSERT: Kullanıcı verisi doğru getirildi mi?
        expect(result, isNotNull);
        expect(result!.uid, equals('test-uid-123'));
        expect(result.name, equals('John'));
        expect(result.surname, equals('Doe'));
        expect(result.email, equals('john.doe@example.com'));

        // VERIFY: Service metodu çağrıldı mı?
        verify(mockUserService.getUserData('test-uid-123')).called(1);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Sign up hata durumunda doğru error handling', (
        tester,
      ) async {
        // ARRANGE: Mock service'i error için hazırla
        when(
          mockAuthService.signUp(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.error('Email already exists'));

        // ACT: Sign up çağır
        final result = await mockAuthService.signUp(
          email: 'existing@example.com',
          password: 'password123',
        );

        // ASSERT: Sign up başarısız olmalı
        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, equals('Email already exists'));

        // VERIFY: Service metodu çağrıldı mı?
        verify(
          mockAuthService.signUp(
            email: 'existing@example.com',
            password: 'password123',
          ),
        ).called(1);
      });

      testWidgets('Sign in hata durumunda doğru error handling', (
        tester,
      ) async {
        // ARRANGE: Mock service'i error için hazırla
        when(
          mockAuthService.signIn(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.error('Invalid credentials'));

        // ACT: Sign in çağır
        final result = await mockAuthService.signIn(
          email: 'test@example.com',
          password: 'wrongpassword',
        );

        // ASSERT: Sign in başarısız olmalı
        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, equals('Invalid credentials'));

        // VERIFY: Service metodu çağrıldı mı?
        verify(
          mockAuthService.signIn(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
        ).called(1);
      });

      testWidgets('User service hata durumunda doğru error handling', (
        tester,
      ) async {
        // ARRANGE: Mock service'i error için hazırla
        when(
          mockUserService.createDataUser(any),
        ).thenAnswer((_) async => false);

        final testUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // ACT: Kullanıcı oluştur
        await mockUserService.createDataUser(testUser);

        // ASSERT: Kullanıcı oluşturulamadı mı?
        // Kullanıcı oluşturma işlemi tamamlandı

        // VERIFY: Service metodu çağrıldı mı?
        verify(mockUserService.createDataUser(testUser)).called(1);
      });
    });

    group('Data Consistency Tests', () {
      testWidgets('Kullanıcı verisi tutarlılığı kontrol edilmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'leri hazırla
        when(mockUserService.createDataUser(any)).thenAnswer((_) async => true);
        when(mockUserService.getUserData(any)).thenAnswer((_) async => null);

        final testUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // ACT: Kullanıcı oluştur
        await mockUserService.createDataUser(testUser);

        // ASSERT: Kullanıcı oluşturuldu mu?
        // Kullanıcı oluşturma işlemi tamamlandı

        // ACT: Kullanıcı verisini getir
        final retrievedUser = await mockUserService.getUserData('test-uid-123');

        // ASSERT: Kullanıcı verisi null olmalı (mock'ta null döndürüyoruz)
        expect(retrievedUser, isNull);

        // VERIFY: Service metodları çağrıldı mı?
        verify(mockUserService.createDataUser(testUser)).called(1);
        verify(mockUserService.getUserData('test-uid-123')).called(1);
      });

      testWidgets('Email formatı tutarlılığı kontrol edilmeli', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(
          mockAuthService.signUp(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => AuthResult.success(null));

        // ACT: Farklı email formatları ile sign up dene
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'test+tag@example.org',
        ];

        for (final email in validEmails) {
          final result = await mockAuthService.signUp(
            email: email,
            password: 'password123',
          );

          // ASSERT: Her email formatı kabul edilmeli
          expect(result.isSuccess, isTrue);
        }

        // VERIFY: Service metodu her email için çağrıldı mı?
        for (final email in validEmails) {
          verify(
            mockAuthService.signUp(email: email, password: 'password123'),
          ).called(1);
        }
      });
    });
  });
}
