

import 'package:my_notes/services/auth_user.dart';

abstract class Authprovider{
  AuthUser? get currentUser;

  Future<AuthUser>login({
 required String email,
 required String password,
});

  Future<AuthUser>createUser({
    required String email,
    required String passward,
});
  Future<void>logOut();
  Future<void>sendEmailVerification();
}