import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:arya/features/profile/repository/off_credentials_repository.dart';
import 'package:arya/features/profile/service/off_credentials_service.dart';
import 'package:arya/features/profile/model/off_credentials_model.dart';

@GenerateMocks([IOffCredentialsService])
import 'off_credentials_repository_test.mocks.dart';

void main() {
  group('OffCredentialsRepository Tests', () {
    late OffCredentialsRepository repository;
    late MockIOffCredentialsService mockService;

    setUp(() {
      mockService = MockIOffCredentialsService();
      repository = OffCredentialsRepository(service: mockService);
    });

    group('getCredentials Tests', () {
      test(
        'should return credentials when service returns valid data',
        () async {
          // Arrange
          const credentials = OffCredentialsModel(
            username: 'testuser',
            password: 'TestPass123!',
          );

          when(
            mockService.getCredentials(),
          ).thenAnswer((_) async => credentials);

          // Act
          final result = await repository.getCredentials();

          // Assert
          expect(result, equals(credentials));
          verify(mockService.getCredentials()).called(1);
        },
      );

      test('should return null when service returns null', () async {
        // Arrange
        when(mockService.getCredentials()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCredentials();

        // Assert
        expect(result, isNull);
        verify(mockService.getCredentials()).called(1);
      });

      test('should clear corrupted credentials and return null', () async {
        // Arrange
        const corruptedCredentials = OffCredentialsModel(
          username: 'ab', // Too short
          password: 'weak', // Too short
        );

        when(
          mockService.getCredentials(),
        ).thenAnswer((_) async => corruptedCredentials);
        when(mockService.clearCredentials()).thenAnswer((_) async => true);

        // Act
        final result = await repository.getCredentials();

        // Assert
        expect(result, isNull);
        verify(mockService.clearCredentials()).called(1);
      });

      test('should rethrow service exceptions', () async {
        // Arrange
        when(
          mockService.getCredentials(),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(() => repository.getCredentials(), throwsA(isA<Exception>()));
      });

      test('should handle service errors gracefully', () async {
        // Arrange
        when(
          mockService.getCredentials(),
        ).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => repository.getCredentials(), throwsA(isA<Exception>()));
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
          mockService.saveCredentials(credentials),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.saveCredentials(credentials);

        // Assert
        expect(result, isTrue);
        verify(mockService.saveCredentials(credentials)).called(1);
      });

      test('should throw exception for invalid username format', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'user@name', // Invalid characters
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
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
          () => repository.saveCredentials(credentials),
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
          () => repository.saveCredentials(credentials),
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
          () => repository.saveCredentials(credentials),
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
          () => repository.saveCredentials(credentials),
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
          () => repository.saveCredentials(credentials),
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
          () => repository.saveCredentials(credentials),
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
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should rethrow service exceptions', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        when(
          mockService.saveCredentials(credentials),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('clearCredentials Tests', () {
      test('should clear credentials successfully', () async {
        // Arrange
        when(mockService.clearCredentials()).thenAnswer((_) async => true);

        // Act
        final result = await repository.clearCredentials();

        // Assert
        expect(result, isTrue);
        verify(mockService.clearCredentials()).called(1);
      });

      test('should rethrow service exceptions', () async {
        // Arrange
        when(
          mockService.clearCredentials(),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(() => repository.clearCredentials(), throwsA(isA<Exception>()));
      });
    });

    group('Repository Level Validation Tests', () {
      test('should validate credentials at repository level', () async {
        // Arrange
        const validCredentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        when(
          mockService.saveCredentials(validCredentials),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.saveCredentials(validCredentials);

        // Assert
        expect(result, isTrue);
      });

      test('should reject empty username at repository level', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: '',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should reject empty password at repository level', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: '',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should validate username format at repository level', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'user name', // Contains space
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should validate password strength at repository level', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'weakpass', // Weak password
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Password Strength Validation Tests', () {
      test('should accept strong passwords at repository level', () async {
        // Arrange
        const strongPasswords = [
          'TestPass123!',
          'StrongP@ss1',
          'Complex123!@#',
          'SecureP@ss1',
        ];

        when(mockService.saveCredentials(any)).thenAnswer((_) async => true);

        // Act & Assert
        for (final password in strongPasswords) {
          final credentials = OffCredentialsModel(
            username: 'testuser',
            password: password,
          );

          final result = await repository.saveCredentials(credentials);
          expect(result, isTrue);
        }
      });

      test('should reject weak passwords at repository level', () async {
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
            () => repository.saveCredentials(credentials),
            throwsA(isA<Exception>()),
          );
        }
      });

      test('should validate special characters at repository level', () async {
        // Arrange
        const validSpecialChars = [
          'Test123!',
          'Test123@',
          'Test123#',
          'Test123\$',
          'Test123%',
          'Test123^',
          'Test123&',
          'Test123*',
          'Test123(',
          'Test123)',
          'Test123_',
          'Test123+',
          'Test123-',
          'Test123=',
          'Test123[',
          'Test123]',
          'Test123{',
          'Test123}',
          'Test123:',
          'Test123;',
          'Test123<',
          'Test123>',
          'Test123,',
          'Test123.',
          'Test123?',
        ];

        when(mockService.saveCredentials(any)).thenAnswer((_) async => true);

        // Act & Assert
        for (final password in validSpecialChars) {
          final credentials = OffCredentialsModel(
            username: 'testuser',
            password: password,
          );

          final result = await repository.saveCredentials(credentials);
          expect(result, isTrue);
        }
      });
    });

    group('Edge Cases Tests', () {
      test('should handle null credentials gracefully', () async {
        // Arrange
        when(mockService.getCredentials()).thenAnswer((_) async => null);

        // Act
        final result = await repository.getCredentials();

        // Assert
        expect(result, isNull);
      });

      test('should handle whitespace-only credentials', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: '   ',
          password: '   ',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle unicode characters in username', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'üser123',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle very long valid credentials', () async {
        // Arrange
        final credentials = OffCredentialsModel(
          username: 'b' * 50, // Maximum length
          password: 'TestPass123!' + 'A' * 115, // Maximum length with uppercase
        );

        when(
          mockService.saveCredentials(credentials),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.saveCredentials(credentials);

        // Assert
        expect(result, isTrue);
      });

      test('should handle minimum length credentials', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'abc', // Minimum length
          password: 'Test1!Ab', // Minimum length (8 characters)
        );

        when(
          mockService.saveCredentials(credentials),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.saveCredentials(credentials);

        // Assert
        expect(result, isTrue);
      });
    });

    group('Integration Tests', () {
      test('should handle complete workflow successfully', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        when(
          mockService.saveCredentials(credentials),
        ).thenAnswer((_) async => true);
        when(mockService.getCredentials()).thenAnswer((_) async => credentials);
        when(mockService.clearCredentials()).thenAnswer((_) async => true);

        // Act - Complete workflow
        final saveResult = await repository.saveCredentials(credentials);
        final getResult = await repository.getCredentials();
        final clearResult = await repository.clearCredentials();

        // Assert
        expect(saveResult, isTrue);
        expect(getResult, equals(credentials));
        expect(clearResult, isTrue);

        verify(mockService.saveCredentials(credentials)).called(1);
        verify(mockService.getCredentials()).called(1);
        verify(mockService.clearCredentials()).called(1);
      });

      test('should handle service failure gracefully', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        when(
          mockService.saveCredentials(credentials),
        ).thenThrow(Exception('Service failure'));

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
