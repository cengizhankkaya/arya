/// Represents a user entity in the application with comprehensive user information.
/// This model encapsulates all user-related data and provides business logic methods
/// for user data validation, formatting, and manipulation.
///
/// The model follows immutable design principles and provides computed properties
/// for derived user information such as full name and display name.
///
/// Usage:
/// ```dart
/// final user = UserModel(
///   uid: 'user123',
///   name: 'John',
///   surname: 'Doe',
///   email: 'john.doe@example.com'
/// );
/// ```
class UserModel {
  /// Unique identifier for the user, typically provided by authentication service
  final String? uid;

  /// User's first/given name
  final String? name;

  /// User's last/family name
  final String? surname;

  /// User's chosen username/handle for display purposes
  final String? username;

  /// User's email address, used for authentication and communication
  final String? email;

  /// Creates a new UserModel instance with the specified user information.
  /// All parameters are optional to support partial user data scenarios.
  const UserModel({
    this.uid,
    this.name,
    this.surname,
    this.username,
    this.email,
  });

  /// Computed property that returns the user's full name by combining first and last names.
  /// Handles edge cases where names might be null or empty, providing fallback text.
  ///
  /// Returns:
  /// - Combined first and last names if both exist
  /// - Single name if only one exists
  /// - Fallback text if no names are available
  String get fullName {
    final nameParts = <String>[];
    if (name?.isNotEmpty == true) nameParts.add(name!);
    if (surname?.isNotEmpty == true) nameParts.add(surname!);
    return nameParts.isEmpty ? 'İsimsiz Kullanıcı' : nameParts.join(' ');
  }

  /// Computed property that returns the most appropriate display name for the user.
  /// Prioritizes username over full name for better user experience and consistency.
  ///
  /// Priority order:
  /// 1. Username (if available and not empty)
  /// 2. Full name (if available)
  /// 3. Fallback text
  String get displayName {
    if (username?.isNotEmpty == true) return username!;
    if (fullName.isNotEmpty) return fullName;
    return 'İsimsiz Kullanıcı';
  }

  /// Validates if the user has the minimum required data for basic functionality.
  /// A user is considered valid if they have both a UID and email address.
  ///
  /// This is useful for determining if a user can perform basic operations
  /// without requiring complete profile information.
  bool get isValid => uid?.isNotEmpty == true && email?.isNotEmpty == true;

  /// Validates if the user has complete profile information.
  /// A user is considered complete if they have UID, name, surname, and email.
  ///
  /// This is useful for determining if a user should be prompted to complete
  /// their profile or if they can access premium features.
  bool get isComplete =>
      uid?.isNotEmpty == true &&
      name?.isNotEmpty == true &&
      surname?.isNotEmpty == true &&
      email?.isNotEmpty == true;

  /// Creates a new UserModel instance with updated values while preserving unchanged fields.
  /// This method follows the copy-with pattern commonly used in immutable data models.
  ///
  /// Parameters:
  /// - uid: New user ID (optional)
  /// - name: New first name (optional)
  /// - surname: New last name (optional)
  /// - username: New username (optional)
  /// - email: New email address (optional)
  ///
  /// Returns a new UserModel instance with the specified updates.
  UserModel copyWith({
    String? uid,
    String? name,
    String? surname,
    String? username,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  /// Converts the UserModel instance to a JSON representation.
  /// Only includes non-null and non-empty values to minimize data transfer.
  ///
  /// This method is typically used for:
  /// - API communication
  /// - Local storage serialization
  /// - Data persistence
  ///
  /// Returns a Map containing the user data in JSON format.
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (uid != null) data['uid'] = uid;
    if (name != null) data['name'] = name;
    if (surname != null) data['surname'] = surname;
    if (username != null && username!.isNotEmpty) data['username'] = username;
    if (email != null) data['email'] = email;
    return data;
  }

  /// Creates a UserModel instance from JSON data.
  /// This factory constructor handles the deserialization of user data from
  /// various sources such as API responses or local storage.
  ///
  /// Parameters:
  /// - json: Map containing user data in JSON format
  ///
  /// Returns a new UserModel instance populated with the JSON data.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
    );
  }

  /// Returns a string representation of the UserModel instance.
  /// Useful for debugging and logging purposes.
  @override
  String toString() =>
      "UserModel(uid: $uid, name: $name, surname: $surname, username: $username, email: $email)";

  /// Generates a hash code for the UserModel instance based on all its properties.
  /// This is essential for proper equality comparison and collection operations.
  @override
  int get hashCode => Object.hash(uid, name, surname, username, email);

  /// Implements equality comparison for UserModel instances.
  /// Two UserModel instances are considered equal if all their properties match.
  ///
  /// This method is crucial for:
  /// - Collection operations (contains, remove, etc.)
  /// - State comparison in UI updates
  /// - Testing and validation
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          surname == other.surname &&
          username == other.username &&
          email == other.email;
}
