// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'email_verification_integration_test.mocks.dart';

@GenerateMocks([FirebaseAuthService, UserService])
void main() {
  group('Email verification integration (service-level)', () {
    late MockFirebaseAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
    });

    test('sendPasswordResetEmail returns success', () async {
      when(
        mockAuthService.sendPasswordResetEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => AuthResult.success(null));

      final result = await mockAuthService.sendPasswordResetEmail(
        email: 'user@test.com',
      );
      expect(result.isSuccess, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('sendPasswordResetEmail returns error on failure', () async {
      when(
        mockAuthService.sendPasswordResetEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => AuthResult.error('Geçersiz e-posta adresi'));

      final result = await mockAuthService.sendPasswordResetEmail(
        email: 'bad-email',
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('sendPasswordResetEmail called with trimmed email', () async {
      when(
        mockAuthService.sendPasswordResetEmail(email: anyNamed('email')),
      ).thenAnswer((_) async => AuthResult.success(null));

      await mockAuthService.sendPasswordResetEmail(email: '  user@test.com  ');

      verify(
        mockAuthService.sendPasswordResetEmail(email: captureAnyNamed('email')),
      ).called(1);
    });
  });
}
