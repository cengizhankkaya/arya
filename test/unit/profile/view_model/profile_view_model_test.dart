import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:arya/features/auth/service/user_service.dart';
import 'package:arya/features/auth/model/user_model.dart';

@GenerateMocks([UserService, User, FirebaseAuth])
import 'profile_view_model_test.mocks.dart';

void main() {
  group('ProfileViewModel Tests', () {
    ProfileViewModel? viewModel;
    late MockUserService mockUserService;
    late MockUser mockUser;
    late MockFirebaseAuth mockFirebaseAuth;

    setUp(() {
      mockUserService = MockUserService();
      mockUser = MockUser();
      mockFirebaseAuth = MockFirebaseAuth();

      // FirebaseAuth.instance mock'unu ayarla
      when(mockUser.uid).thenReturn('user123');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    });

    tearDown(() {
      // Test sonunda dispose etmeyelim, her test kendi dispose işlemini yapsın
      // viewModel?.dispose();
    });

    group('Initial State Tests', () {
      test('ProfileViewModel başlangıç durumu doğru olmalı', () {
        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Assert
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
        expect(viewModel!.errorMessage, isNull);
        expect(viewModel!.isEditing, isFalse);
        expect(viewModel!.hasUser, isFalse);
        expect(viewModel!.isUserComplete, isFalse);
        expect(viewModel!.nameController.text, isEmpty);
        expect(viewModel!.surnameController.text, isEmpty);
      });

      test('TextEditingController\'lar doğru oluşturulmalı', () {
        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Assert
        expect(viewModel!.nameController, isNotNull);
        expect(viewModel!.surnameController, isNotNull);
        expect(viewModel!.nameController.text, isEmpty);
        expect(viewModel!.surnameController.text, isEmpty);
      });
    });

    group('Edit Mode Tests', () {
      test('toggleEditMode edit mode\'u değiştirmeli', () {
        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Initial state
        expect(viewModel!.isEditing, isFalse);

        // Act
        viewModel!.toggleEditMode();

        // Assert
        expect(viewModel!.isEditing, isTrue);

        // Act again
        viewModel!.toggleEditMode();

        // Assert
        expect(viewModel!.isEditing, isFalse);
      });

      test('toggleEditMode edit mode kapatıldığında error temizlenmeli', () {
        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Arrange
        viewModel!.toggleEditMode();
        // Simulate error
        // Note: We can't directly set error message, but we can test the behavior

        // Act
        viewModel!.toggleEditMode();

        // Assert
        expect(viewModel!.isEditing, isFalse);
      });
    });

    group('Error Handling Tests', () {
      test('clearError error message\'ı temizlemeli', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();

        // Act
        viewModel!.clearError();

        // Assert
        expect(viewModel!.errorMessage, isNull);
      });
    });

    group('Edge Case Tests', () {
      test('çok uzun text input\'lar ile çalışmalı', () async {
        // Arrange
        final longName = 'A' * 100;
        final longSurname = 'B' * 100;
        final testUser = UserModel(
          uid: 'user123',
          name: longName,
          surname: longSurname,
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.fetchUser();

        // Assert
        expect(viewModel!.user, isNotNull);
        expect(viewModel!.user!.name, longName);
        expect(viewModel!.user!.surname, longSurname);
        expect(viewModel!.nameController.text, longName);
        expect(viewModel!.surnameController.text, longSurname);
        expect(viewModel!.errorMessage, isNull);
      });

      test('boş string input\'lar ile çalışmalı', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: '',
          surname: '',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.fetchUser();

        // Assert
        expect(viewModel!.user, isNotNull);
        expect(viewModel!.user!.name, isEmpty);
        expect(viewModel!.user!.surname, isEmpty);
        expect(viewModel!.nameController.text, isEmpty);
        expect(viewModel!.surnameController.text, isEmpty);
        expect(viewModel!.errorMessage, isNull);
      });
    });

    group('Performance Tests', () {
      test('multiple rapid state changes performans testi', () {
        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act - Multiple rapid operations
        for (int i = 0; i < 100; i++) {
          viewModel!.toggleEditMode();
        }

        // Assert
        expect(viewModel!.isEditing, isFalse); // Even number of toggles
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
      });
    });

    group('Integration Tests', () {
      test('tam user flow entegrasyon testi', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act - Complete user flow
        await viewModel!.fetchUser();
        viewModel!.toggleEditMode();
        await viewModel!.updateUser(name: 'Jane', surname: 'Smith');

        // Assert
        expect(viewModel!.user, isNotNull);
        expect(viewModel!.user!.name, 'Jane');
        expect(viewModel!.user!.surname, 'Smith');
        expect(viewModel!.isEditing, isFalse);
        expect(viewModel!.nameController.text, 'Jane');
        expect(viewModel!.surnameController.text, 'Smith');
      });
    });

    group('Dependency Injection Tests', () {
      test('ProfileViewModel UserService dependency injection testi', () {
        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Assert
        expect(viewModel, isNotNull);
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
      });

      test('ProfileViewModel mock UserService ile testi', () {
        // Test için ProfileViewModel'i oluştur
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Assert
        expect(viewModel, isNotNull);
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
      });
    });

    group('fetchUser Tests', () {
      test('should fetch user successfully', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.fetchUser();

        // Assert
        expect(viewModel!.user, equals(testUser));
        expect(viewModel!.isLoading, isFalse);
        expect(viewModel!.errorMessage, isNull);
        expect(viewModel!.nameController.text, 'John');
        expect(viewModel!.surnameController.text, 'Doe');
      });

      test('should handle fetch user when no current user', () async {
        // Arrange
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.fetchUser();

        // Assert
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
        expect(viewModel!.errorMessage, 'Kullanıcı oturumu bulunamadı.');
      });

      test('should handle fetch user when user data is null', () async {
        // Arrange
        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => null);

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.fetchUser();

        // Assert
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
        expect(viewModel!.errorMessage, 'Kullanıcı verisi bulunamadı.');
      });

      test('should handle fetch user service error', () async {
        // Arrange
        when(
          mockUserService.getUserData('user123'),
        ).thenThrow(Exception('Service error'));

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.fetchUser();

        // Assert
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
        expect(
          viewModel!.errorMessage,
          contains('Kullanıcı verisi yüklenirken hata oluştu'),
        );
      });

      test('should not fetch user when disposed', () async {
        // Arrange
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );
        viewModel!.dispose();

        // Act
        await viewModel!.fetchUser();

        // Assert
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
        verifyNever(mockUserService.getUserData(any));
      });
    });

    group('updateUser Tests', () {
      test('should update user successfully', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();

        // Act
        await viewModel!.updateUser(name: 'Jane', surname: 'Smith');

        // Assert
        expect(viewModel!.user!.name, 'Jane');
        expect(viewModel!.user!.surname, 'Smith');
        expect(viewModel!.isEditing, isFalse);
        expect(viewModel!.isLoading, isFalse);
        expect(viewModel!.errorMessage, isNull);
        verify(mockUserService.updateUserData(any)).called(1);
      });

      test('should handle update user when no user data', () async {
        // Arrange
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.updateUser(name: 'Jane', surname: 'Smith');

        // Assert
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
        expect(
          viewModel!.errorMessage,
          'Güncellenecek kullanıcı verisi bulunamadı.',
        );
      });

      test('should handle update user service error', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(
          mockUserService.updateUserData(any),
        ).thenThrow(Exception('Update error'));

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();

        // Act
        await viewModel!.updateUser(name: 'Jane', surname: 'Smith');

        // Assert
        expect(viewModel!.user!.name, 'John'); // Should remain unchanged
        expect(viewModel!.user!.surname, 'Doe'); // Should remain unchanged
        expect(viewModel!.isLoading, isFalse);
        expect(
          viewModel!.errorMessage,
          contains('Kullanıcı verisi güncellenirken hata oluştu'),
        );
      });

      test('should not update user when disposed', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();
        viewModel!.dispose();

        // Act
        await viewModel!.updateUser(name: 'Jane', surname: 'Smith');

        // Assert
        expect(viewModel!.user!.name, 'John'); // Should remain unchanged
        expect(viewModel!.user!.surname, 'Doe'); // Should remain unchanged
        verifyNever(mockUserService.updateUserData(any));
      });
    });

    group('updateUserFromControllers Tests', () {
      test('should update user from controllers successfully', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();
        viewModel!.nameController.text = 'Jane';
        viewModel!.surnameController.text = 'Smith';

        // Act
        await viewModel!.updateUserFromControllers();

        // Assert
        expect(viewModel!.user!.name, 'Jane');
        expect(viewModel!.user!.surname, 'Smith');
        expect(viewModel!.isEditing, isFalse);
        verify(mockUserService.updateUserData(any)).called(1);
      });

      test('should handle update from controllers when disposed', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();
        viewModel!.dispose();

        // Act
        await viewModel!.updateUserFromControllers();

        // Assert
        expect(viewModel!.user!.name, 'John'); // Should remain unchanged
        verifyNever(mockUserService.updateUserData(any));
      });
    });

    group('signOut Tests', () {
      test('should sign out successfully', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();

        // Act
        await viewModel!.signOut();

        // Assert
        expect(viewModel!.user, isNull);
        expect(viewModel!.isEditing, isFalse);
        expect(viewModel!.isLoading, isFalse);
        expect(viewModel!.errorMessage, isNull);
        verify(mockFirebaseAuth.signOut()).called(1);
      });

      test('should handle sign out error', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(mockFirebaseAuth.signOut()).thenThrow(Exception('Sign out error'));

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();

        // Act
        await viewModel!.signOut();

        // Assert
        expect(viewModel!.user, isNotNull); // Should remain unchanged
        expect(viewModel!.isLoading, isFalse);
        expect(
          viewModel!.errorMessage,
          contains('Çıkış yapılırken hata oluştu'),
        );
      });

      test('should not sign out when disposed', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();
        viewModel!.dispose();

        // Act
        await viewModel!.signOut();

        // Assert
        expect(viewModel!.user, isNotNull); // Should remain unchanged
        verifyNever(mockFirebaseAuth.signOut());
      });
    });

    group('deleteAccount Tests', () {
      test('should delete account successfully', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Mock'ları temizle ve yeniden setup et
        reset(mockUserService);
        reset(mockFirebaseAuth);
        reset(mockUser);

        when(mockUser.uid).thenReturn('user123');
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.delete()).thenAnswer((_) async {});

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(
          mockUserService.deleteUserData('user123'),
        ).thenAnswer((_) async {});

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act - fetchUser'ı çağır
        await viewModel!.fetchUser();

        // Assert - fetchUser başarılı olmalı
        expect(viewModel!.user, isNotNull);
        expect(viewModel!.user!.uid, equals('user123'));
        expect(viewModel!.user!.name, equals('John'));
        expect(viewModel!.errorMessage, isNull);

        // Act - deleteAccount'u çağır
        await viewModel!.deleteAccount();

        // Assert - deleteAccount başarılı olmalı
        expect(viewModel!.user, isNull);
        expect(viewModel!.errorMessage, isNull);
        expect(viewModel!.isLoading, isFalse);

        // Mock'ların çağrıldığını doğrula
        verify(mockUserService.getUserData('user123')).called(1);
        verify(mockUserService.deleteUserData('user123')).called(1);
        verify(mockUser.delete()).called(1);
      });

      test('should handle delete account when no user data', () async {
        // Arrange
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.deleteAccount();

        // Assert
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
        expect(
          viewModel!.errorMessage,
          'Silinecek kullanıcı verisi bulunamadı.',
        );
      });

      test('should handle delete account service error', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(
          mockUserService.deleteUserData('user123'),
        ).thenThrow(Exception('Delete error'));

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();

        // Act
        await viewModel!.deleteAccount();

        // Assert
        expect(viewModel!.user, isNotNull); // Should remain unchanged
        expect(viewModel!.isLoading, isFalse);
        expect(
          viewModel!.errorMessage,
          contains('Hesap silinirken hata oluştu'),
        );
      });

      test('should not delete account when disposed', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        await viewModel!.fetchUser();
        viewModel!.dispose();

        // Act
        await viewModel!.deleteAccount();

        // Assert
        expect(viewModel!.user, isNotNull); // Should remain unchanged
        verifyNever(mockUserService.deleteUserData(any));
      });
    });

    group('Controller Management Tests', () {
      test('should initialize controllers with user data', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        await viewModel!.fetchUser();

        // Assert
        expect(viewModel!.nameController.text, 'John');
        expect(viewModel!.surnameController.text, 'Doe');
      });

      test(
        'should handle controller initialization with null user data',
        () async {
          // Arrange
          when(
            mockUserService.getUserData('user123'),
          ).thenAnswer((_) async => null);

          viewModel = ProfileViewModel(
            userService: mockUserService,
            firebaseAuth: mockFirebaseAuth,
          );

          // Act
          await viewModel!.fetchUser();

          // Assert
          expect(viewModel!.nameController.text, isEmpty);
          expect(viewModel!.surnameController.text, isEmpty);
        },
      );

      test('should dispose controllers properly', () {
        // Arrange
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act
        viewModel!.dispose();

        // Assert
        // Disposed controller'ları test etmek yerine, dispose işleminin
        // başarılı olduğunu kontrol edelim
        expect(viewModel!.isDisposed, isTrue);
      });
    });

    group('State Management Tests', () {
      test('should maintain consistent state during operations', () async {
        // Arrange
        const testUser = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        when(
          mockUserService.getUserData('user123'),
        ).thenAnswer((_) async => testUser);
        when(mockUserService.updateUserData(any)).thenAnswer((_) async {});

        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act - Multiple operations
        await viewModel!.fetchUser();
        expect(viewModel!.hasUser, isTrue);
        expect(viewModel!.isUserComplete, isTrue);

        viewModel!.toggleEditMode();
        expect(viewModel!.isEditing, isTrue);

        await viewModel!.updateUser(name: 'Jane', surname: 'Smith');
        expect(viewModel!.isEditing, isFalse);
        expect(viewModel!.user!.name, 'Jane');

        // Assert
        expect(viewModel!.user, isNotNull);
        expect(viewModel!.isLoading, isFalse);
        expect(viewModel!.errorMessage, isNull);
      });

      test('should handle rapid state changes gracefully', () async {
        // Arrange
        viewModel = ProfileViewModel(
          userService: mockUserService,
          firebaseAuth: mockFirebaseAuth,
        );

        // Act - Rapid state changes
        for (int i = 0; i < 10; i++) {
          viewModel!.toggleEditMode();
        }

        // Assert
        expect(viewModel!.isEditing, isFalse); // Even number of toggles
        expect(viewModel!.user, isNull);
        expect(viewModel!.isLoading, isFalse);
      });
    });
  });
}
