import 'package:flutter/cupertino.dart';

@immutable
class UserModel {
  final String email;
  final String password;

  UserModel({required this.email, required this.password});

  UserModel copyWith({String? email, String? password}) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
