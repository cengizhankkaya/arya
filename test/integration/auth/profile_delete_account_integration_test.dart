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
      
      // Mock FirebaseAuth.currentUser
      when(mockUser.uid).thenReturn('user123');
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      
      // Create ProfileViewModel with mocked dependencies
      viewModel = ProfileViewModel(
        userService: mockUserService,
        firebaseAuth: mockFirebaseAuth,
      );
    });

    test('fails gracefully when user model is null', () async {
      await viewModel.deleteAccount();
      expect(viewModel.errorMessage, isNotNull);
      verifyZeroInteractions(mockUserService);
    });
  });
}
