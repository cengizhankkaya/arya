import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/profile/model/off_credentials_model.dart';

void main() {
  group('OffCredentialsModel', () {
    group('Constructor Tests', () {
      test('should create model with valid credentials', () {
        // Arrange & Act
        const model = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Assert
        expect(model.username, 'testuser');
        expect(model.password, 'TestPass123!');
      });

      test('should create model with empty credentials', () {
        // Arrange & Act
        const model = OffCredentialsModel(username: '', password: '');

        // Assert
        expect(model.username, '');
        expect(model.password, '');
      });

      test('should create model with special characters in password', () {
        // Arrange & Act
        const model = OffCredentialsModel(
          username: 'testuser',
          password: 'Test@Pass#123!',
        );

        // Assert
        expect(model.username, 'testuser');
        expect(model.password, 'Test@Pass#123!');
      });

      test('should create model with numbers in username', () {
        // Arrange & Act
        const model = OffCredentialsModel(
          username: 'test123user',
          password: 'TestPass123!',
        );

        // Assert
        expect(model.username, 'test123user');
        expect(model.password, 'TestPass123!');
      });

      test('should create model with underscore in username', () {
        // Arrange & Act
        const model = OffCredentialsModel(
          username: 'test_user',
          password: 'TestPass123!',
        );

        // Assert
        expect(model.username, 'test_user');
        expect(model.password, 'TestPass123!');
      });
    });

    group('empty() Factory Tests', () {
      test('should create empty model', () {
        // Arrange & Act
        final model = OffCredentialsModel.empty();

        // Assert
        expect(model.username, '');
        expect(model.password, '');
      });

      test('should create const empty model', () {
        // Arrange & Act
        final model = OffCredentialsModel.empty();

        // Assert
        expect(model.username, '');
        expect(model.password, '');
      });
    });

    group('copyWith Tests', () {
      test('should copy with new username', () {
        // Arrange
        const originalModel = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final newModel = originalModel.copyWith(username: 'newuser');

        // Assert
        expect(newModel.username, 'newuser');
        expect(newModel.password, 'TestPass123!');
        expect(originalModel.username, 'testuser'); // Original unchanged
      });

      test('should copy with new password', () {
        // Arrange
        const originalModel = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final newModel = originalModel.copyWith(password: 'NewPass456!');

        // Assert
        expect(newModel.username, 'testuser');
        expect(newModel.password, 'NewPass456!');
        expect(originalModel.password, 'TestPass123!'); // Original unchanged
      });

      test('should copy with both new values', () {
        // Arrange
        const originalModel = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final newModel = originalModel.copyWith(
          username: 'newuser',
          password: 'NewPass456!',
        );

        // Assert
        expect(newModel.username, 'newuser');
        expect(newModel.password, 'NewPass456!');
        expect(originalModel.username, 'testuser'); // Original unchanged
        expect(originalModel.password, 'TestPass123!'); // Original unchanged
      });

      test('should copy with no changes', () {
        // Arrange
        const originalModel = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final newModel = originalModel.copyWith();

        // Assert
        expect(newModel.username, 'testuser');
        expect(newModel.password, 'TestPass123!');
        expect(
          identical(newModel, originalModel),
          false,
        ); // Different instances
      });

      test('should copy with null values (no change)', () {
        // Arrange
        const originalModel = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final newModel = originalModel.copyWith(username: null, password: null);

        // Assert
        expect(newModel.username, 'testuser');
        expect(newModel.password, 'TestPass123!');
      });
    });

    group('toJson Tests', () {
      test('should convert to JSON correctly', () {
        // Arrange
        const model = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['username'], 'testuser');
        expect(json['password'], 'TestPass123!');
        expect(json.length, 2);
      });

      test('should convert empty model to JSON', () {
        // Arrange
        const model = OffCredentialsModel(username: '', password: '');

        // Act
        final json = model.toJson();

        // Assert
        expect(json['username'], '');
        expect(json['password'], '');
      });

      test('should convert model with special characters to JSON', () {
        // Arrange
        const model = OffCredentialsModel(
          username: 'test_user123',
          password: 'Test@Pass#123!',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['username'], 'test_user123');
        expect(json['password'], 'Test@Pass#123!');
      });
    });

    group('fromJson Tests', () {
      test('should create model from valid JSON', () {
        // Arrange
        const json = {'username': 'testuser', 'password': 'TestPass123!'};

        // Act
        final model = OffCredentialsModel.fromJson(json);

        // Assert
        expect(model.username, 'testuser');
        expect(model.password, 'TestPass123!');
      });

      test('should create model from JSON with null values', () {
        // Arrange
        const json = {'username': null, 'password': null};

        // Act
        final model = OffCredentialsModel.fromJson(json);

        // Assert
        expect(model.username, '');
        expect(model.password, '');
      });

      test('should create model from JSON with missing keys', () {
        // Arrange
        const json = <String, dynamic>{};

        // Act
        final model = OffCredentialsModel.fromJson(json);

        // Assert
        expect(model.username, '');
        expect(model.password, '');
      });

      test('should create model from JSON with extra keys', () {
        // Arrange
        const json = {
          'username': 'testuser',
          'password': 'TestPass123!',
          'extra_key': 'extra_value',
        };

        // Act
        final model = OffCredentialsModel.fromJson(json);

        // Assert
        expect(model.username, 'testuser');
        expect(model.password, 'TestPass123!');
      });

      test('should create model from JSON with different data types', () {
        // Arrange
        const json = {'username': 123, 'password': true};

        // Act & Assert
        expect(
          () => OffCredentialsModel.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('Equality Tests', () {
      test('should be equal to identical model', () {
        // Arrange
        const model1 = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );
        const model2 = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('should not be equal to different username', () {
        // Arrange
        const model1 = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );
        const model2 = OffCredentialsModel(
          username: 'differentuser',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(model1, isNot(equals(model2)));
        expect(model1.hashCode, isNot(equals(model2.hashCode)));
      });

      test('should not be equal to different password', () {
        // Arrange
        const model1 = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );
        const model2 = OffCredentialsModel(
          username: 'testuser',
          password: 'DifferentPass123!',
        );

        // Act & Assert
        expect(model1, isNot(equals(model2)));
        expect(model1.hashCode, isNot(equals(model2.hashCode)));
      });

      test('should not be equal to different type', () {
        // Arrange
        const model = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );
        const differentObject = 'not a model';

        // Act & Assert
        expect(model, isNot(equals(differentObject)));
      });

      test('should be equal to itself', () {
        // Arrange
        const model = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(model, equals(model));
        expect(identical(model, model), isTrue);
      });
    });

    group('toString Tests', () {
      test('should return correct string representation', () {
        // Arrange
        const model = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act
        final string = model.toString();

        // Assert
        expect(
          string,
          'OffCredentialsModel(username: testuser, password: TestPass123!)',
        );
      });

      test('should return correct string for empty model', () {
        // Arrange
        const model = OffCredentialsModel(username: '', password: '');

        // Act
        final string = model.toString();

        // Assert
        expect(string, 'OffCredentialsModel(username: , password: )');
      });

      test('should return correct string for model with special characters', () {
        // Arrange
        const model = OffCredentialsModel(
          username: 'test_user123',
          password: 'Test@Pass#123!',
        );

        // Act
        final string = model.toString();

        // Assert
        expect(
          string,
          'OffCredentialsModel(username: test_user123, password: Test@Pass#123!)',
        );
      });
    });

    group('HashCode Tests', () {
      test('should have consistent hash code', () {
        // Arrange
        const model = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(model.hashCode, equals(model.hashCode));
      });

      test('should have different hash codes for different models', () {
        // Arrange
        const model1 = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );
        const model2 = OffCredentialsModel(
          username: 'differentuser',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(model1.hashCode, isNot(equals(model2.hashCode)));
      });

      test('should have same hash code for equal models', () {
        // Arrange
        const model1 = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );
        const model2 = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act & Assert
        expect(model1.hashCode, equals(model2.hashCode));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle special characters in username and password', () {
        // Arrange
        const specialUsername = 'user@123!#\$%';
        const specialPassword = 'pass@123!#\$%';

        // Act
        const model = OffCredentialsModel(
          username: specialUsername,
          password: specialPassword,
        );

        // Assert
        expect(model.username, specialUsername);
        expect(model.password, specialPassword);
      });

      test('should handle very long strings', () {
        // Arrange
        final longUsername = 'a' * 1000;
        final longPassword = 'b' * 1000;

        // Act
        final model = OffCredentialsModel(
          username: longUsername,
          password: longPassword,
        );

        // Assert
        expect(model.username, longUsername);
        expect(model.password, longPassword);
        expect(model.username.length, 1000);
        expect(model.password.length, 1000);
      });

      test('should handle unicode characters', () {
        // Arrange
        const unicodeUsername = 'üserñame';
        const unicodePassword = 'pässwörd';

        // Act
        const model = OffCredentialsModel(
          username: unicodeUsername,
          password: unicodePassword,
        );

        // Assert
        expect(model.username, unicodeUsername);
        expect(model.password, unicodePassword);
      });
    });

    group('Integration Tests', () {
      test(
        'should handle complete workflow: create -> copy -> toJson -> fromJson',
        () {
          // Arrange
          const originalModel = OffCredentialsModel(
            username: 'testuser',
            password: 'TestPass123!',
          );

          // Act - Copy
          final copiedModel = originalModel.copyWith(
            username: 'newuser',
            password: 'NewPass456!',
          );

          // Act - To JSON
          final json = copiedModel.toJson();

          // Act - From JSON
          final restoredModel = OffCredentialsModel.fromJson(json);

          // Assert
          expect(copiedModel.username, 'newuser');
          expect(copiedModel.password, 'NewPass456!');
          expect(json['username'], 'newuser');
          expect(json['password'], 'NewPass456!');
          expect(restoredModel.username, 'newuser');
          expect(restoredModel.password, 'NewPass456!');
          expect(restoredModel, equals(copiedModel));
        },
      );

      test('should handle multiple copy operations', () {
        // Arrange
        const originalModel = OffCredentialsModel(
          username: 'testuser',
          password: 'TestPass123!',
        );

        // Act - Multiple copies
        final model1 = originalModel.copyWith(username: 'user1');
        final model2 = model1.copyWith(password: 'Pass1');
        final model3 = model2.copyWith(username: 'user2');

        // Assert
        expect(originalModel.username, 'testuser');
        expect(originalModel.password, 'TestPass123!');
        expect(model1.username, 'user1');
        expect(model1.password, 'TestPass123!');
        expect(model2.username, 'user1');
        expect(model2.password, 'Pass1');
        expect(model3.username, 'user2');
        expect(model3.password, 'Pass1');
      });
    });
  });
}
