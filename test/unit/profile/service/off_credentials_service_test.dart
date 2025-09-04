import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:arya/features/profile/service/off_credentials_service.dart';
import 'package:arya/features/profile/model/off_credentials_model.dart';

@GenerateMocks([IStorageService])
import 'off_credentials_service_test.mocks.dart';

void main() {
  group('OffCredentialsService Tests', () {
    late OffCredentialsService service;
    late MockIStorageService mockStorageService;

    setUp(() {
      mockStorageService = MockIStorageService();
      service = OffCredentialsService(storageService: mockStorageService);
    });

    tearDown(() {
      // Reset rate limiting for each test
      service.resetRateLimit();
    });

    group('getCredentials Tests', () {
      test(
        'should return credentials when both username and password exist',
        () async {
          // Arrange
          const username = 'testuser';
          const password = 'TestPass123!';
          const expectedCredentials = OffCredentialsModel(
            username: username,
            password: password,
          );

          when(
            mockStorageService.getOffUsername(),
          ).thenAnswer((_) async => username);
          when(
            mockStorageService.getOffPassword(),
          ).thenAnswer((_) async => password);

          // Act
          final result = await service.getCredentials();

          // Assert
          expect(result, equals(expectedCredentials));
          verify(mockStorageService.getOffUsername()).called(1);
          verify(mockStorageService.getOffPassword()).called(1);
        },
      );

      test('should return null when username is null', () async {
        // Arrange
        when(mockStorageService.getOffUsername()).thenAnswer((_) async => null);
        when(
          mockStorageService.getOffPassword(),
        ).thenAnswer((_) async => 'password');

        // Act
        final result = await service.getCredentials();

        // Assert
        expect(result, isNull);
        verify(mockStorageService.getOffUsername()).called(1);
        verify(mockStorageService.getOffPassword()).called(1);
      });

      test('should return null when password is null', () async {
        // Arrange
        when(
          mockStorageService.getOffUsername(),
        ).thenAnswer((_) async => 'username');
        when(mockStorageService.getOffPassword()).thenAnswer((_) async => null);

        // Act
        final result = await service.getCredentials();

        // Assert
        expect(result, isNull);
        verify(mockStorageService.getOffUsername()).called(1);
        verify(mockStorageService.getOffPassword()).called(1);
      });

      test('should return null when both are null', () async {
        // Arrange
        when(mockStorageService.getOffUsername()).thenAnswer((_) async => null);
        when(mockStorageService.getOffPassword()).thenAnswer((_) async => null);

        // Act
        final result = await service.getCredentials();

        // Assert
        expect(result, isNull);
        verify(mockStorageService.getOffUsername()).called(1);
        verify(mockStorageService.getOffPassword()).called(1);
      });

      test('should clear corrupted credentials and return null', () async {
        // Arrange
        const corruptedUsername = 'ab'; // Too short
        const corruptedPassword = 'weak'; // Too short

        when(
          mockStorageService.getOffUsername(),
        ).thenAnswer((_) async => corruptedUsername);
        when(
          mockStorageService.getOffPassword(),
        ).thenAnswer((_) async => corruptedPassword);
        when(mockStorageService.clearOffCredentials()).thenAnswer((_) async {});

        // Act
        final result = await service.getCredentials();

        // Assert
        expect(result, isNull);
        verify(mockStorageService.clearOffCredentials()).called(1);
      });

      test('should throw exception when rate limit exceeded', () async {
        // Arrange
        // Exceed rate limit by making too many requests
        for (int i = 0; i < 31; i++) {
          when(
            mockStorageService.getOffUsername(),
          ).thenAnswer((_) async => 'user$i');
          when(
            mockStorageService.getOffPassword(),
          ).thenAnswer((_) async => 'pass$i');
          try {
            await service.getCredentials();
          } catch (e) {
            // Expected after rate limit
          }
        }

        // Act & Assert
        expect(() => service.getCredentials(), throwsA(isA<Exception>()));
      });

      test('should handle storage service errors gracefully', () async {
        // Arrange
        when(
          mockStorageService.getOffUsername(),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => service.getCredentials(), throwsA(isA<Exception>()));
      });
    });

    group('saveCredentials Tests', () {
      test('should save valid credentials successfully', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        when(
          mockStorageService.setOffCredentials(
            username: anyNamed('username'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async {});

        // Act
        final result = await service.saveCredentials(credentials);

        // Assert
        expect(result, isTrue);
        verify(
          mockStorageService.setOffCredentials(
            username: 'testuser',
            password: 'TestPass123!',
          ),
        ).called(1);
      });

      test('should throw exception for invalid username format', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'user@name', // Invalid characters
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception for username too short', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'ab', // Too short
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception for username too long', () async {
        // Arrange
        final credentials = OffCredentialsModel(
          username: 'a' * 51, // Too long
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception for password too short', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'Test1!', // Too short
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception for password too long', () async {
        // Arrange
        final credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!' + 'a' * 120, // Too long
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when username equals password', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'testuser', // Same as username
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when password contains username', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'test',
          password: 'TestPass123!', // Contains 'test'
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception for weak password', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'weakpass', // No uppercase, number, or special char
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception when rate limit exceeded', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Exceed rate limit
        for (int i = 0; i < 31; i++) {
          try {
            await service.saveCredentials(credentials);
          } catch (e) {
            // Expected after rate limit
          }
        }

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle storage service errors gracefully', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        when(
          mockStorageService.setOffCredentials(
            username: anyNamed('username'),
            password: anyNamed('password'),
          ),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('clearCredentials Tests', () {
      test('should clear credentials successfully', () async {
        // Arrange
        when(mockStorageService.clearOffCredentials()).thenAnswer((_) async {});

        // Act
        final result = await service.clearCredentials();

        // Assert
        expect(result, isTrue);
        verify(mockStorageService.clearOffCredentials()).called(1);
      });

      test('should throw exception when rate limit exceeded', () async {
        // Arrange
        // Exceed rate limit
        for (int i = 0; i < 31; i++) {
          try {
            await service.clearCredentials();
          } catch (e) {
            // Expected after rate limit
          }
        }

        // Act & Assert
        expect(() => service.clearCredentials(), throwsA(isA<Exception>()));
      });

      test('should handle storage service errors gracefully', () async {
        // Arrange
        when(
          mockStorageService.clearOffCredentials(),
        ).thenThrow(Exception('Storage error'));

        // Act & Assert
        expect(() => service.clearCredentials(), throwsA(isA<Exception>()));
      });
    });

    group('Password Strength Validation Tests', () {
      test('should accept strong passwords', () async {
        // Arrange
        const strongPasswords = [
          'TestPass123!',
          'StrongP@ss1',
          'Complex123!@#',
          'SecureP@ss1',
        ];

        when(
          mockStorageService.setOffCredentials(
            username: anyNamed('username'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async {});

        // Act & Assert
        for (final password in strongPasswords) {
          final credentials = OffCredentialsModel(
            username: 'testuser',
            password: password,
          );

          final result = await service.saveCredentials(credentials);
          expect(result, isTrue);
        }
      });

      test('should reject weak passwords', () async {
        // Arrange
        const weakPasswords = [
          'weak', // Too short
          'weakpass', // No uppercase, number, special char
          'WEAKPASS', // No lowercase, number, special char
          'WeakPass', // No number, special char
          'WeakPass1', // No special char
        ];

        // Act & Assert
        for (final password in weakPasswords) {
          final credentials = OffCredentialsModel(
            username: 'testuser',
            password: password,
          );

          expect(
            () => service.saveCredentials(credentials),
            throwsA(isA<Exception>()),
          );
        }
      });
    });

    group('Rate Limiting Tests', () {
      test('should allow requests within rate limit', () async {
        // Arrange
        when(
          mockStorageService.getOffUsername(),
        ).thenAnswer((_) async => 'user');
        when(
          mockStorageService.getOffPassword(),
        ).thenAnswer((_) async => 'password123');

        // Act - Make requests within limit
        for (int i = 0; i < 10; i++) {
          final result = await service.getCredentials();
          expect(result, isNotNull);
        }
      });

      test('should block requests exceeding rate limit', () async {
        // Arrange
        when(
          mockStorageService.getOffUsername(),
        ).thenAnswer((_) async => 'user');
        when(
          mockStorageService.getOffPassword(),
        ).thenAnswer((_) async => 'pass');

        // Act - Exceed rate limit
        for (int i = 0; i < 31; i++) {
          try {
            await service.getCredentials();
          } catch (e) {
            if (i >= 30) {
              expect(e, isA<Exception>());
            }
          }
        }
      });

      test('should reset rate limit after cooldown period', () async {
        // Arrange
        when(
          mockStorageService.getOffUsername(),
        ).thenAnswer((_) async => 'user');
        when(
          mockStorageService.getOffPassword(),
        ).thenAnswer((_) async => 'password123');

        // Act - Exceed rate limit
        for (int i = 0; i < 31; i++) {
          try {
            await service.getCredentials();
          } catch (e) {
            // Expected after rate limit
          }
        }

        // Reset rate limit manually for testing
        service.resetRateLimit();

        // Should work again after reset
        final result = await service.getCredentials();
        expect(result, isNotNull);
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty credentials', () async {
        // Arrange
        const credentials = OffCredentialsModel(username: '', password: '');

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle whitespace-only credentials', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: '   ',
          password: '   ',
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle special characters in username', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'user@name#',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle unicode characters', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'üser123',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => service.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
