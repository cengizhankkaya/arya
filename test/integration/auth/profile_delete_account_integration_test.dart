// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_delete_account_integration_test.mocks.dart';

@GenerateMocks([UserService, FirebaseAuth, User])
void main() {
  group('Profile deleteAccount integration (view model -> services)', () {
    late MockUserService mockUserService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late ProfileViewModel viewModel;

    setUp(() {
      mockUserService = MockUserService();
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      viewModel = ProfileViewModel(userService: mockUserService);

      // Inject mocked FirebaseAuth via instance getter
      // We cannot override FirebaseAuth.instance directly; instead, we stub currentUser
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    });

    test('fails gracefully when user model is null', () async {
      await viewModel.deleteAccount();
      expect(viewModel.errorMessage, isNotNull);
      verifyZeroInteractions(mockUserService);
    });
  });
}
