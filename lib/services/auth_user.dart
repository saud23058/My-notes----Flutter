import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final String id;
  final String? email;
  final bool isEmailVerified;

  const AuthUser( {
    required this.id,
    required this.isEmailVerified,
    required this.email
  });

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(
          id: user.uid,
          isEmailVerified: user.emailVerified,
          email: user.email!
      );
}
