// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_integration_test.mocks.dart';

@GenerateMocks([FirebaseAuthService, UserService, ProfileViewModel])
void main() {
  group('Profile integration (view model to service)', () {
    late MockUserService mockUserService;
    late ProfileViewModel viewModel;

    setUp(() {
      mockUserService = MockUserService();
      viewModel = ProfileViewModel(userService: mockUserService);
    });

    test('updateUser fails gracefully when no user is loaded', () async {
      await viewModel.updateUser(name: 'X', surname: 'Y');
      expect(viewModel.errorMessage, isNotNull);
      verifyNever(mockUserService.updateUserData(any));
    });

    test('fetchUser without FirebaseAuth user sets error', () async {
      when(mockUserService.getUserData(any)).thenAnswer(
        (_) async =>
            UserModel(uid: '1', name: 'Ada', surname: 'L', email: 'a@b.com'),
      );

      await viewModel.fetchUser();
      expect(viewModel.hasUser, isFalse);
      expect(viewModel.errorMessage, isNotNull);
      expect(viewModel.nameController.text, '');
      expect(viewModel.surnameController.text, '');
    });

    test('toggleEditMode flips state and clears error on exit', () async {
      viewModel.toggleEditMode();
      expect(viewModel.isEditing, isTrue);
      viewModel.toggleEditMode();
      expect(viewModel.isEditing, isFalse);
      expect(viewModel.errorMessage, isNull);
    });
  });
}
