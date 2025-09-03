import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:arya/features/profile/repository/off_credentials_repository.dart';
import 'package:arya/features/profile/service/off_credentials_service.dart';
import 'package:arya/features/profile/model/off_credentials_model.dart';

import 'off_credentials_repository_test.mocks.dart';

@GenerateMocks([IOffCredentialsService])
void main() {
  group('OffCredentialsRepository', () {
    late OffCredentialsRepository repository;
    late MockIOffCredentialsService mockService;

    setUp(() {
      mockService = MockIOffCredentialsService();
      repository = OffCredentialsRepository(service: mockService);
    });

    tearDown(() {
      reset(mockService);
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
          expect(result, isNotNull);
          expect(result!.username, 'testuser');
          expect(result.password, 'TestPass123!');
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
        'should clear and return null when service returns corrupted data',
        () async {
          // Arrange
          const corruptedCredentials = OffCredentialsModel(
            username: 'te', // Çok kısa username
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

      test(
        'should clear and return null when service returns invalid format data',
        () async {
          // Arrange
          const invalidCredentials = OffCredentialsModel(
            username: 'test@user', // @ karakteri içeren username
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

      test('should throw exception when service throws', () async {
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
      test('should save credentials when validation passes', () async {
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

      test('should throw exception when username is empty', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: '',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Invalid credentials format at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception when password is empty', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: '',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Invalid credentials format at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception when username is too short', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'te',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Invalid credentials format at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception when username is too long', () async {
        // Arrange
        final longUsername = 'a' * 51; // 51 karakter
        final credentials = OffCredentialsModel(
          username: longUsername,
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Invalid credentials format at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception when password is too short', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'Test123',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Invalid credentials format at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test('should throw exception when password is too long', () async {
        // Arrange
        final longPassword = 'TestPass123!' + 'a' * 129; // 129 karakter
        final credentials = OffCredentialsModel(
          username: 'testuser',
          password: longPassword,
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Invalid credentials format at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test(
        'should throw exception when username contains invalid characters',
        () async {
          // Arrange
          const credentials = OffCredentialsModel(
            username: 'test@user',
            password: 'TestPass123!',
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(credentials),
            throwsA(
              predicate(
                (e) => e.toString().contains(
                  'Invalid credentials format at repository level',
                ),
              ),
            ),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );

      test(
        'should throw exception when username and password are identical',
        () async {
          // Arrange
          const credentials = OffCredentialsModel(
            username: 'testuser',
            password: 'testuser',
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(credentials),
            throwsA(
              predicate(
                (e) => e.toString().contains(
                  'Credentials security requirements not met at repository level',
                ),
              ),
            ),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );

      test(
        'should throw exception when username is contained in password',
        () async {
          // Arrange
          const credentials = OffCredentialsModel(
            username: 'test',
            password: 'MyTestPass123!',
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(credentials),
            throwsA(
              predicate(
                (e) => e.toString().contains(
                  'Credentials security requirements not met at repository level',
                ),
              ),
            ),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );

      test(
        'should throw exception when password is weak (no uppercase)',
        () async {
          // Arrange
          const credentials = OffCredentialsModel(
            username: 'testuser',
            password: 'testpass123!',
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(credentials),
            throwsA(
              predicate(
                (e) => e.toString().contains(
                  'Credentials security requirements not met at repository level',
                ),
              ),
            ),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );

      test(
        'should throw exception when password is weak (no lowercase)',
        () async {
          // Arrange
          const credentials = OffCredentialsModel(
            username: 'testuser',
            password: 'TESTPASS123!',
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(credentials),
            throwsA(
              predicate(
                (e) => e.toString().contains(
                  'Credentials security requirements not met at repository level',
                ),
              ),
            ),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );

      test('should throw exception when password is weak (no numbers)', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Credentials security requirements not met at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
      });

      test(
        'should throw exception when password is weak (no special chars)',
        () async {
          // Arrange
          const credentials = OffCredentialsModel(
            username: 'testuser',
            password: 'TestPass123',
          );

          // Act & Assert
          expect(
            () => repository.saveCredentials(credentials),
            throwsA(
              predicate(
                (e) => e.toString().contains(
                  'Credentials security requirements not met at repository level',
                ),
              ),
            ),
          );
          verifyNever(mockService.saveCredentials(any));
        },
      );

      test('should throw exception when service throws', () async {
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

      test('should throw exception when service throws', () async {
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
      test('should handle minimum valid credentials', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'abc',
          password: 'Test123!',
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

      test('should handle maximum valid credentials', () async {
        // Arrange
        final longUsername = 'test' + 'b' * 46; // Tam 50 karakter
        final longPassword = 'TestPass123!' + 'c' * 115; // Tam 128 karakter
        final credentials = OffCredentialsModel(
          username: longUsername,
          password: longPassword,
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

      test('should handle case-insensitive username in password check', () async {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'TEST',
          password: 'MyTestPass123!',
        );

        // Act & Assert
        expect(
          () => repository.saveCredentials(credentials),
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Credentials security requirements not met at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
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
          throwsA(
            predicate(
              (e) => e.toString().contains(
                'Invalid credentials format at repository level',
              ),
            ),
          ),
        );
        verifyNever(mockService.saveCredentials(any));
      });
    });

    group('Integration Tests', () {
      test('should handle complete workflow: save -> get -> clear', () async {
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

        // Act - Save
        final saveResult = await repository.saveCredentials(credentials);
        expect(saveResult, isTrue);

        // Act - Get
        final getResult = await repository.getCredentials();
        expect(getResult, isNotNull);
        expect(getResult!.username, 'testuser');
        expect(getResult.password, 'TestPass123!');

        // Act - Clear
        final clearResult = await repository.clearCredentials();
        expect(clearResult, isTrue);

        // Assert
        verify(mockService.saveCredentials(credentials)).called(1);
        verify(mockService.getCredentials()).called(1);
        verify(mockService.clearCredentials()).called(1);
      });
    });
  });
}
