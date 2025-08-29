import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arya/features/auth/service/user_service.dart';
import 'package:arya/features/auth/model/user_model.dart';
import 'package:mockito/mockito.dart';

// Mock sınıfları
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

// Test için UserService'i extend eden mock sınıf
class TestUserService extends UserService {
  final FirebaseFirestore firestore;

  TestUserService(this.firestore);

  @override
  FirebaseFirestore get _firestore => firestore;
}

void main() {
  group('UserService', () {
    late TestUserService userService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockDocumentReference mockDocument;
    late MockDocumentSnapshot mockDocumentSnapshot;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockDocument = MockDocumentReference();
      mockDocumentSnapshot = MockDocumentSnapshot();

      userService = TestUserService(mockFirestore);
    });

    group('createDataUser Tests', () {
      test('başarılı kullanıcı oluşturma', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.set(<String, dynamic>{})).thenAnswer((_) async => {});

        // ACT (Eylem) - Kullanıcı oluştur
        await userService.createDataUser(user);

        // ASSERT (Doğrulama) - Firestore'a kayıt yapıldı
        verify(mockFirestore.collection('users')).called(1);
        verify(mockCollection.doc('user123')).called(1);
        verify(mockDocument.set(<String, dynamic>{})).called(1);
      });

      test('permission-denied hatası ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: 'user123',
          name: 'John',
          email: 'john@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.set(<String, dynamic>{})).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.createDataUser(user),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('network hatası ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: 'user123',
          name: 'John',
          email: 'john@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.set(<String, dynamic>{})).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'network-request-failed',
            message: 'Network error',
          ),
        );

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.createDataUser(user),
          throwsA(
            predicate((e) => e.toString().contains('Ağ bağlantısı hatası')),
          ),
        );
      });

      test('genel hata ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: 'user123',
          name: 'John',
          email: 'john@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(
          mockDocument.set(<String, dynamic>{}),
        ).thenThrow(Exception('Unknown error'));

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.createDataUser(user),
          throwsA(
            predicate(
              (e) => e.toString().contains('Kullanıcı verisi kaydedilemedi'),
            ),
          ),
        );
      });
    });

    group('getUserData Tests', () {
      test('mevcut kullanıcı verisi başarıyla getirilmeli', () async {
        // Arrange (Hazırlık)
        final userData = {
          'uid': 'user123',
          'name': 'John',
          'surname': 'Doe',
          'email': 'john@example.com',
        };

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockDocumentSnapshot.data()).thenReturn(userData);

        // ACT (Eylem) - Kullanıcı verisi getir
        final result = await userService.getUserData('user123');

        // ASSERT (Doğrulama) - UserModel döndürülmeli
        expect(result, isNotNull);
        expect(result!.uid, equals('user123'));
        expect(result.name, equals('John'));
        expect(result.surname, equals('Doe'));
        expect(result.email, equals('john@example.com'));
      });

      test('mevcut olmayan kullanıcı için null döndürmeli', () async {
        // Arrange (Hazırlık)
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(false);

        // ACT (Eylem) - Mevcut olmayan kullanıcı verisi getir
        final result = await userService.getUserData('user123');

        // ASSERT (Doğrulama) - Null döndürülmeli
        expect(result, isNull);
      });

      test('permission-denied hatası ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.get()).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.getUserData('user123'),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('genel hata ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.get()).thenThrow(Exception('Unknown error'));

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.getUserData('user123'),
          throwsA(
            predicate(
              (e) => e.toString().contains('Kullanıcı verisi okunamadı'),
            ),
          ),
        );
      });
    });

    group('updateUserData Tests', () {
      test('başarılı kullanıcı güncelleme', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: 'user123',
          name: 'John Updated',
          surname: 'Doe',
          email: 'john@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(
          mockDocument.update(<Object, Object?>{}),
        ).thenAnswer((_) async => {});

        // ACT (Eylem) - Kullanıcı güncelle
        await userService.updateUserData(user);

        // ASSERT (Doğrulama) - Firestore'da güncelleme yapıldı
        verify(mockFirestore.collection('users')).called(1);
        verify(mockCollection.doc('user123')).called(1);
        verify(mockDocument.update(<Object, Object?>{})).called(1);
      });

      test('permission-denied hatası ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: 'user123',
          name: 'John',
          email: 'john@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.update(<Object, Object?>{})).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.updateUserData(user),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('genel hata ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: 'user123',
          name: 'John',
          email: 'john@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(
          mockDocument.update(<Object, Object?>{}),
        ).thenThrow(Exception('Unknown error'));

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.updateUserData(user),
          throwsA(
            predicate(
              (e) => e.toString().contains('Kullanıcı verisi güncellenemedi'),
            ),
          ),
        );
      });
    });

    group('deleteUserData Tests', () {
      test('başarılı kullanıcı silme', () async {
        // Arrange (Hazırlık)
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.delete()).thenAnswer((_) async => {});

        // ACT (Eylem) - Kullanıcı sil
        await userService.deleteUserData('user123');

        // ASSERT (Doğrulama) - Firestore'dan silme yapıldı
        verify(mockFirestore.collection('users')).called(1);
        verify(mockCollection.doc('user123')).called(1);
        verify(mockDocument.delete()).called(1);
      });

      test('permission-denied hatası ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.delete()).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.deleteUserData('user123'),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('genel hata ile exception fırlatmalı', () async {
        // Arrange (Hazırlık)
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.delete()).thenThrow(Exception('Unknown error'));

        // ACT & ASSERT (Eylem ve Doğrulama) - Exception fırlatılmalı
        expect(
          () => userService.deleteUserData('user123'),
          throwsA(
            predicate(
              (e) => e.toString().contains('Kullanıcı verisi silinemedi'),
            ),
          ),
        );
      });
    });

    group('Edge Cases Tests', () {
      test('boş UID ile işlem yapılamamalı', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: '',
          name: 'John',
          email: 'john@example.com',
        );

        // ACT & ASSERT (Eylem ve Doğrulama) - Boş UID ile işlem yapılamaz
        expect(() => userService.createDataUser(user), throwsA(anything));
      });

      test('null UID ile işlem yapılamamalı', () async {
        // Arrange (Hazırlık)
        final user = UserModel(
          uid: null,
          name: 'John',
          email: 'john@example.com',
        );

        // ACT & ASSERT (Eylem ve Doğrulama) - Null UID ile işlem yapılamaz
        expect(() => userService.createDataUser(user), throwsA(anything));
      });

      test('çok uzun UID ile işlem yapılabilmeli', () async {
        // Arrange (Hazırlık)
        final longUid = 'a' * 1000;
        final user = UserModel(
          uid: longUid,
          name: 'John',
          email: 'john@example.com',
        );

        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc(longUid)).thenReturn(mockDocument);
        when(mockDocument.set(<String, dynamic>{})).thenAnswer((_) async => {});

        // ACT (Eylem) - Uzun UID ile kullanıcı oluştur
        await userService.createDataUser(user);

        // ASSERT (Doğrulama) - İşlem başarılı olmalı
        verify(mockDocument.set(<String, dynamic>{})).called(1);
      });
    });
  });
}
