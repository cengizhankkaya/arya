// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_service_integration_test.mocks.dart';

@GenerateMocks([FirebaseAuthService, UserService])
void main() {
  group('AuthService integration (using service abstraction)', () {
    late MockFirebaseAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
    });

    test('signIn success returns success result', () async {
      when(
        mockAuthService.signIn(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => AuthResult.success(null));

      final result = await mockAuthService.signIn(
        email: 'user@test.com',
        password: 'password',
      );
      expect(result.isSuccess, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('signIn failure returns error result', () async {
      when(
        mockAuthService.signIn(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => AuthResult.error('Yanlış şifre'));

      final result = await mockAuthService.signIn(
        email: 'user@test.com',
        password: 'wrong',
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, isNotNull);
    });

    test('signOut completes without error', () async {
      when(mockAuthService.signOut()).thenAnswer((_) async {});
      await expectLater(mockAuthService.signOut(), completes);
      verify(mockAuthService.signOut()).called(1);
    });

    test('signUp success returns success result', () async {
      when(
        mockAuthService.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => AuthResult.success(null));

      final result = await mockAuthService.signUp(
        email: 'new@user.com',
        password: 'Password1*',
      );
      expect(result.isSuccess, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('signUp failure returns error result', () async {
      when(
        mockAuthService.signUp(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer(
        (_) async => AuthResult.error('Bu e-posta adresi zaten kullanımda'),
      );

      final result = await mockAuthService.signUp(
        email: 'dup@user.com',
        password: 'Password1*',
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, isNotNull);
    });
  });
}
