import 'package:flutter_test/flutter_test.dart';
import 'package:arya/features/auth/model/user_model.dart';

void main() {
  group('UserModel', () {
    group('Constructor Tests', () {
      test('should create model with all parameters', () {
        // Arrange & Act
        const model = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
          email: 'john.doe@example.com',
        );

        // Assert
        expect(model.uid, 'user123');
        expect(model.name, 'John');
        expect(model.surname, 'Doe');
        expect(model.username, 'johndoe');
        expect(model.email, 'john.doe@example.com');
      });

      test('should create model with partial parameters', () {
        // Arrange & Act
        const model = UserModel(uid: 'user123', email: 'john.doe@example.com');

        // Assert
        expect(model.uid, 'user123');
        expect(model.name, isNull);
        expect(model.surname, isNull);
        expect(model.username, isNull);
        expect(model.email, 'john.doe@example.com');
      });

      test('should create model with null parameters', () {
        // Arrange & Act
        const model = UserModel();

        // Assert
        expect(model.uid, isNull);
        expect(model.name, isNull);
        expect(model.surname, isNull);
        expect(model.username, isNull);
        expect(model.email, isNull);
      });

      test('should create model with empty strings', () {
        // Arrange & Act
        const model = UserModel(
          uid: '',
          name: '',
          surname: '',
          username: '',
          email: '',
        );

        // Assert
        expect(model.uid, '');
        expect(model.name, '');
        expect(model.surname, '');
        expect(model.username, '');
        expect(model.email, '');
      });
    });

    group('fullName Tests', () {
      test('should return full name when both name and surname exist', () {
        // Arrange
        const model = UserModel(name: 'John', surname: 'Doe');

        // Act
        final fullName = model.fullName;

        // Assert
        expect(fullName, 'John Doe');
      });

      test('should return only name when surname is null', () {
        // Arrange
        const model = UserModel(name: 'John');

        // Act
        final fullName = model.fullName;

        // Assert
        expect(fullName, 'John');
      });

      test('should return only surname when name is null', () {
        // Arrange
        const model = UserModel(surname: 'Doe');

        // Act
        final fullName = model.fullName;

        // Assert
        expect(fullName, 'Doe');
      });

      test('should return fallback when both name and surname are null', () {
        // Arrange
        const model = UserModel();

        // Act
        final fullName = model.fullName;

        // Assert
        expect(fullName, 'İsimsiz Kullanıcı');
      });

      test('should return fallback when both name and surname are empty', () {
        // Arrange
        const model = UserModel(name: '', surname: '');

        // Act
        final fullName = model.fullName;

        // Assert
        expect(fullName, 'İsimsiz Kullanıcı');
      });

      test('should handle whitespace in names', () {
        // Arrange
        const model = UserModel(name: '  John  ', surname: '  Doe  ');

        // Act
        final fullName = model.fullName;

        // Assert
        expect(fullName, '  John     Doe  ');
      });
    });

    group('displayName Tests', () {
      test('should return username when available', () {
        // Arrange
        const model = UserModel(
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
        );

        // Act
        final displayName = model.displayName;

        // Assert
        expect(displayName, 'johndoe');
      });

      test('should return full name when username is not available', () {
        // Arrange
        const model = UserModel(name: 'John', surname: 'Doe');

        // Act
        final displayName = model.displayName;

        // Assert
        expect(displayName, 'John Doe');
      });

      test('should return only name when surname is not available', () {
        // Arrange
        const model = UserModel(name: 'John');

        // Act
        final displayName = model.displayName;

        // Assert
        expect(displayName, 'John');
      });

      test('should return fallback when no names are available', () {
        // Arrange
        const model = UserModel();

        // Act
        final displayName = model.displayName;

        // Assert
        expect(displayName, 'İsimsiz Kullanıcı');
      });

      test('should prioritize username over full name', () {
        // Arrange
        const model = UserModel(
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
        );

        // Act
        final displayName = model.displayName;

        // Assert
        expect(displayName, 'johndoe');
        expect(displayName, isNot('John Doe'));
      });

      test('should handle empty username', () {
        // Arrange
        const model = UserModel(name: 'John', surname: 'Doe', username: '');

        // Act
        final displayName = model.displayName;

        // Assert
        expect(displayName, 'John Doe');
      });
    });

    group('isValid Tests', () {
      test('should return true when uid and email are present', () {
        // Arrange
        const model = UserModel(uid: 'user123', email: 'john.doe@example.com');

        // Act
        final isValid = model.isValid;

        // Assert
        expect(isValid, isTrue);
      });

      test('should return false when uid is missing', () {
        // Arrange
        const model = UserModel(email: 'john.doe@example.com');

        // Act
        final isValid = model.isValid;

        // Assert
        expect(isValid, isFalse);
      });

      test('should return false when email is missing', () {
        // Arrange
        const model = UserModel(uid: 'user123');

        // Act
        final isValid = model.isValid;

        // Assert
        expect(isValid, isFalse);
      });

      test('should return false when both uid and email are missing', () {
        // Arrange
        const model = UserModel();

        // Act
        final isValid = model.isValid;

        // Assert
        expect(isValid, isFalse);
      });

      test('should return false when uid is empty string', () {
        // Arrange
        const model = UserModel(uid: '', email: 'john.doe@example.com');

        // Act
        final isValid = model.isValid;

        // Assert
        expect(isValid, isFalse);
      });

      test('should return false when email is empty string', () {
        // Arrange
        const model = UserModel(uid: 'user123', email: '');

        // Act
        final isValid = model.isValid;

        // Assert
        expect(isValid, isFalse);
      });
    });

    group('isComplete Tests', () {
      test('should return true when all required fields are present', () {
        // Arrange
        const model = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final isComplete = model.isComplete;

        // Assert
        expect(isComplete, isTrue);
      });

      test('should return false when uid is missing', () {
        // Arrange
        const model = UserModel(
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final isComplete = model.isComplete;

        // Assert
        expect(isComplete, isFalse);
      });

      test('should return false when name is missing', () {
        // Arrange
        const model = UserModel(
          uid: 'user123',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final isComplete = model.isComplete;

        // Assert
        expect(isComplete, isFalse);
      });

      test('should return false when surname is missing', () {
        // Arrange
        const model = UserModel(
          uid: 'user123',
          name: 'John',
          email: 'john.doe@example.com',
        );

        // Act
        final isComplete = model.isComplete;

        // Assert
        expect(isComplete, isFalse);
      });

      test('should return false when email is missing', () {
        // Arrange
        const model = UserModel(uid: 'user123', name: 'John', surname: 'Doe');

        // Act
        final isComplete = model.isComplete;

        // Assert
        expect(isComplete, isFalse);
      });

      test('should return false when any field is empty string', () {
        // Arrange
        const model = UserModel(
          uid: '',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final isComplete = model.isComplete;

        // Assert
        expect(isComplete, isFalse);
      });
    });

    group('copyWith Tests', () {
      test('should copy with new uid', () {
        // Arrange
        const originalModel = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final newModel = originalModel.copyWith(uid: 'newuser456');

        // Assert
        expect(newModel.uid, 'newuser456');
        expect(newModel.name, 'John');
        expect(newModel.surname, 'Doe');
        expect(newModel.email, 'john.doe@example.com');
        expect(originalModel.uid, 'user123'); // Original unchanged
      });

      test('should copy with new name', () {
        // Arrange
        const originalModel = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final newModel = originalModel.copyWith(name: 'Jane');

        // Assert
        expect(newModel.uid, 'user123');
        expect(newModel.name, 'Jane');
        expect(newModel.surname, 'Doe');
        expect(newModel.email, 'john.doe@example.com');
        expect(originalModel.name, 'John'); // Original unchanged
      });

      test('should copy with multiple fields', () {
        // Arrange
        const originalModel = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final newModel = originalModel.copyWith(
          name: 'Jane',
          surname: 'Smith',
          email: 'jane.smith@example.com',
        );

        // Assert
        expect(newModel.uid, 'user123');
        expect(newModel.name, 'Jane');
        expect(newModel.surname, 'Smith');
        expect(newModel.email, 'jane.smith@example.com');
        expect(originalModel.name, 'John'); // Original unchanged
        expect(originalModel.surname, 'Doe'); // Original unchanged
        expect(
          originalModel.email,
          'john.doe@example.com',
        ); // Original unchanged
      });

      test('should copy with no changes', () {
        // Arrange
        const originalModel = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final newModel = originalModel.copyWith();

        // Assert
        expect(newModel.uid, 'user123');
        expect(newModel.name, 'John');
        expect(newModel.surname, 'Doe');
        expect(newModel.email, 'john.doe@example.com');
        expect(
          identical(newModel, originalModel),
          false,
        ); // Different instances
      });

      test('should copy with null values (no change)', () {
        // Arrange
        const originalModel = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final newModel = originalModel.copyWith(
          uid: null,
          name: null,
          surname: null,
          email: null,
        );

        // Assert
        expect(newModel.uid, 'user123');
        expect(newModel.name, 'John');
        expect(newModel.surname, 'Doe');
        expect(newModel.email, 'john.doe@example.com');
      });
    });

    group('toJson Tests', () {
      test('should convert to JSON correctly', () {
        // Arrange
        const model = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          username: 'johndoe',
          email: 'john.doe@example.com',
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json, isA<Map<String, dynamic>>());
        expect(json['uid'], 'user123');
        expect(json['name'], 'John');
        expect(json['surname'], 'Doe');
        expect(json['username'], 'johndoe');
        expect(json['email'], 'john.doe@example.com');
        expect(json.length, 5);
      });

      test('should convert partial model to JSON', () {
        // Arrange
        const model = UserModel(uid: 'user123', email: 'john.doe@example.com');

        // Act
        final json = model.toJson();

        // Assert
        expect(json['uid'], 'user123');
        expect(json['name'], isNull);
        expect(json['surname'], isNull);
        expect(json['username'], isNull);
        expect(json['email'], 'john.doe@example.com');
      });

      test('should convert empty model to JSON', () {
        // Arrange
        const model = UserModel();

        // Act
        final json = model.toJson();

        // Assert
        expect(json['uid'], isNull);
        expect(json['name'], isNull);
        expect(json['surname'], isNull);
        expect(json['username'], isNull);
        expect(json['email'], isNull);
      });
    });

    group('fromJson Tests', () {
      test('should create model from valid JSON', () {
        // Arrange
        const json = {
          'uid': 'user123',
          'name': 'John',
          'surname': 'Doe',
          'username': 'johndoe',
          'email': 'john.doe@example.com',
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.uid, 'user123');
        expect(model.name, 'John');
        expect(model.surname, 'Doe');
        expect(model.username, 'johndoe');
        expect(model.email, 'john.doe@example.com');
      });

      test('should create model from JSON with null values', () {
        // Arrange
        const json = {
          'uid': null,
          'name': null,
          'surname': null,
          'username': null,
          'email': null,
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.uid, isNull);
        expect(model.name, isNull);
        expect(model.surname, isNull);
        expect(model.username, isNull);
        expect(model.email, isNull);
      });

      test('should create model from JSON with missing keys', () {
        // Arrange
        const json = <String, dynamic>{};

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.uid, isNull);
        expect(model.name, isNull);
        expect(model.surname, isNull);
        expect(model.username, isNull);
        expect(model.email, isNull);
      });

      test('should create model from JSON with extra keys', () {
        // Arrange
        const json = {
          'uid': 'user123',
          'name': 'John',
          'extra_key': 'extra_value',
        };

        // Act
        final model = UserModel.fromJson(json);

        // Assert
        expect(model.uid, 'user123');
        expect(model.name, 'John');
        expect(model.surname, isNull);
        expect(model.username, isNull);
        expect(model.email, isNull);
      });
    });

    group('Equality Tests', () {
      test('should be equal to identical model', () {
        // Arrange
        const model1 = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        const model2 = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act & Assert
        expect(model1, equals(model2));
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('should not be equal to different uid', () {
        // Arrange
        const model1 = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        const model2 = UserModel(
          uid: 'differentuser',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act & Assert
        expect(model1, isNot(equals(model2)));
        expect(model1.hashCode, isNot(equals(model2.hashCode)));
      });

      test('should not be equal to different type', () {
        // Arrange
        const model = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );
        const differentObject = 'not a model';

        // Act & Assert
        expect(model, isNot(equals(differentObject)));
      });

      test('should be equal to itself', () {
        // Arrange
        const model = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act & Assert
        expect(model, equals(model));
        expect(identical(model, model), isTrue);
      });
    });

    group('toString Tests', () {
      test('should return correct string representation', () {
        // Arrange
        const model = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act
        final string = model.toString();

        // Assert
        expect(string, contains('UserModel'));
        expect(string, contains('uid: user123'));
        expect(string, contains('name: John'));
        expect(string, contains('surname: Doe'));
        expect(string, contains('email: john.doe@example.com'));
      });

      test('should return correct string for partial model', () {
        // Arrange
        const model = UserModel(uid: 'user123', email: 'john.doe@example.com');

        // Act
        final string = model.toString();

        // Assert
        expect(string, contains('uid: user123'));
        expect(string, contains('email: john.doe@example.com'));
        expect(string, contains('name: null'));
        expect(string, contains('surname: null'));
      });
    });

    group('Edge Cases Tests', () {
      test('should handle very long strings', () {
        // Arrange
        final longString = 'a' * 1000;
        final model = UserModel(
          uid: longString,
          name: longString,
          surname: longString,
          username: longString,
          email: longString,
        );

        // Act & Assert
        expect(model.uid, longString);
        expect(model.name, longString);
        expect(model.surname, longString);
        expect(model.username, longString);
        expect(model.email, longString);
        expect(model.uid!.length, 1000);
      });

      test('should handle unicode characters', () {
        // Arrange
        const unicodeName = 'José María';
        const unicodeSurname = 'García-López';
        const model = UserModel(name: unicodeName, surname: unicodeSurname);

        // Act & Assert
        expect(model.name, unicodeName);
        expect(model.surname, unicodeSurname);
        expect(model.fullName, 'José María García-López');
      });

      test('should handle special characters in username', () {
        // Arrange
        const specialUsername = 'user_123-test';
        const model = UserModel(username: specialUsername);

        // Act & Assert
        expect(model.username, specialUsername);
        expect(model.displayName, specialUsername);
      });
    });

    group('Integration Tests', () {
      test(
        'should handle complete workflow: create -> copy -> toJson -> fromJson',
        () {
          // Arrange
          const originalModel = UserModel(
            uid: 'user123',
            name: 'John',
            surname: 'Doe',
            email: 'john.doe@example.com',
          );

          // Act - Copy
          final copiedModel = originalModel.copyWith(
            name: 'Jane',
            surname: 'Smith',
          );

          // Act - To JSON
          final json = copiedModel.toJson();

          // Act - From JSON
          final restoredModel = UserModel.fromJson(json);

          // Assert
          expect(copiedModel.name, 'Jane');
          expect(copiedModel.surname, 'Smith');
          expect(json['name'], 'Jane');
          expect(json['surname'], 'Smith');
          expect(restoredModel.name, 'Jane');
          expect(restoredModel.surname, 'Smith');
          expect(restoredModel, equals(copiedModel));
        },
      );

      test('should handle multiple copy operations', () {
        // Arrange
        const originalModel = UserModel(
          uid: 'user123',
          name: 'John',
          surname: 'Doe',
          email: 'john.doe@example.com',
        );

        // Act - Multiple copies
        final model1 = originalModel.copyWith(name: 'Jane');
        final model2 = model1.copyWith(surname: 'Smith');
        final model3 = model2.copyWith(email: 'jane.smith@example.com');

        // Assert
        expect(originalModel.name, 'John');
        expect(originalModel.surname, 'Doe');
        expect(originalModel.email, 'john.doe@example.com');
        expect(model1.name, 'Jane');
        expect(model1.surname, 'Doe');
        expect(model2.name, 'Jane');
        expect(model2.surname, 'Smith');
        expect(model3.name, 'Jane');
        expect(model3.surname, 'Smith');
        expect(model3.email, 'jane.smith@example.com');
      });
    });
  });
}
