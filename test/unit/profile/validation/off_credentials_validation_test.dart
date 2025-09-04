import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/model/off_credentials_model.dart';

/// OffCredentials validation utility class for testing
class OffCredentialsValidation {
  static bool validateCredentials(OffCredentialsModel credentials) {
    if (credentials.username.isEmpty || credentials.password.isEmpty) {
      return false;
    }

    // Username uzunluk kontrolü
    if (credentials.username.length < 3 || credentials.username.length > 50) {
      return false;
    }

    // Password uzunluk kontrolü
    if (credentials.password.length < 8 || credentials.password.length > 128) {
      return false;
    }

    // Username format kontrolü
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(credentials.username)) {
      return false;
    }

    return true;
  }

  static bool isSecureCredentials(OffCredentialsModel credentials) {
    // Username ve password aynı olamaz
    if (credentials.username.toLowerCase() ==
        credentials.password.toLowerCase()) {
      return false;
    }

    // Username password içinde geçemez
    if (credentials.password.toLowerCase().contains(
      credentials.username.toLowerCase(),
    )) {
      return false;
    }

    // Güçlü şifre kontrolü
    if (!isStrongPassword(credentials.password)) {
      return false;
    }

    return true;
  }

  static bool isStrongPassword(String password) {
    // En az 8 karakter
    if (password.length < 8) return false;

    // En az bir büyük harf
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;

    // En az bir küçük harf
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;

    // En az bir rakam
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;

    // En az bir özel karakter
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>;]').hasMatch(password)) return false;

    return true;
  }

  static bool validateRepositoryLevel(OffCredentialsModel credentials) {
    // Null kontrolü
    if (credentials.username.isEmpty || credentials.password.isEmpty) {
      return false;
    }

    // Uzunluk kontrolü
    if (credentials.username.length < 3 ||
        credentials.username.length > 50 ||
        credentials.password.length < 8 ||
        credentials.password.length > 128) {
      return false;
    }

    // Format kontrolü
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(credentials.username)) {
      return false;
    }

    return true;
  }

  static bool isRepositoryLevelSecure(OffCredentialsModel credentials) {
    // Username ve password aynı olamaz
    if (credentials.username.toLowerCase() ==
        credentials.password.toLowerCase()) {
      return false;
    }

    // Username password içinde geçemez
    if (credentials.password.toLowerCase().contains(
      credentials.username.toLowerCase(),
    )) {
      return false;
    }

    // Güçlü şifre kontrolü
    if (!isStrongPassword(credentials.password)) {
      return false;
    }

    return true;
  }
}

void main() {
  group('OffCredentials Validation Tests', () {
    group('validateCredentials Tests', () {
      test('should return true for valid credentials', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should return false for empty username', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: '',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for empty password', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: '',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for username too short', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'ab',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for username too long', () {
        // Arrange
        final credentials = OffCredentialsModel(
          username: 'a' * 51,
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for password too short', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'Test1!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for password too long', () {
        // Arrange
        final credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!' + 'a' * 120,
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for invalid username characters', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'user@name',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return true for valid username with underscore', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'user_name',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should return true for valid username with numbers', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'user123',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });
    });

    group('isSecureCredentials Tests', () {
      test('should return true for secure credentials', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'SecurePass123!',
        );

        // Act
        final result = OffCredentialsValidation.isSecureCredentials(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should return false when username equals password', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'testuser',
        );

        // Act
        final result = OffCredentialsValidation.isSecureCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false when password contains username', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'test',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.isSecureCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for weak password', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'weakpass',
        );

        // Act
        final result = OffCredentialsValidation.isSecureCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should handle case insensitive username comparison', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'TestUser',
          password: 'testuser',
        );

        // Act
        final result = OffCredentialsValidation.isSecureCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should handle case insensitive password contains username', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'Test',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.isSecureCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('isStrongPassword Tests', () {
      test('should return true for strong passwords', () {
        // Arrange
        const strongPasswords = [
          'TestPass123!',
          'StrongP@ss1',
          'Complex123!@#',
          'SecureP@ss1',
          'MyP@ssw0rd!',
        ];

        // Act & Assert
        for (final password in strongPasswords) {
          final result = OffCredentialsValidation.isStrongPassword(password);
          expect(
            result,
            isTrue,
            reason: 'Password "$password" should be strong',
          );
        }
      });

      test('should return false for passwords too short', () {
        // Arrange
        const shortPasswords = ['Test1!', 'Pass1', 'Abc1', 'Test'];

        // Act & Assert
        for (final password in shortPasswords) {
          final result = OffCredentialsValidation.isStrongPassword(password);
          expect(
            result,
            isFalse,
            reason: 'Password "$password" should be too short',
          );
        }
      });

      test('should return false for passwords without uppercase', () {
        // Arrange
        const noUppercasePasswords = [
          'testpass123!',
          'mypassword1@',
          'weakpass123#',
        ];

        // Act & Assert
        for (final password in noUppercasePasswords) {
          final result = OffCredentialsValidation.isStrongPassword(password);
          expect(
            result,
            isFalse,
            reason: 'Password "$password" should lack uppercase',
          );
        }
      });

      test('should return false for passwords without lowercase', () {
        // Arrange
        const noLowercasePasswords = [
          'TESTPASS123!',
          'MYPASSWORD1@',
          'WEAKPASS123#',
        ];

        // Act & Assert
        for (final password in noLowercasePasswords) {
          final result = OffCredentialsValidation.isStrongPassword(password);
          expect(
            result,
            isFalse,
            reason: 'Password "$password" should lack lowercase',
          );
        }
      });

      test('should return false for passwords without numbers', () {
        // Arrange
        const noNumberPasswords = ['TestPass!', 'MyPassword@', 'WeakPass#'];

        // Act & Assert
        for (final password in noNumberPasswords) {
          final result = OffCredentialsValidation.isStrongPassword(password);
          expect(
            result,
            isFalse,
            reason: 'Password "$password" should lack numbers',
          );
        }
      });

      test('should return false for passwords without special characters', () {
        // Arrange
        const noSpecialCharPasswords = [
          'TestPass123',
          'MyPassword1',
          'WeakPass123',
        ];

        // Act & Assert
        for (final password in noSpecialCharPasswords) {
          final result = OffCredentialsValidation.isStrongPassword(password);
          expect(
            result,
            isFalse,
            reason: 'Password "$password" should lack special characters',
          );
        }
      });

      test('should validate various special characters', () {
        // Arrange
        const specialCharPasswords = [
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
          'Test123,',
          'Test123.',
          'Test123?',
          'Test123:',
          'Test123;',
          'Test123"',
          'Test123{',
          'Test123}',
          'Test123<',
          'Test123>',
        ];

        // Act & Assert
        for (final password in specialCharPasswords) {
          final result = OffCredentialsValidation.isStrongPassword(password);
          expect(
            result,
            isTrue,
            reason: 'Password "$password" should be valid',
          );
        }
      });
    });

    group('validateRepositoryLevel Tests', () {
      test('should return true for valid repository level credentials', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateRepositoryLevel(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should return false for empty username', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: '',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateRepositoryLevel(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for empty password', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: '',
        );

        // Act
        final result = OffCredentialsValidation.validateRepositoryLevel(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should return false for invalid username format', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'user name',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateRepositoryLevel(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('isRepositoryLevelSecure Tests', () {
      test('should return true for secure repository level credentials', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'SecurePass123!',
        );

        // Act
        final result = OffCredentialsValidation.isRepositoryLevelSecure(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should return false for insecure repository level credentials', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'test',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.isRepositoryLevelSecure(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });
    });

    group('Edge Cases Tests', () {
      test('should handle minimum valid lengths', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'abc', // Minimum length
          password: 'Test1!Ab', // Minimum length (8 characters)
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should handle maximum valid lengths', () {
        // Arrange
        final credentials = OffCredentialsModel(
          username: 'a' * 50, // Maximum length
          password: 'TestPass123!' + 'a' * 115, // Maximum length
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });

      test('should handle whitespace-only credentials', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: '   ',
          password: '   ',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should handle unicode characters in username', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'üser123',
          password: 'TestPass123!',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isFalse);
      });

      test('should handle special characters in password', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!@#\$%^&*()',
        );

        // Act
        final result = OffCredentialsValidation.validateCredentials(
          credentials,
        );

        // Assert
        expect(result, isTrue);
      });
    });

    group('Integration Tests', () {
      test('should validate complete secure credentials workflow', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'testuser',
          password: 'SecurePass123!',
        );

        // Act
        final basicValidation = OffCredentialsValidation.validateCredentials(
          credentials,
        );
        final securityValidation = OffCredentialsValidation.isSecureCredentials(
          credentials,
        );
        final repositoryValidation =
            OffCredentialsValidation.validateRepositoryLevel(credentials);
        final repositorySecurity =
            OffCredentialsValidation.isRepositoryLevelSecure(credentials);

        // Assert
        expect(basicValidation, isTrue);
        expect(securityValidation, isTrue);
        expect(repositoryValidation, isTrue);
        expect(repositorySecurity, isTrue);
      });

      test('should reject insecure credentials at all levels', () {
        // Arrange
        const credentials = OffCredentialsModel(
          username: 'test',
          password: 'testpass',
        );

        // Act
        final basicValidation = OffCredentialsValidation.validateCredentials(
          credentials,
        );
        final securityValidation = OffCredentialsValidation.isSecureCredentials(
          credentials,
        );
        final repositoryValidation =
            OffCredentialsValidation.validateRepositoryLevel(credentials);
        final repositorySecurity =
            OffCredentialsValidation.isRepositoryLevelSecure(credentials);

        // Assert
        expect(basicValidation, isTrue); // Basic format is valid
        expect(securityValidation, isFalse); // Security check fails
        expect(repositoryValidation, isTrue); // Repository format is valid
        expect(repositorySecurity, isFalse); // Repository security fails
      });
    });
  });
}
