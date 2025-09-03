import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:arya/features/auth/service/user_service.dart';
import 'package:arya/features/auth/model/user_model.dart';

import 'user_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  group('UserService', () {
    late UserService userService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;
    late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
    late MockQuery<Map<String, dynamic>> mockQuery;
    late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
    late MockQueryDocumentSnapshot<Map<String, dynamic>>
    mockQueryDocumentSnapshot;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference<Map<String, dynamic>>();
      mockDocument = MockDocumentReference<Map<String, dynamic>>();
      mockDocumentSnapshot = MockDocumentSnapshot<Map<String, dynamic>>();
      mockQuery = MockQuery<Map<String, dynamic>>();
      mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      mockQueryDocumentSnapshot =
          MockQueryDocumentSnapshot<Map<String, dynamic>>();

      userService = UserService(firestore: mockFirestore);
    });

    tearDown(() {
      reset(mockFirestore);
      reset(mockCollection);
      reset(mockDocument);
      reset(mockDocumentSnapshot);
      reset(mockQuery);
      reset(mockQuerySnapshot);
      reset(mockQueryDocumentSnapshot);
    });

    group('createDataUser Tests', () {
      test('should create user data successfully', () async {
        // Arrange
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenAnswer((_) async => null);

        // Act
        await userService.createDataUser(user);

        // Assert
        verify(mockFirestore.collection('users')).called(1);
        verify(mockCollection.doc('user123')).called(1);
        verify(mockDocument.set(any)).called(1);
      });

      test('should throw permission denied exception', () async {
        // Arrange
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // Act & Assert
        expect(
          () => userService.createDataUser(user),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('should throw network error exception', () async {
        // Arrange
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'network',
            message: 'Network error',
          ),
        );

        // Act & Assert
        expect(
          () => userService.createDataUser(user),
          throwsA(
            predicate((e) => e.toString().contains('Ağ bağlantısı hatası')),
          ),
        );
      });

      test('should throw generic exception for other errors', () async {
        // Arrange
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenThrow(Exception('Unknown error'));

        // Act & Assert
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
      test('should return user data when document exists', () async {
        // Arrange
        const userData = {
          'uid': 'user123',
          'name': 'John',
          'surname': 'Doe',
          'email': 'john.doe@example.com',
        };
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(true);
        when(mockDocumentSnapshot.data()).thenReturn(userData);

        // Act
        final result = await userService.getUserData('user123');

        // Assert
        expect(result, isNotNull);
        expect(result!.uid, 'user123');
        expect(result.name, 'John');
        expect(result.surname, 'Doe');
        expect(result.email, 'john.doe@example.com');
        verify(mockFirestore.collection('users')).called(1);
        verify(mockCollection.doc('user123')).called(1);
        verify(mockDocument.get()).called(1);
      });

      test('should return null when document does not exist', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.get()).thenAnswer((_) async => mockDocumentSnapshot);
        when(mockDocumentSnapshot.exists).thenReturn(false);

        // Act
        final result = await userService.getUserData('user123');

        // Assert
        expect(result, isNull);
        verify(mockFirestore.collection('users')).called(1);
        verify(mockCollection.doc('user123')).called(1);
        verify(mockDocument.get()).called(1);
      });

      test('should throw permission denied exception', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.get()).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // Act & Assert
        expect(
          () => userService.getUserData('user123'),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('should throw generic exception for other errors', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.get()).thenThrow(Exception('Unknown error'));

        // Act & Assert
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
      test('should update user data successfully', () async {
        // Arrange
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.update(any)).thenAnswer((_) async => null);

        // Act
        await userService.updateUserData(user);

        // Assert
        verify(mockFirestore.collection('users')).called(1);
        verify(mockCollection.doc('user123')).called(1);
        verify(mockDocument.update(any)).called(1);
      });

      test('should throw permission denied exception', () async {
        // Arrange
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.update(any)).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // Act & Assert
        expect(
          () => userService.updateUserData(user),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('should throw generic exception for other errors', () async {
        // Arrange
        const user = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.update(any)).thenThrow(Exception('Unknown error'));

        // Act & Assert
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
      test('should delete user data successfully', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.delete()).thenAnswer((_) async => null);

        // Act
        await userService.deleteUserData('user123');

        // Assert
        verify(mockFirestore.collection('users')).called(1);
        verify(mockCollection.doc('user123')).called(1);
        verify(mockDocument.delete()).called(1);
      });

      test('should throw permission denied exception', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.delete()).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // Act & Assert
        expect(
          () => userService.deleteUserData('user123'),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('should throw generic exception for other errors', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('user123')).thenReturn(mockDocument);
        when(mockDocument.delete()).thenThrow(Exception('Unknown error'));

        // Act & Assert
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

    group('getUserByEmail Tests', () {
      test('should return user when found by email', () async {
        // Arrange
        const userData = {
          'uid': 'user123',
          'name': 'John',
          'surname': 'Doe',
          'email': 'john.doe@example.com',
        };
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('email', isEqualTo: 'john.doe@example.com'),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(userData);

        // Act
        final result = await userService.getUserByEmail('john.doe@example.com');

        // Assert
        expect(result, isNotNull);
        expect(result!.uid, 'user123');
        expect(result.email, 'john.doe@example.com');
        verify(mockFirestore.collection('users')).called(1);
        verify(
          mockCollection.where('email', isEqualTo: 'john.doe@example.com'),
        ).called(1);
        verify(mockQuery.limit(1)).called(1);
        verify(mockQuery.get()).called(1);
      });

      test('should return null when user not found by email', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('email', isEqualTo: 'nonexistent@example.com'),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await userService.getUserByEmail(
          'nonexistent@example.com',
        );

        // Assert
        expect(result, isNull);
        verify(mockFirestore.collection('users')).called(1);
        verify(
          mockCollection.where('email', isEqualTo: 'nonexistent@example.com'),
        ).called(1);
        verify(mockQuery.limit(1)).called(1);
        verify(mockQuery.get()).called(1);
      });

      test('should throw permission denied exception', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('email', isEqualTo: 'john.doe@example.com'),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // Act & Assert
        expect(
          () => userService.getUserByEmail('john.doe@example.com'),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('should throw generic exception for other errors', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('email', isEqualTo: 'john.doe@example.com'),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenThrow(Exception('Unknown error'));

        // Act & Assert
        expect(
          () => userService.getUserByEmail('john.doe@example.com'),
          throwsA(
            predicate(
              (e) => e.toString().contains('E-posta ile kullanıcı aranamadı'),
            ),
          ),
        );
      });
    });

    group('getUserByUsername Tests', () {
      test('should return user when found by username', () async {
        // Arrange
        const userData = {
          'uid': 'user123',
          'name': 'John',
          'surname': 'Doe',
          'username': 'johndoe',
          'email': 'john.doe@example.com',
        };
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('username', isEqualTo: 'johndoe'),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);
        when(mockQueryDocumentSnapshot.data()).thenReturn(userData);

        // Act
        final result = await userService.getUserByUsername('johndoe');

        // Assert
        expect(result, isNotNull);
        expect(result!.uid, 'user123');
        expect(result.username, 'johndoe');
        verify(mockFirestore.collection('users')).called(1);
        verify(
          mockCollection.where('username', isEqualTo: 'johndoe'),
        ).called(1);
        verify(mockQuery.limit(1)).called(1);
        verify(mockQuery.get()).called(1);
      });

      test('should return null when user not found by username', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('username', isEqualTo: 'nonexistent'),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await userService.getUserByUsername('nonexistent');

        // Assert
        expect(result, isNull);
        verify(mockFirestore.collection('users')).called(1);
        verify(
          mockCollection.where('username', isEqualTo: 'nonexistent'),
        ).called(1);
        verify(mockQuery.limit(1)).called(1);
        verify(mockQuery.get()).called(1);
      });

      test('should throw permission denied exception', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('username', isEqualTo: 'johndoe'),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenThrow(
          FirebaseException(
            plugin: 'firestore',
            code: 'permission-denied',
            message: 'Permission denied',
          ),
        );

        // Act & Assert
        expect(
          () => userService.getUserByUsername('johndoe'),
          throwsA(
            predicate((e) => e.toString().contains('Firestore izin hatası')),
          ),
        );
      });

      test('should throw generic exception for other errors', () async {
        // Arrange
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('username', isEqualTo: 'johndoe'),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenThrow(Exception('Unknown error'));

        // Act & Assert
        expect(
          () => userService.getUserByUsername('johndoe'),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Kullanıcı adı ile kullanıcı aranamadı',
              ),
            ),
          ),
        );
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty uid', () async {
        // Arrange
        const user = UserModel(
          uid: '',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc('')).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenAnswer((_) async => null);

        // Act
        await userService.createDataUser(user);

        // Assert
        verify(mockCollection.doc('')).called(1);
      });

      test('should handle null user data', () async {
        // Arrange
        const user = UserModel();
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(mockCollection.doc(null)).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenAnswer((_) async => null);

        // Act
        await userService.createDataUser(user);

        // Assert
        verify(mockCollection.doc(null)).called(1);
      });

      test('should handle very long email', () async {
        // Arrange
        final longEmail = 'a' * 100 + '@example.com';
        when(mockFirestore.collection('users')).thenReturn(mockCollection);
        when(
          mockCollection.where('email', isEqualTo: longEmail),
        ).thenReturn(mockQuery);
        when(mockQuery.limit(1)).thenReturn(mockQuery);
        when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([]);

        // Act
        final result = await userService.getUserByEmail(longEmail);

        // Assert
        expect(result, isNull);
        verify(mockCollection.where('email', isEqualTo: longEmail)).called(1);
      });
    });

    group('Integration Tests', () {
      test(
        'should handle complete workflow: create -> get -> update -> delete',
        () async {
          // Arrange
          const user = UserModel(
            uid: 'user123',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          // Setup mocks for create
          when(mockFirestore.collection('users')).thenReturn(mockCollection);
          when(mockCollection.doc('user123')).thenReturn(mockDocument);
          when(mockDocument.set(any)).thenAnswer((_) async => null);
          when(
            mockDocument.get(),
          ).thenAnswer((_) async => mockDocumentSnapshot);
          when(mockDocument.update(any)).thenAnswer((_) async => null);
          when(mockDocument.delete()).thenAnswer((_) async => null);

          // Setup mocks for get
          when(mockDocumentSnapshot.exists).thenReturn(true);
          when(mockDocumentSnapshot.data()).thenReturn(user.toJson());

          // Act - Create
          await userService.createDataUser(user);

          // Act - Get
          final retrievedUser = await userService.getUserData('user123');

          // Act - Update
          final updatedUser = user.copyWith(name: 'Jane');
          await userService.updateUserData(updatedUser);

          // Act - Delete
          await userService.deleteUserData('user123');

          // Assert
          expect(retrievedUser, isNotNull);
          expect(retrievedUser!.name, 'John');
          verify(mockDocument.set(any)).called(1);
          verify(mockDocument.get()).called(1);
          verify(mockDocument.update(any)).called(1);
          verify(mockDocument.delete()).called(1);
        },
      );
    });
  });
}
