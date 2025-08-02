class UserModel {
  String? uid;
  String? name;
  String? surname;
  String? username;
  String? email;

  UserModel({this.uid, this.name, this.surname, this.username, this.email});

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

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'surname': surname,
      'username': username,
      'email': email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
    );
  }

  @override
  String toString() =>
      "UserModel(uid: $uid,name: $name,surname: $surname,username: $username,email: $email)";

  @override
  int get hashCode => Object.hash(uid, name, surname, username, email);

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
