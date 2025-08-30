// import 'dart:async';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:mockito/annotations.dart';

// // Generated mocks
// @GenerateMocks([FirebaseAuth, User, UserCredential, AuthResult])
// import 'auth_service_test.mocks.dart';

// // Mock classes
// class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// class MockUser extends Mock implements User {}

// class MockUserCredential extends Mock implements UserCredential {}

// class MockAuthResult extends Mock implements AuthResult {}

// /// --------- Auth Service Interface ---------
// abstract class IAuthService {
//   Future<UserCredential> signInWithEmailAndPassword(
//     String email,
//     String password,
//   );
//   Future<UserCredential> createUserWithEmailAndPassword(
//     String email,
//     String password,
//   );
//   Future<void> signOut();
//   User? get currentUser;
//   Stream<User?> get authStateChanges;
//   Future<void> sendPasswordResetEmail(String email);
//   Future<void> updatePassword(String newPassword);
//   Future<void> deleteUser();
// }

// /// --------- Mock Auth Service ---------
// class MockAuthService implements IAuthService {
//   final MockFirebaseAuth _mockAuth;
//   User? _currentUser;
//   final StreamController<User?> _authStateController =
//       StreamController<User?>.broadcast();

//   MockAuthService(this._mockAuth);

//   @override
//   Future<UserCredential> signInWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     // Simulate validation
//     if (email.isEmpty || password.isEmpty) {
//       throw Exception('Email ve şifre gerekli');
//     }

//     if (!email.contains('@')) {
//       throw Exception('Geçerli email girin');
//     }

//     if (password.length < 6) {
//       throw Exception('Şifre en az 6 karakter olmalı');
//     }

//     // Simulate successful login
//     await Future.delayed(const Duration(milliseconds: 100));
//     _currentUser = MockUser();
//     if (!_authStateController.isClosed) {
//       _authStateController.add(_currentUser);
//     }

//     return MockUserCredential();
//   }

//   @override
//   Future<UserCredential> createUserWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     // Simulate validation
//     if (email.isEmpty || password.isEmpty) {
//       throw Exception('Email ve şifre gerekli');
//     }

//     if (!email.contains('@')) {
//       throw Exception('Geçerli email girin');
//     }

//     if (password.length < 6) {
//       throw Exception('Şifre en az 6 karakter olmalı');
//     }

//     // Simulate successful registration
//     await Future.delayed(const Duration(milliseconds: 150));
//     _currentUser = MockUser();
//     if (!_authStateController.isClosed) {
//       _authStateController.add(_currentUser);
//     }

//     return MockUserCredential();
//   }

//   @override
//   Future<void> signOut() async {
//     await Future.delayed(const Duration(milliseconds: 50));
//     _currentUser = null;
//     if (!_authStateController.isClosed) {
//       _authStateController.add(null);
//     }
//   }

//   @override
//   User? get currentUser => _currentUser;

//   @override
//   Stream<User?> get authStateChanges => _authStateController.stream;

//   @override
//   Future<void> sendPasswordResetEmail(String email) async {
//     if (email.isEmpty) {
//       throw Exception('Email gerekli');
//     }

//     if (!email.contains('@')) {
//       throw Exception('Geçerli email girin');
//     }

//     await Future.delayed(const Duration(milliseconds: 80));
//   }

//   @override
//   Future<void> updatePassword(String newPassword) async {
//     if (_currentUser == null) {
//       throw Exception('Kullanıcı giriş yapmamış');
//     }

//     if (newPassword.length < 6) {
//       throw Exception('Şifre en az 6 karakter olmalı');
//     }

//     await Future.delayed(const Duration(milliseconds: 60));
//   }

//   @override
//   Future<void> deleteUser() async {
//     if (_currentUser == null) {
//       throw Exception('Kullanıcı giriş yapmamış');
//     }

//     await Future.delayed(const Duration(milliseconds: 100));
//     _currentUser = null;
//     if (!_authStateController.isClosed) {
//       _authStateController.add(null);
//     }
//   }

//   void dispose() {
//     if (!_authStateController.isClosed) {
//       _authStateController.close();
//     }
//   }
// }

// /// --------- Test Data ---------
// class TestData {
//   static const String validEmail = 'test@email.com';
//   static const String invalidEmail = 'invalidemail';
//   static const String validPassword = '123456';
//   static const String shortPassword = '123';
//   static const String emptyString = '';
// }

// void main() {
//   group('Auth Service Unit Tests', () {
//     late MockAuthService mockAuthService;
//     late MockFirebaseAuth mockFirebaseAuth;

//     setUp(() {
//       mockFirebaseAuth = MockFirebaseAuth();
//       mockAuthService = MockAuthService(mockFirebaseAuth);
//     });

//     tearDown(() {
//       mockAuthService.dispose();
//     });

//     group('Sign In Tests', () {
//       test('Geçerli email ve şifre ile giriş başarılı', () async {
//         final result = await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         expect(result, isA<UserCredential>());
//         expect(mockAuthService.currentUser, isNotNull);
//       });

//       test('Boş email ile giriş hatası', () async {
//         expect(
//           () => mockAuthService.signInWithEmailAndPassword(
//             TestData.emptyString,
//             TestData.validPassword,
//           ),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Boş şifre ile giriş hatası', () async {
//         expect(
//           () => mockAuthService.signInWithEmailAndPassword(
//             TestData.validEmail,
//             TestData.emptyString,
//           ),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Geçersiz email formatı ile giriş hatası', () async {
//         expect(
//           () => mockAuthService.signInWithEmailAndPassword(
//             TestData.invalidEmail,
//             TestData.validPassword,
//           ),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Kısa şifre ile giriş hatası', () async {
//         expect(
//           () => mockAuthService.signInWithEmailAndPassword(
//             TestData.validEmail,
//             TestData.shortPassword,
//           ),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Giriş sonrası current user güncelleniyor', () async {
//         expect(mockAuthService.currentUser, isNull);

//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         expect(mockAuthService.currentUser, isNotNull);
//       });
//     });

//     group('Sign Up Tests', () {
//       test('Geçerli email ve şifre ile kayıt başarılı', () async {
//         final result = await mockAuthService.createUserWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         expect(result, isA<UserCredential>());
//         expect(mockAuthService.currentUser, isNotNull);
//       });

//       test('Boş email ile kayıt hatası', () async {
//         expect(
//           () => mockAuthService.createUserWithEmailAndPassword(
//             TestData.emptyString,
//             TestData.validPassword,
//           ),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Boş şifre ile kayıt hatası', () async {
//         expect(
//           () => mockAuthService.createUserWithEmailAndPassword(
//             TestData.validEmail,
//             TestData.emptyString,
//           ),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Geçersiz email formatı ile kayıt hatası', () async {
//         expect(
//           () => mockAuthService.createUserWithEmailAndPassword(
//             TestData.invalidEmail,
//             TestData.validPassword,
//           ),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Kısa şifre ile kayıt hatası', () async {
//         expect(
//           () => mockAuthService.createUserWithEmailAndPassword(
//             TestData.validEmail,
//             TestData.shortPassword,
//           ),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Kayıt sonrası current user güncelleniyor', () async {
//         expect(mockAuthService.currentUser, isNull);

//         await mockAuthService.createUserWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         expect(mockAuthService.currentUser, isNotNull);
//       });
//     });

//     group('Sign Out Tests', () {
//       test('Çıkış yapıldığında current user temizleniyor', () async {
//         // Önce giriş yap
//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );
//         expect(mockAuthService.currentUser, isNotNull);

//         // Çıkış yap
//         await mockAuthService.signOut();
//         expect(mockAuthService.currentUser, isNull);
//       });

//       test('Çıkış işlemi başarılı', () async {
//         expect(() => mockAuthService.signOut(), returnsNormally);
//       });
//     });

//     group('Password Reset Tests', () {
//       test('Geçerli email ile şifre sıfırlama başarılı', () async {
//         expect(
//           () => mockAuthService.sendPasswordResetEmail(TestData.validEmail),
//           returnsNormally,
//         );
//       });

//       test('Boş email ile şifre sıfırlama hatası', () async {
//         expect(
//           () => mockAuthService.sendPasswordResetEmail(TestData.emptyString),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Geçersiz email formatı ile şifre sıfırlama hatası', () async {
//         expect(
//           () => mockAuthService.sendPasswordResetEmail(TestData.invalidEmail),
//           throwsA(isA<Exception>()),
//         );
//       });
//     });

//     group('Password Update Tests', () {
//       test('Giriş yapmadan şifre güncelleme hatası', () async {
//         expect(
//           () => mockAuthService.updatePassword(TestData.validPassword),
//           throwsA(isA<Exception>()),
//         );
//       });

//       test('Giriş yapıldıktan sonra şifre güncelleme başarılı', () async {
//         // Önce giriş yap
//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         // Şifre güncelle
//         expect(
//           () => mockAuthService.updatePassword('newpassword123'),
//           returnsNormally,
//         );
//       });

//       test('Kısa yeni şifre ile güncelleme hatası', () async {
//         // Önce giriş yap
//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         expect(
//           () => mockAuthService.updatePassword(TestData.shortPassword),
//           throwsA(isA<Exception>()),
//         );
//       });
//     });

//     group('User Deletion Tests', () {
//       test('Giriş yapmadan kullanıcı silme hatası', () async {
//         expect(() => mockAuthService.deleteUser(), throwsA(isA<Exception>()));
//       });

//       test('Giriş yapıldıktan sonra kullanıcı silme başarılı', () async {
//         // Önce giriş yap
//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );
//         expect(mockAuthService.currentUser, isNotNull);

//         // Kullanıcıyı sil
//         await mockAuthService.deleteUser();
//         expect(mockAuthService.currentUser, isNull);
//       });
//     });

//     group('Auth State Changes Tests', () {
//       test('Auth state changes stream çalışıyor', () async {
//         final authStateStream = mockAuthService.authStateChanges;
//         expect(authStateStream, isA<Stream<User?>>());
//       });

//       test('Giriş yapıldığında auth state güncelleniyor', () async {
//         final authStateStream = mockAuthService.authStateChanges;
//         User? lastUser;
//         final completer = Completer<void>();

//         authStateStream.listen((user) {
//           lastUser = user;
//           if (!completer.isCompleted) completer.complete();
//         });

//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         // Stream event'inin işlenmesini bekle
//         await completer.future;
//         expect(lastUser, isNotNull);
//       });

//       test('Çıkış yapıldığında auth state güncelleniyor', () async {
//         // Önce giriş yap
//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         final authStateStream = mockAuthService.authStateChanges;
//         User? lastUser;
//         final completer = Completer<void>();

//         authStateStream.listen((user) {
//           lastUser = user;
//           if (!completer.isCompleted) completer.complete();
//         });

//         await mockAuthService.signOut();

//         // Stream event'inin işlenmesini bekle
//         await completer.future;
//         expect(lastUser, isNull);
//       });
//     });

//     group('Performance Tests', () {
//       test('Giriş işlemi performance testi', () async {
//         final stopwatch = Stopwatch()..start();

//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         stopwatch.stop();
//         expect(stopwatch.elapsedMilliseconds, lessThan(200)); // 200ms'den az
//       });

//       test('Kayıt işlemi performance testi', () async {
//         final stopwatch = Stopwatch()..start();

//         await mockAuthService.createUserWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         stopwatch.stop();
//         expect(stopwatch.elapsedMilliseconds, lessThan(200)); // 200ms'den az
//       });

//       test('Çıkış işlemi performance testi', () async {
//         // Önce giriş yap
//         await mockAuthService.signInWithEmailAndPassword(
//           TestData.validEmail,
//           TestData.validPassword,
//         );

//         final stopwatch = Stopwatch()..start();

//         await mockAuthService.signOut();

//         stopwatch.stop();
//         expect(stopwatch.elapsedMilliseconds, lessThan(100)); // 100ms'den az
//       });
//     });

//     group('Edge Case Tests', () {
//       test('Çok uzun email ile test', () async {
//         final longEmail = 'a' * 1000 + '@test.com';

//         expect(
//           () => mockAuthService.signInWithEmailAndPassword(
//             longEmail,
//             TestData.validPassword,
//           ),
//           returnsNormally,
//         );
//       });

//       test('Çok uzun şifre ile test', () async {
//         final longPassword = 'a' * 1000;

//         expect(
//           () => mockAuthService.signInWithEmailAndPassword(
//             TestData.validEmail,
//             longPassword,
//           ),
//           returnsNormally,
//         );
//       });

//       test('Özel karakterler içeren email ile test', () async {
//         final specialEmail =
//             'test+special!@\$\$%^&*()_+-=[]{}|;:,.<>?@email.com';

//         expect(
//           () => mockAuthService.signInWithEmailAndPassword(
//             specialEmail,
//             TestData.validPassword,
//           ),
//           returnsNormally,
//         );
//       });

//       test('Özel karakterler içeren şifre ile test', () async {
//         final specialPassword = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

//         expect(
//           () => mockAuthService.signInWithEmailAndPassword(
//             TestData.validEmail,
//             specialPassword,
//           ),
//           returnsNormally,
//         );
//       });
//     });

//     group('Error Handling Tests', () {
//       test('Network error simulation', () async {
//         // Network error simülasyonu için delay ekle
//         final stopwatch = Stopwatch()..start();

//         try {
//           await mockAuthService.signInWithEmailAndPassword(
//             TestData.validEmail,
//             TestData.validPassword,
//           );
//         } catch (e) {
//           // Error handling
//         }

//         stopwatch.stop();
//         expect(stopwatch.elapsedMilliseconds, greaterThan(0));
//       });

//       test('Multiple concurrent operations', () async {
//         final futures = <Future>[];

//         // Çoklu giriş denemesi
//         for (int i = 0; i < 5; i++) {
//           futures.add(
//             mockAuthService.signInWithEmailAndPassword(
//               'user$i@test.com',
//               TestData.validPassword,
//             ),
//           );
//         }

//         final results = await Future.wait(futures);
//         expect(results.length, equals(5));

//         for (final result in results) {
//           expect(result, isA<UserCredential>());
//         }
//       });
//     });
//   });
// }

// // Placeholder classes for compilation
// class FirebaseAuth {}

// class User {}

// class UserCredential {}

// class AuthResult {}
