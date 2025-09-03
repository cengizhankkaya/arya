// ignore_for_file: prefer_const_constructors

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_error_mapping_integration_test.mocks.dart';
import 'package:arya/product/constants/auth_constants.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  group('Auth error mapping integration (service -> TR messages)', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FirebaseAuthService authService;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = FirebaseAuthService(auth: mockFirebaseAuth);
    });

    Future<void> _stubSignInThrows(String code) async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(FirebaseAuthException(code: code));
    }

    Future<void> _stubSignUpThrows(String code) async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(FirebaseAuthException(code: code));
    }

    Future<void> _stubResetThrows(String code) async {
      when(
        mockFirebaseAuth.sendPasswordResetEmail(email: anyNamed('email')),
      ).thenThrow(FirebaseAuthException(code: code));
    }

    test('signIn invalid-email -> TR message', () async {
      await _stubSignInThrows(AuthConstants.invalidEmail);
      final result = await authService.signIn(email: 'x', password: 'y');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('Geçersiz e-posta'));
    });

    test('signIn wrong-password -> TR message', () async {
      await _stubSignInThrows(AuthConstants.wrongPassword);
      final result = await authService.signIn(email: 'a@b.com', password: 'x');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('Yanlış şifre'));
    });

    test('signIn user-not-found -> TR message', () async {
      await _stubSignInThrows(AuthConstants.userNotFound);
      final result = await authService.signIn(
        email: 'none@b.com',
        password: 'x',
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('kayıtlı kullanıcı bulunamadı'));
    });

    test('signIn user-disabled -> TR message', () async {
      await _stubSignInThrows(AuthConstants.userDisabled);
      final result = await authService.signIn(email: 'a@b.com', password: 'x');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('devre dışı'));
    });

    test('signIn network-request-failed -> TR message', () async {
      await _stubSignInThrows(AuthConstants.networkRequestFailed);
      final result = await authService.signIn(email: 'a@b.com', password: 'x');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('İnternet bağlantınızı kont'));
    });

    test('signIn too-many-requests -> TR message', () async {
      await _stubSignInThrows(AuthConstants.tooManyRequests);
      final result = await authService.signIn(email: 'a@b.com', password: 'x');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('Çok fazla'));
    });

    test('signUp email-already-in-use -> TR message', () async {
      await _stubSignUpThrows(AuthConstants.emailAlreadyInUse);
      final result = await authService.signUp(
        email: 'dup@b.com',
        password: 'x',
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('zaten kullanımda'));
    });

    test('signUp weak-password -> TR message', () async {
      await _stubSignUpThrows(AuthConstants.weakPassword);
      final result = await authService.signUp(email: 'a@b.com', password: '1');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('Şifre çok zayıf'));
    });

    test('signIn invalid-credential -> TR message', () async {
      await _stubSignInThrows(AuthConstants.invalidCredential);
      final result = await authService.signIn(email: 'a@b.com', password: 'x');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('Geçersiz kimlik'));
    });

    test('signIn operation-not-allowed -> TR message', () async {
      await _stubSignInThrows(AuthConstants.operationNotAllowed);
      final result = await authService.signIn(email: 'a@b.com', password: 'x');
      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('etkin değil'));
    });

    group('password reset mapping', () {
      test('invalid-email', () async {
        await _stubResetThrows(AuthConstants.invalidEmail);
        final r = await authService.sendPasswordResetEmail(email: 'x');
        expect(r.isSuccess, isFalse);
        expect(r.errorMessage, contains('Geçersiz e-posta'));
      });

      test('user-not-found', () async {
        await _stubResetThrows(AuthConstants.userNotFound);
        final r = await authService.sendPasswordResetEmail(email: 'x@x');
        expect(r.isSuccess, isFalse);
        expect(r.errorMessage, contains('kayıtlı kullanıcı bulunamadı'));
      });

      test('too-many-requests', () async {
        await _stubResetThrows(AuthConstants.tooManyRequests);
        final r = await authService.sendPasswordResetEmail(email: 'x@x');
        expect(r.isSuccess, isFalse);
        expect(r.errorMessage, contains('Çok fazla'));
      });

      test('network-request-failed', () async {
        await _stubResetThrows(AuthConstants.networkRequestFailed);
        final r = await authService.sendPasswordResetEmail(email: 'x@x');
        expect(r.isSuccess, isFalse);
        expect(r.errorMessage, contains('İnternet bağlantınızı kont'));
      });
    });
  });
}
