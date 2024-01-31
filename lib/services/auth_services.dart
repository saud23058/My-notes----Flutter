
import 'package:my_notes/services/firebase_auth_provider.dart';

import 'auth_provider.dart';
import 'auth_user.dart';

class AuthServices implements Authprovider{

  final Authprovider provider;
   const AuthServices(this.provider);

   factory AuthServices.firebase()=>AuthServices(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({required String email, required String passward})
  =>provider.createUser(email: email, passward: passward);



  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() =>provider.logOut();

  @override
  Future<AuthUser> login({required String email, required String password}
      )=>provider.login(email: email, password: password);

  @override
  Future<void> sendEmailVerification() =>provider.sendEmailVerification();

  @override
  Future<void> initialize() {
    throw UnimplementedError();
  }

}