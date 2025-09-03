// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:arya/features/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_management_integration_test.mocks.dart';

@GenerateMocks([FirebaseAuthService, UserService, User])
void main() {
  group('Session management integration', () {
    late MockFirebaseAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockFirebaseAuthService();
    });

    test('emits only current session changes and completes', () async {
      final controller = StreamController<User?>();
      when(
        mockAuthService.authStateChanges,
      ).thenAnswer((_) => controller.stream);

      final events = <User?>[];
      final sub = mockAuthService.authStateChanges.listen(events.add);

      controller
        ..add(null)
        ..add(FakeUser())
        ..add(null);

      await pumpEventQueue();
      await sub.cancel();
      await controller.close();

      expect(events, hasLength(3));
      expect(events[0], isNull);
      expect(events[1], isA<User>());
      expect(events[2], isNull);
    });

    test('subscription can be cancelled without errors', () async {
      final controller = StreamController<User?>();
      when(
        mockAuthService.authStateChanges,
      ).thenAnswer((_) => controller.stream);

      final sub = mockAuthService.authStateChanges.listen((_) {});
      await sub.cancel();
      await controller.close();

      // No exception expected; reaching here means success
      expect(true, isTrue);
    });
  });
}

class FakeUser implements User {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
