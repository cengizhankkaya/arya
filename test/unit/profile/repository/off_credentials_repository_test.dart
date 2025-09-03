import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
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

      test(
        'should clear and return null when credentials are invalid',
        () async {
          // Arrange
          const invalidCredentials = OffCredentialsModel(
            username: 'ab', // Too short
            password: 'TestPass123!',
          );
          when(
            mockService.getCredentials(),
          ).thenAnswer((_) async => invalidCredentials);
          when(mockService.clearCredentials()).thenAnswer((_) async => true);

          // Act
          final result = await repository.getCredentials();

          // Assert
          expect(result, isNull);
          verify(mockService.getCredentials()).called(1);
          verify(mockService.clearCredentials()).called(1);
        },
      );

      test(
        'should clear and return null when credentials are corrupted',
        () async {
          // Arrange
          const corruptedCredentials = OffCredentialsModel(
            username: '', // Empty username
            password: 'TestPass123!',
          );
          when(
            mockService.getCredentials(),
          ).thenAnswer((_) async => corruptedCredentials);
          when(mockService.clearCredentials()).thenAnswer((_) async => true);

          // Act
          final result = await repository.getCredentials();

          // Assert
          expect(result, isNull);
          verify(mockService.getCredentials()).called(1);
          verify(mockService.clearCredentials()).called(1);
        },
      );

      test('should rethrow service error', () async {
        // Arrange
        when(
          mockService.getCredentials(),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(() => repository.getCredentials(), throwsA(isA<Exception>()));
        verify(mockService.getCredentials()).called(1);
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
        const invalidCredentials = OffCredentialsModel(
          username: 'test-user', // Contains hyphen
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception for username too short', () async {
        // Arrange
        const invalidCredentials = OffCredentialsModel(
          username: 'ab', // Too short
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception for username too long', () async {
        // Arrange
        final longUsername = 'a' * 51; // Too long
        final invalidCredentials = OffCredentialsModel(
          username: longUsername,
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception for password too short', () async {
        // Arrange
        const invalidCredentials = OffCredentialsModel(
          username: 'testuser',
          password: 'Test1!', // Too short
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception for password too long', () async {
        // Arrange
        final longPassword = 'Test1!' + 'a' * 123; // Too long
        final invalidCredentials = OffCredentialsModel(
          username: 'testuser',
          password: longPassword,
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception when username equals password', () async {
        // Arrange
        const invalidCredentials = OffCredentialsModel(
          username: 'testuser',
          password: 'testuser', // Same as username
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception when password contains username', () async {
        // Arrange
        const invalidCredentials = OffCredentialsModel(
          username: 'test',
          password: 'TestPass123!', // Contains 'test'
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception for weak password (no uppercase)', () async {
        // Arrange
        const invalidCredentials = OffCredentialsModel(
          username: 'testuser',
          password: 'testpass123!', // No uppercase
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception for weak password (no lowercase)', () async {
        // Arrange
        const invalidCredentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TESTPASS123!', // No lowercase
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception for weak password (no number)', () async {
        // Arrange
        const invalidCredentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass!', // No number
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(invalidCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test(
        'should throw exception for weak password (no special character)',
        () async {
          // Arrange
          const invalidCredentials = OffCredentialsModel(
            username: 'testuser',
            password: 'TestPass123', // No special character
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(invalidCredentials),
            throwsA(isA<Exception>()),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );

      test('should rethrow service error', () async {
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
        verify(mockService.saveCredentials(credentials)).called(1);
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

      test('should rethrow service error', () async {
        // Arrange
        when(
          mockService.clearCredentials(),
        ).thenThrow(Exception('Service error'));

        // Act & Assert
        expect(() => repository.clearCredentials(), throwsA(isA<Exception>()));
        verify(mockService.clearCredentials()).called(1);
      });
    });

    group('Edge Cases Tests', () {
      test('should handle empty credentials', () async {
        // Arrange
        final emptyCredentials = OffCredentialsModel.empty();

        // Act & Assert
        expect(
          () => repository.saveCredentials(emptyCredentials),
          throwsA(isA<Exception>()),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should handle credentials with minimum valid length', () async {
        // Arrange
        final minValidCredentials = OffCredentialsModel(
          username: 'abc', // Minimum length
          password:
              'Test1!xy', // Minimum length with all requirements: uppercase, lowercase, number, special char
        );
        when(
          mockService.saveCredentials(minValidCredentials),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.saveCredentials(minValidCredentials);

        // Assert
        expect(result, isTrue);
        verify(mockService.saveCredentials(minValidCredentials)).called(1);
      });

      test('should handle credentials with maximum valid length', () async {
        // Arrange
        final maxUsername =
            'b' * 50; // Maximum length, 'a' yerine 'b' kullanıyoruz
        final maxPassword =
            'Test1!' +
            'x' * 100 +
            'B' +
            'c' +
            '2' +
            '#'; // 'a' yerine 'x' kullanıyoruz
        final maxValidCredentials = OffCredentialsModel(
          username: maxUsername,
          password: maxPassword,
        );

        // Debug: şifre uzunluğunu ve içeriğini kontrol et
        print('Password length: ${maxPassword.length}');
        print('Password: $maxPassword');
        print('Username: $maxUsername');

        when(
          mockService.saveCredentials(maxValidCredentials),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.saveCredentials(maxValidCredentials);

        // Assert
        expect(result, isTrue);
        verify(mockService.saveCredentials(maxValidCredentials)).called(1);
      });

      test(
        'should handle case-insensitive username password comparison',
        () async {
          // Arrange
          const invalidCredentials = OffCredentialsModel(
            username: 'TestUser',
            password: 'testuser', // Lowercase version of username
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(invalidCredentials),
            throwsA(isA<Exception>()),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );

      test(
        'should handle case-insensitive password contains username check',
        () async {
          // Arrange
          const invalidCredentials = OffCredentialsModel(
            username: 'Test',
            password: 'MyTestPass123!', // Contains 'test' (case-insensitive)
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(invalidCredentials),
            throwsA(isA<Exception>()),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );
    });

    group('Validation Tests', () {
      test(
        'should accept valid username with numbers and underscores',
        () async {
          // Arrange
          const validCredentials = OffCredentialsModel(
            username: 'user_123',
            password: 'TestPass123!',
          );
          when(
            mockService.saveCredentials(validCredentials),
          ).thenAnswer((_) async => true);

          // Act
          final result = await repository.saveCredentials(validCredentials);

          // Assert
          expect(result, isTrue);
          verify(mockService.saveCredentials(validCredentials)).called(1);
        },
      );

      test(
        'should accept valid password with various special characters',
        () async {
          // Arrange
          const validCredentials = OffCredentialsModel(
            username: 'testuser',
            password: 'Test!Pass123', // Using allowed special character: !
          );
          when(
            mockService.saveCredentials(validCredentials),
          ).thenAnswer((_) async => true);

          // Act
          final result = await repository.saveCredentials(validCredentials);

          // Assert
          expect(result, isTrue);
          verify(mockService.saveCredentials(validCredentials)).called(1);
        },
      );
    });
  });
}
