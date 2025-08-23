class OffCredentialsModel {
  final String username;
  final String password;

  const OffCredentialsModel({required this.username, required this.password});

  factory OffCredentialsModel.empty() {
    return const OffCredentialsModel(username: '', password: '');
  }

  OffCredentialsModel copyWith({String? username, String? password}) {
    return OffCredentialsModel(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

  factory OffCredentialsModel.fromJson(Map<String, dynamic> json) {
    return OffCredentialsModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OffCredentialsModel &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;

  @override
  String toString() {
    return 'OffCredentialsModel(username: $username, password: $password)';
  }
}
