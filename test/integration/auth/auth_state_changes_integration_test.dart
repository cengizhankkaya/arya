// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_state_changes_integration_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User])
void main() {
  group('Auth state changes integration (service -> authStateChanges)', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FirebaseAuthService authService;
    late StreamController<User?> controller;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      authService = FirebaseAuthService(auth: mockFirebaseAuth);
      controller = StreamController<User?>.broadcast();
      when(
        mockFirebaseAuth.authStateChanges(),
      ).thenAnswer((_) => controller.stream);
    });

    tearDown(() async {
      await controller.close();
    });

    test('emits User on sign-in and null on sign-out', () async {
      final emitted = <User?>[];
      final sub = authService.authStateChanges.listen(emitted.add);

      // Simüle: giriş yapıldı
      final mockUser = MockUser();
      controller.add(mockUser);
      // Simüle: çıkış yapıldı
      controller.add(null);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub.cancel();

      expect(emitted.length, greaterThanOrEqualTo(2));
      expect(emitted.first, isNotNull);
      expect(emitted.last, isNull);
    });
  });
}
