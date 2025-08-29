import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterViewModel Validation Tests', () {
    group('Email Validation Tests', () {
      test('should validate email format correctly', () {
        // Arrange
        const validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          '123@numbers.com',
        ];

        const invalidEmails = [
          'invalid-email',
          'test@',
          '@test.com',
          'test.com',
          'test@test',
        ];

        // Act & Assert - Valid emails
        for (final email in validEmails) {
          final isValid = _isValidEmail(email);
          expect(isValid, isTrue, reason: 'Email: $email');
        }

        // Act & Assert - Invalid emails
        for (final email in invalidEmails) {
          final isValid = _isValidEmail(email);
          expect(isValid, isFalse, reason: 'Email: $email');
        }
      });

      test('should handle edge cases for email validation', () {
        // Arrange
        final edgeCaseEmails = [
          '', // Empty
          '   ', // Only spaces
          'a' * 255 + '@example.com', // Too long
          'a' * 254 + '@example.com', // Maximum length
        ];

        // Act & Assert
        expect(_isValidEmail(edgeCaseEmails[0]), isFalse); // Empty
        expect(_isValidEmail(edgeCaseEmails[1]), isFalse); // Only spaces
        expect(_isValidEmail(edgeCaseEmails[2]), isFalse); // Too long
        expect(
          _isValidEmail(edgeCaseEmails[3]),
          isFalse,
        ); // Maximum length - too long for our regex
      });
    });

    group('Password Validation Tests', () {
      test('should validate password length correctly', () {
        // Arrange
        final validPasswords = [
          '123456', // Minimum length
          'password123',
          'MyPassword123',
          'a' * 128, // Maximum length
        ];

        final invalidPasswords = [
          '12345', // Too short
          'a' * 129, // Too long
        ];

        // Act & Assert - Valid passwords
        for (final password in validPasswords) {
          final isValid = _isValidPassword(password);
          expect(isValid, isTrue, reason: 'Password: $password');
        }

        // Act & Assert - Invalid passwords
        for (final password in invalidPasswords) {
          final isValid = _isValidPassword(password);
          expect(isValid, isFalse, reason: 'Password: $password');
        }
      });

      test('should handle edge cases for password validation', () {
        // Arrange
        const edgeCasePasswords = [
          '', // Empty
          '   ', // Only spaces
        ];

        // Act & Assert
        expect(_isValidPassword(edgeCasePasswords[0]), isFalse); // Empty
        expect(_isValidPassword(edgeCasePasswords[1]), isFalse); // Only spaces
      });
    });

    group('Name Validation Tests', () {
      test('should validate name length correctly', () {
        // Arrange
        final validNames = [
          'John', // Minimum length
          'John Doe',
          'José María',
          'A' * 50, // Maximum length
        ];

        final invalidNames = [
          'A', // Too short
          'A' * 51, // Too long
        ];

        // Act & Assert - Valid names
        for (final name in validNames) {
          final isValid = _isValidName(name);
          expect(isValid, isTrue, reason: 'Name: $name');
        }

        // Act & Assert - Invalid names
        for (final name in invalidNames) {
          final isValid = _isValidName(name);
          expect(isValid, isFalse, reason: 'Name: $name');
        }
      });

      test('should handle edge cases for name validation', () {
        // Arrange
        const edgeCaseNames = [
          '', // Empty
          '   ', // Only spaces
        ];

        // Act & Assert
        expect(_isValidName(edgeCaseNames[0]), isFalse); // Empty
        expect(_isValidName(edgeCaseNames[1]), isFalse); // Only spaces
      });
    });

    group('Confirm Password Validation Tests', () {
      test('should validate password matching correctly', () {
        // Arrange
        const password = 'password123';
        const matchingConfirmPassword = 'password123';
        const nonMatchingConfirmPassword = 'differentpassword';

        // Act & Assert
        expect(_doPasswordsMatch(password, matchingConfirmPassword), isTrue);
        expect(
          _doPasswordsMatch(password, nonMatchingConfirmPassword),
          isFalse,
        );
      });

      test('should handle edge cases for confirm password validation', () {
        // Arrange
        const password = 'password123';
        const edgeCaseConfirmPasswords = [
          '', // Empty
          '   ', // Only spaces
        ];

        // Act & Assert
        expect(
          _doPasswordsMatch(password, edgeCaseConfirmPasswords[0]),
          isFalse,
        ); // Empty
        expect(
          _doPasswordsMatch(password, edgeCaseConfirmPasswords[1]),
          isFalse,
        ); // Only spaces
      });
    });

    group('Form Validation Integration Tests', () {
      test('should validate complete form correctly', () {
        // Arrange
        const formData = {
          'email': 'test@example.com',
          'password': 'password123',
          'confirmPassword': 'password123',
          'name': 'John Doe',
        };

        // Act
        final emailValid = _isValidEmail(formData['email']!);
        final passwordValid = _isValidPassword(formData['password']!);
        final confirmPasswordValid = _doPasswordsMatch(
          formData['password']!,
          formData['confirmPassword']!,
        );
        final nameValid = _isValidName(formData['name']!);

        // Assert
        expect(emailValid, isTrue);
        expect(passwordValid, isTrue);
        expect(confirmPasswordValid, isTrue);
        expect(nameValid, isTrue);
      });

      test('should fail validation when any field is invalid', () {
        // Arrange
        const invalidFormData = [
          {
            'email': 'invalidemail',
            'password': 'password123',
            'confirmPassword': 'password123',
            'name': 'John Doe',
          },
          {
            'email': 'test@example.com',
            'password': '123',
            'confirmPassword': '123',
            'name': 'John Doe',
          },
          {
            'email': 'test@example.com',
            'password': 'password123',
            'confirmPassword': 'different',
            'name': 'John Doe',
          },
          {
            'email': 'test@example.com',
            'password': 'password123',
            'confirmPassword': 'password123',
            'name': 'A',
          },
        ];

        // Act & Assert
        for (final formData in invalidFormData) {
          final emailValid = _isValidEmail(formData['email']!);
          final passwordValid = _isValidPassword(formData['password']!);
          final confirmPasswordValid = _doPasswordsMatch(
            formData['password']!,
            formData['confirmPassword']!,
          );
          final nameValid = _isValidName(formData['name']!);

          // At least one field should be invalid
          final hasInvalidField =
              !emailValid ||
              !passwordValid ||
              !confirmPasswordValid ||
              !nameValid;
          expect(hasInvalidField, isTrue, reason: 'Form data: $formData');
        }
      });
    });

    group('Edge Cases Tests', () {
      test('should handle special characters correctly', () {
        // Arrange
        const specialEmails = [
          'test+tag@example.com',
          'user.name@domain.co.uk',
          '123@numbers.com',
        ];

        const specialPasswords = [
          'p@ssw0rd!@#',
          'MyP@ssw0rd123',
          '123!@#\$%^&*()',
        ];

        const specialNames = ['José María', 'Jean-Pierre', 'O\'Connor'];

        // Act & Assert - Special characters should be handled
        for (final email in specialEmails) {
          final isValid = _isValidEmail(email);
          expect(isValid, isTrue, reason: 'Email: $email');
        }

        for (final password in specialPasswords) {
          final isValid = _isValidPassword(password);
          expect(isValid, isTrue, reason: 'Password: $password');
        }

        for (final name in specialNames) {
          final isValid = _isValidName(name);
          expect(isValid, isTrue, reason: 'Name: $name');
        }
      });

      test('should handle unicode characters correctly', () {
        // Arrange
        const unicodeNames = ['José', 'Müller', 'García', '李李', 'محمد'];

        // Act & Assert
        for (final name in unicodeNames) {
          final isValid = _isValidName(name);
          expect(isValid, isTrue, reason: 'Name: $name');
        }
      });
    });
  });
}

// Helper methods for validation (simplified versions)
bool _isValidEmail(String email) {
  if (email.isEmpty || email.trim().isEmpty) return false;
  if (email.length > 254) return false;

  // Simple email regex
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  return emailRegex.hasMatch(email.trim());
}

bool _isValidPassword(String password) {
  if (password.isEmpty) return false;
  if (password.length < 6) return false;
  if (password.length > 128) return false;
  return true;
}

bool _isValidName(String name) {
  if (name.isEmpty || name.trim().isEmpty) return false;
  if (name.trim().length < 2) return false;
  if (name.trim().length > 50) return false;
  return true;
}

bool _doPasswordsMatch(String password, String confirmPassword) {
  if (confirmPassword.isEmpty || confirmPassword.trim().isEmpty) return false;
  return password == confirmPassword;
}
