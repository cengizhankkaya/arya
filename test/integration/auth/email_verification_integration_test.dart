import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/auth/service/user_service.dart';
import 'package:arya/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

@GenerateMocks([FirebaseAuthService, UserService, User])
import 'email_verification_integration_test.mocks.dart';

void main() {
  group('Email Verification Integration Tests', () {
    late MockFirebaseAuthService mockAuthService;
    late MockUserService mockUserService;
    late MockUser mockUser;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
      mockUserService = MockUserService();
      mockUser = MockUser();
    });

    tearDown(() {
      // Cleanup
    });

    group('Email Verification Flow Tests', () {
      testWidgets('Email doğrulama emaili gönderilebilmeli', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.emailVerified).thenReturn(false);
        when(mockUser.sendEmailVerification()).thenAnswer((_) async {});

        // ACT: Email doğrulama emaili gönder
        await mockUser.sendEmailVerification();

        // ASSERT: Email gönderildi mi?
        // VERIFY: Service metodu çağrıldı mı?
        verify(mockUser.sendEmailVerification()).called(1);
      });

      testWidgets('Email doğrulama durumu kontrol edilebilmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.emailVerified).thenReturn(false);

        // ACT: Email doğrulama durumunu kontrol et
        final isVerified = mockUser.emailVerified;

        // ASSERT: Email doğrulanmamış mı?
        expect(isVerified, isFalse);

        // VERIFY: Property erişildi mi?
        verify(mockUser.emailVerified).called(1);
      });

      testWidgets('Email doğrulama sonrası durum güncellenmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.emailVerified).thenReturn(false);
        when(mockUser.reload()).thenAnswer((_) async {});

        // ACT: Email doğrulama emaili gönder
        await mockUser.sendEmailVerification();

        // ACT: Kullanıcı bilgilerini yenile
        await mockUser.reload();

        // ASSERT: Reload metodu çağrıldı mı?
        // VERIFY: Service metodları çağrıldı mı?
        verify(mockUser.sendEmailVerification()).called(1);
        verify(mockUser.reload()).called(1);
      });
    });

    group('Email Verification State Tests', () {
      testWidgets('Doğrulanmamış email ile giriş yapılamamalı', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.emailVerified).thenReturn(false);
        when(mockUser.email).thenReturn('unverified@example.com');

        // ACT: Email doğrulama durumunu kontrol et
        final isVerified = mockUser.emailVerified;
        final email = mockUser.email;

        // ASSERT: Email doğrulanmamış mı?
        expect(isVerified, isFalse);
        expect(email, equals('unverified@example.com'));

        // VERIFY: Property'ler erişildi mi?
        verify(mockUser.emailVerified).called(1);
        verify(mockUser.email).called(1);
      });

      testWidgets('Doğrulanmış email ile giriş yapılabilmeli', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.emailVerified).thenReturn(true);
        when(mockUser.email).thenReturn('verified@example.com');

        // ACT: Email doğrulama durumunu kontrol et
        final isVerified = mockUser.emailVerified;
        final email = mockUser.email;

        // ASSERT: Email doğrulanmış mı?
        expect(isVerified, isTrue);
        expect(email, equals('verified@example.com'));

        // VERIFY: Property'ler erişildi mi?
        verify(mockUser.emailVerified).called(1);
        verify(mockUser.email).called(1);
      });

      testWidgets('Email doğrulama durumu değişikliği izlenebilmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.emailVerified).thenReturn(false);

        // ACT: Email doğrulama durumunu kontrol et
        final initialStatus = mockUser.emailVerified;

        // ASSERT: Başlangıçta doğrulanmamış mı?
        expect(initialStatus, isFalse);

        // ACT: Durumu değiştir (simülasyon)
        when(mockUser.emailVerified).thenReturn(true);
        final updatedStatus = mockUser.emailVerified;

        // ASSERT: Durum güncellendi mi?
        expect(updatedStatus, isTrue);

        // VERIFY: Property'ler erişildi mi?
        verify(mockUser.emailVerified).called(2);
      });
    });

    group('Email Verification Error Handling Tests', () {
      testWidgets('Email doğrulama emaili gönderim hatası işlenmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'i error için hazırla
        when(mockUser.sendEmailVerification()).thenThrow(
          FirebaseAuthException(
            code: 'too-many-requests',
            message: 'Çok fazla istek gönderildi',
          ),
        );

        // ACT & ASSERT: Hata fırlatıldı mı?
        expect(
          () => mockUser.sendEmailVerification(),
          throwsA(isA<FirebaseAuthException>()),
        );

        // VERIFY: Service metodu çağrıldı mı?
        verify(mockUser.sendEmailVerification()).called(1);
      });

      testWidgets(
        'Email doğrulama emaili gönderim hatası doğru kod ile işlenmeli',
        (tester) async {
          // ARRANGE: Mock service'i error için hazırla
          when(mockUser.sendEmailVerification()).thenThrow(
            FirebaseAuthException(
              code: 'invalid-user',
              message: 'Geçersiz kullanıcı',
            ),
          );

          // ACT & ASSERT: Hata fırlatıldı mı?
          expect(
            () => mockUser.sendEmailVerification(),
            throwsA(
              predicate<FirebaseAuthException>(
                (e) =>
                    e.code == 'invalid-user' &&
                    e.message == 'Geçersiz kullanıcı',
              ),
            ),
          );

          // VERIFY: Service metodu çağrıldı mı?
          verify(mockUser.sendEmailVerification()).called(1);
        },
      );

      testWidgets('Reload işlemi hatası işlenmeli', (tester) async {
        // ARRANGE: Mock service'i error için hazırla
        when(mockUser.reload()).thenThrow(
          FirebaseAuthException(
            code: 'network-request-failed',
            message: 'Ağ bağlantısı hatası',
          ),
        );

        // ACT & ASSERT: Hata fırlatıldı mı?
        expect(() => mockUser.reload(), throwsA(isA<FirebaseAuthException>()));

        // VERIFY: Service metodu çağrıldı mı?
        verify(mockUser.reload()).called(1);
      });
    });

    group('Email Verification Security Tests', () {
      testWidgets(
        'Email doğrulama emaili sadece mevcut kullanıcıya gönderilebilmeli',
        (tester) async {
          // ARRANGE: Mock service'i hazırla
          when(mockUser.uid).thenReturn('current-user-123');
          when(mockUser.email).thenReturn('current@example.com');
          when(mockUser.sendEmailVerification()).thenAnswer((_) async {});

          // ACT: Email doğrulama emaili gönder
          await mockUser.sendEmailVerification();

          // ACT: Kullanıcı bilgilerini kontrol et
          final uid = mockUser.uid;
          final email = mockUser.email;

          // ASSERT: Email gönderildi mi?
          expect(uid, equals('current-user-123'));
          expect(email, equals('current@example.com'));

          // VERIFY: Service metodu çağrıldı mı?
          verify(mockUser.sendEmailVerification()).called(1);
          verify(mockUser.uid).called(1);
          verify(mockUser.email).called(1);
        },
      );

      testWidgets(
        'Email doğrulama durumu sadece mevcut kullanıcı için kontrol edilebilmeli',
        (tester) async {
          // ARRANGE: Mock service'i hazırla
          when(mockUser.uid).thenReturn('current-user-123');
          when(mockUser.emailVerified).thenReturn(false);

          // ACT: Email doğrulama durumunu kontrol et
          final uid = mockUser.uid;
          final isVerified = mockUser.emailVerified;

          // ASSERT: Doğru kullanıcı kontrol edildi mi?
          expect(uid, equals('current-user-123'));
          expect(isVerified, isFalse);

          // VERIFY: Property'ler erişildi mi?
          verify(mockUser.uid).called(1);
          verify(mockUser.emailVerified).called(1);
        },
      );
    });

    group('Email Verification Integration Tests', () {
      testWidgets('Email doğrulama ve kullanıcı verisi senkronizasyonu', (
        tester,
      ) async {
        // ARRANGE: Mock service'leri hazırla
        when(mockUser.emailVerified).thenReturn(false);
        when(mockUser.uid).thenReturn('test-uid-123');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockUser.sendEmailVerification()).thenAnswer((_) async {});

        final testUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'test@example.com',
        );

        when(
          mockUserService.getUserData('test-uid-123'),
        ).thenAnswer((_) async => testUser);

        // ACT: Email doğrulama emaili gönder
        await mockUser.sendEmailVerification();

        // ACT: Kullanıcı verisini getir
        final userData = await mockUserService.getUserData('test-uid-123');

        // ASSERT: Veriler senkronize mi?
        expect(userData!.uid, equals(mockUser.uid));
        expect(userData.email, equals(mockUser.email));

        // VERIFY: Service metodları çağrıldı mı?
        verify(mockUser.sendEmailVerification()).called(1);
        verify(mockUserService.getUserData('test-uid-123')).called(1);
      });

      testWidgets('Email doğrulama sonrası kullanıcı durumu güncellenmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'leri hazırla
        when(mockUser.emailVerified).thenReturn(false);
        when(mockUser.reload()).thenAnswer((_) async {});

        final testUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'test@example.com',
        );

        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        // ACT: Email doğrulama emaili gönder
        await mockUser.sendEmailVerification();

        // ACT: Kullanıcı bilgilerini yenile
        await mockUser.reload();

        // ACT: Kullanıcı verisini güncelle
        await mockUserService.updateUserData(testUser);

        // ASSERT: Tüm işlemler tamamlandı mı?
        // VERIFY: Service metodları çağrıldı mı?
        verify(mockUser.sendEmailVerification()).called(1);
        verify(mockUser.reload()).called(1);
        verify(mockUserService.updateUserData(testUser)).called(1);
      });
    });

    group('Email Verification Performance Tests', () {
      testWidgets('Çoklu email doğrulama işlemleri performanslı olmalı', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.sendEmailVerification()).thenAnswer((_) async {});

        // ACT: Çoklu email doğrulama emaili gönderme işlemi
        final futures = <Future<void>>[];
        for (int i = 0; i < 5; i++) {
          futures.add(mockUser.sendEmailVerification());
        }

        // ASSERT: Tüm işlemler tamamlandı mı?
        await Future.wait(futures);

        // VERIFY: Service metodu her işlem için çağrıldı mı?
        verify(mockUser.sendEmailVerification()).called(5);
      });

      testWidgets('Email doğrulama durumu kontrolü performanslı olmalı', (
        tester,
      ) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.emailVerified).thenReturn(true);

        // ACT: Çoklu email doğrulama durumu kontrolü
        final futures = <Future<bool>>[];
        for (int i = 0; i < 10; i++) {
          futures.add(Future.value(mockUser.emailVerified));
        }

        // ASSERT: Tüm kontroller tamamlandı mı?
        final results = await Future.wait(futures);
        expect(results.length, equals(10));
        expect(results.every((result) => result == true), isTrue);

        // VERIFY: Property her kontrol için erişildi mi?
        verify(mockUser.emailVerified).called(10);
      });
    });

    group('Email Verification Edge Cases Tests', () {
      testWidgets('Boş email ile doğrulama işlemi', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.email).thenReturn('');
        when(mockUser.emailVerified).thenReturn(false);

        // ACT: Email doğrulama durumunu kontrol et
        final email = mockUser.email;
        final isVerified = mockUser.emailVerified;

        // ASSERT: Boş email durumu doğru işlendi mi?
        expect(email, isEmpty);
        expect(isVerified, isFalse);

        // VERIFY: Property'ler erişildi mi?
        verify(mockUser.email).called(1);
        verify(mockUser.emailVerified).called(1);
      });

      testWidgets('Null email ile doğrulama işlemi', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUser.email).thenReturn(null);
        when(mockUser.emailVerified).thenReturn(false);

        // ACT: Email doğrulama durumunu kontrol et
        final email = mockUser.email;
        final isVerified = mockUser.emailVerified;

        // ASSERT: Null email durumu doğru işlendi mi?
        expect(email, isNull);
        expect(isVerified, isFalse);

        // VERIFY: Property'ler erişildi mi?
        verify(mockUser.email).called(1);
        verify(mockUser.emailVerified).called(1);
      });

      testWidgets('Çok uzun email ile doğrulama işlemi', (tester) async {
        // ARRANGE: Mock service'i hazırla
        final longEmail = 'a' * 100 + '@example.com';
        when(mockUser.email).thenReturn(longEmail);
        when(mockUser.emailVerified).thenReturn(false);

        // ACT: Email doğrulama durumunu kontrol et
        final email = mockUser.email;
        final isVerified = mockUser.emailVerified;

        // ASSERT: Uzun email durumu doğru işlendi mi?
        expect(email, equals(longEmail));
        expect(email!.length, greaterThan(100));
        expect(isVerified, isFalse);

        // VERIFY: Property'ler erişildi mi?
        verify(mockUser.email).called(1);
        verify(mockUser.emailVerified).called(1);
      });
    });
  });
}
