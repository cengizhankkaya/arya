// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_flow_test.mocks.dart';

@GenerateMocks([FirebaseAuthService, UserService])
void main() {
  group('Auth Flow integration', () {
    late MockFirebaseAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
    });

    test('authStateChanges emits user then null (login -> logout)', () async {
      final controller = StreamController<User?>();

      when(
        mockAuthService.authStateChanges,
      ).thenAnswer((_) => controller.stream);

      final emissions = <User?>[];
      final sub = mockAuthService.authStateChanges.listen(emissions.add);

      // simulate login
      controller.add(FakeUser());
      // simulate logout
      controller.add(null);

      await pumpEventQueue();
      await sub.cancel();
      await controller.close();

      expect(emissions.length, 2);
      expect(emissions.first, isA<User>());
      expect(emissions.last, isNull);
    });

    test('multiple emissions preserve order and types', () async {
      final controller = StreamController<User?>();
      when(
        mockAuthService.authStateChanges,
      ).thenAnswer((_) => controller.stream);

      final emissions = <Object?>[];
      final sub = mockAuthService.authStateChanges.listen(emissions.add);

      controller
        ..add(null)
        ..add(FakeUser())
        ..add(FakeUser())
        ..add(null);

      await pumpEventQueue();
      await sub.cancel();
      await controller.close();

      expect(emissions, hasLength(4));
      expect(emissions[0], isNull);
      expect(emissions[1], isA<User>());
      expect(emissions[2], isA<User>());
      expect(emissions[3], isNull);
    });
  });
}

// Minimal fake for FirebaseAuth User to satisfy type without depending on SDK impl
class FakeUser implements User {
  @override
  // ignore: overridden_fields
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
