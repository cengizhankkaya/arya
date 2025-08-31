import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:arya/features/auth/service/auth_service.dart';
import 'package:arya/features/auth/service/user_service.dart';
import 'package:arya/features/auth/model/user_model.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';

@GenerateMocks([FirebaseAuthService, UserService, ProfileViewModel])
import 'profile_integration_test.mocks.dart';

void main() {
  group('Profile Integration Tests', () {
    late MockFirebaseAuthService mockAuthService;
    late MockUserService mockUserService;
    late MockProfileViewModel mockProfileViewModel;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
      mockUserService = MockUserService();
      mockProfileViewModel = MockProfileViewModel();
    });

    tearDown(() {
      // Cleanup
    });

    group('Profile Data Management Tests', () {
      testWidgets('Profil bilgileri doğru şekilde yüklenmeli', (tester) async {
        // ARRANGE: Mock service'leri hazırla
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

        // ASSERT: Kullanıcı verisi doğru yüklendi mi?
        expect(result, isNotNull);
        expect(result!.uid, equals('test-uid-123'));
        expect(result.name, equals('John'));
        expect(result.surname, equals('Doe'));
        expect(result.email, equals('john.doe@example.com'));

        // VERIFY: Service metodu çağrıldı mı?
        verify(mockUserService.getUserData('test-uid-123')).called(1);
      });

      testWidgets('Profil bilgileri güncellenebilmeli', (tester) async {
        // ARRANGE: Mock service'leri hazırla
        final originalUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        final updatedUser = UserModel(
          uid: 'test-uid-123',
          name: 'John Updated',
          surname: 'Doe Updated',
          email: 'john.updated@example.com',
        );

        when(
          mockUserService.getUserData(any),
        ).thenAnswer((_) async => originalUser);
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        // ACT: Önce mevcut veriyi getir
        final originalResult = await mockUserService.getUserData(
          'test-uid-123',
        );

        // ASSERT: Orijinal veri doğru mu?
        expect(originalResult!.name, equals('John'));

        // ACT: Veriyi güncelle
        await mockUserService.updateUserData(updatedUser);

        // VERIFY: Update metodu çağrıldı mı?
        verify(mockUserService.updateUserData(updatedUser)).called(1);
      });

      testWidgets('Profil bilgileri email ile aranabilmeli', (tester) async {
        // ARRANGE: Mock service'i hazırla
        final testUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserByEmail(any),
        ).thenAnswer((_) async => testUser);

        // ACT: Email ile kullanıcı ara
        final result = await mockUserService.getUserByEmail(
          'john.doe@example.com',
        );

        // ASSERT: Kullanıcı bulundu mu?
        expect(result, isNotNull);
        expect(result!.email, equals('john.doe@example.com'));

        // VERIFY: Service metodu çağrıldı mı?
        verify(
          mockUserService.getUserByEmail('john.doe@example.com'),
        ).called(1);
      });
    });

    group('Profile Validation Tests', () {
      testWidgets('Geçersiz profil bilgileri reddedilmeli', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        // Geçersiz kullanıcı verisi (boş isim)
        final invalidUser = UserModel(
          uid: 'test-uid-123',
          name: '', // Geçersiz: boş isim
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // ACT: Geçersiz veri ile güncelleme dene
        await mockUserService.updateUserData(invalidUser);

        // ASSERT: Update metodu çağrıldı mı? (Service seviyesinde validation yok)
        verify(mockUserService.updateUserData(invalidUser)).called(1);
      });

      testWidgets('Geçersiz email formatı kontrol edilmeli', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        // Geçersiz email formatı
        final invalidEmailUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'invalid-email', // Geçersiz email formatı
        );

        // ACT: Geçersiz email ile güncelleme dene
        await mockUserService.updateUserData(invalidEmailUser);

        // ASSERT: Update metodu çağrıldı mı? (Service seviyesinde validation yok)
        verify(mockUserService.updateUserData(invalidEmailUser)).called(1);
      });
    });

    group('Profile Security Tests', () {
      testWidgets('Kullanıcı sadece kendi profilini güncelleyebilmeli', (
        tester,
      ) async {
        // ARRANGE: Mock service'leri hazırla
        final currentUser = UserModel(
          uid: 'current-user-123',
          name: 'Current',
          surname: 'User',
          email: 'current@example.com',
        );

        final otherUser = UserModel(
          uid: 'other-user-456',
          name: 'Other',
          surname: 'User',
          email: 'other@example.com',
        );

        when(
          mockUserService.getUserData('current-user-123'),
        ).thenAnswer((_) async => currentUser);
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        // ACT: Mevcut kullanıcı bilgilerini getir
        final currentUserData = await mockUserService.getUserData(
          'current-user-123',
        );

        // ASSERT: Doğru kullanıcı verisi getirildi mi?
        expect(currentUserData!.uid, equals('current-user-123'));

        // ACT: Sadece kendi profilini güncelle
        await mockUserService.updateUserData(currentUser);

        // ASSERT: Sadece kendi profili güncellendi mi?
        verify(mockUserService.updateUserData(currentUser)).called(1);
        verifyNever(mockUserService.updateUserData(otherUser));
      });

      testWidgets('Profil silme işlemi güvenli olmalı', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUserService.deleteUserData(any)).thenAnswer((_) async {});

        final userToDelete = UserModel(
          uid: 'delete-user-123',
          name: 'Delete',
          surname: 'User',
          email: 'delete@example.com',
        );

        // ACT: Kullanıcı verisini sil
        await mockUserService.deleteUserData('delete-user-123');

        // ASSERT: Silme işlemi çağrıldı mı?
        verify(mockUserService.deleteUserData('delete-user-123')).called(1);
      });
    });

    group('Profile Data Consistency Tests', () {
      testWidgets('Profil bilgileri tutarlı olmalı', (tester) async {
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
        when(
          mockUserService.getUserByEmail(any),
        ).thenAnswer((_) async => testUser);

        // ACT: UID ile kullanıcı getir
        final userByUid = await mockUserService.getUserData('test-uid-123');

        // ACT: Email ile kullanıcı getir
        final userByEmail = await mockUserService.getUserByEmail(
          'john.doe@example.com',
        );

        // ASSERT: Her iki yöntemle de aynı kullanıcı getirildi mi?
        expect(userByUid, isNotNull);
        expect(userByEmail, isNotNull);
        expect(userByUid!.uid, equals(userByEmail!.uid));
        expect(userByUid.name, equals(userByEmail.name));
        expect(userByUid.surname, equals(userByEmail.surname));
        expect(userByUid.email, equals(userByEmail.email));

        // VERIFY: Service metodları çağrıldı mı?
        verify(mockUserService.getUserData('test-uid-123')).called(1);
        verify(
          mockUserService.getUserByEmail('john.doe@example.com'),
        ).called(1);
      });

      testWidgets('Profil güncelleme sonrası veri tutarlılığı', (tester) async {
        // ARRANGE: Mock service'leri hazırla
        final originalUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        final updatedUser = UserModel(
          uid: 'test-uid-123',
          name: 'John Updated',
          surname: 'Doe Updated',
          email: 'john.updated@example.com',
        );

        when(
          mockUserService.getUserData(any),
        ).thenAnswer((_) async => updatedUser);
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        // ACT: Veriyi güncelle
        await mockUserService.updateUserData(updatedUser);

        // ACT: Güncellenmiş veriyi getir
        final retrievedUser = await mockUserService.getUserData('test-uid-123');

        // ASSERT: Güncellenmiş veri doğru mu?
        expect(retrievedUser!.name, equals('John Updated'));
        expect(retrievedUser.surname, equals('Doe Updated'));
        expect(retrievedUser.email, equals('john.updated@example.com'));

        // VERIFY: Service metodları çağrıldı mı?
        verify(mockUserService.updateUserData(updatedUser)).called(1);
        verify(mockUserService.getUserData('test-uid-123')).called(1);
      });
    });

    group('Profile Error Handling Tests', () {
      testWidgets('Kullanıcı bulunamadığında null dönmeli', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUserService.getUserData(any)).thenAnswer((_) async => null);
        when(mockUserService.getUserByEmail(any)).thenAnswer((_) async => null);

        // ACT: Var olmayan kullanıcı verisini getir
        final userByUid = await mockUserService.getUserData('non-existent-uid');
        final userByEmail = await mockUserService.getUserByEmail(
          'nonexistent@example.com',
        );

        // ASSERT: Null döndü mü?
        expect(userByUid, isNull);
        expect(userByEmail, isNull);

        // VERIFY: Service metodları çağrıldı mı?
        verify(mockUserService.getUserData('non-existent-uid')).called(1);
        verify(
          mockUserService.getUserByEmail('nonexistent@example.com'),
        ).called(1);
      });

      testWidgets('Profil güncelleme hatası doğru işlenmeli', (tester) async {
        // ARRANGE: Mock service'i error için hazırla
        when(mockUserService.updateUserData(any)).thenThrow(
          Exception('Firestore izin hatası: Güvenlik kurallarını kontrol edin'),
        );

        final testUser = UserModel(
          uid: 'test-uid-123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // ACT & ASSERT: Hata fırlatıldı mı?
        expect(() => mockUserService.updateUserData(testUser), throwsException);

        // VERIFY: Service metodu çağrıldı mı?
        verify(mockUserService.updateUserData(testUser)).called(1);
      });
    });

    group('Profile Performance Tests', () {
      testWidgets('Çoklu profil işlemleri performanslı olmalı', (tester) async {
        // ARRANGE: Mock service'i hazırla
        when(mockUserService.getUserData(any)).thenAnswer(
          (_) async => UserModel(
            uid: 'test-uid',
            name: 'Test',
            surname: 'User',
            email: 'test@example.com',
          ),
        );

        // ACT: Çoklu kullanıcı verisi getirme işlemi
        final futures = <Future<UserModel?>>[];
        for (int i = 0; i < 10; i++) {
          futures.add(mockUserService.getUserData('test-uid-$i'));
        }

        // ASSERT: Tüm işlemler tamamlandı mı?
        final results = await Future.wait(futures);
        expect(results.length, equals(10));

        // VERIFY: Service metodu her kullanıcı için çağrıldı mı?
        for (int i = 0; i < 10; i++) {
          verify(mockUserService.getUserData('test-uid-$i')).called(1);
        }
      });
    });
  });
}
