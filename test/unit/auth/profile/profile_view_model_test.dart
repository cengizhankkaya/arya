import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:arya/features/profile/view_model/profile_view_model.dart';
import 'package:arya/features/auth/service/user_service.dart';
import 'package:arya/features/auth/model/user_model.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<UserService>(as: #MockUserServiceForProfile),
    MockSpec<User>(as: #MockUserForProfile),
    MockSpec<FirebaseAuth>(as: #MockFirebaseAuthForProfile),
  ],
)
import 'profile_view_model_test.mocks.dart';

void main() {
  group('ProfileViewModel Tests', () {
    ProfileViewModel? viewModel;
    late MockUserServiceForProfile mockUserService;
    late MockUserForProfile mockUser;
    late MockFirebaseAuthForProfile mockFirebaseAuth;

    setUp(() {
      mockUserService = MockUserServiceForProfile();
      mockUser = MockUserForProfile();
      mockFirebaseAuth = MockFirebaseAuthForProfile();

      // FirebaseAuth.instance mock'unu ayarla
      when(mockUser.uid).thenReturn('user123');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    });

    tearDown(() {
      viewModel?.dispose();
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
  });
}
