// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'password_reset_integration_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  group('Password reset integration (service -> FirebaseAuth)', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FirebaseAuthService authService;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = FirebaseAuthService(auth: mockFirebaseAuth);
    });

    test('sendPasswordResetEmail success returns success result', () async {
      when(
        mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => Future.value());

      final result = await authService.sendPasswordResetEmail(
        email: 'user@test.com',
      );

      expect(result.isSuccess, isTrue);
      expect(result.errorMessage, isNull);
      verify(
        mockFirebaseAuth.sendPasswordResetEmail(email: 'user@test.com'),
      ).called(1);
    });

    test('email is trimmed before sending reset email', () async {
      when(
        mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => Future.value());

      await authService.sendPasswordResetEmail(email: '  spaced@test.com  ');

      verify(
        mockFirebaseAuth.sendPasswordResetEmail(email: 'spaced@test.com'),
      ).called(1);
    });
  });
}
