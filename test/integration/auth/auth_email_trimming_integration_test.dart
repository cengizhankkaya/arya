// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_email_trimming_integration_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  group('Auth email trimming integration (service -> SDK)', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FirebaseAuthService authService;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = FirebaseAuthService(auth: mockFirebaseAuth);
    });

    test('signIn trims email before calling FirebaseAuth', () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'user@test.com',
          password: 'x',
        ),
      ).thenAnswer((_) async => FakeUserCredential.success());

      await authService.signIn(email: '  user@test.com  ', password: 'x');

      verify(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'user@test.com',
          password: 'x',
        ),
      ).called(1);
    });

    test('signUp trims email before calling FirebaseAuth', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'new@user.com',
          password: 'Password1*',
        ),
      ).thenAnswer((_) async => FakeUserCredential.success());

      await authService.signUp(
        email: '  new@user.com  ',
        password: 'Password1*',
      );

      verify(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'new@user.com',
          password: 'Password1*',
        ),
      ).called(1);
    });
  });
}

// Minimal fake for UserCredential to satisfy type usage
class FakeUserCredential implements UserCredential {
  FakeUserCredential._();

  factory FakeUserCredential.success() => FakeUserCredential._();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
