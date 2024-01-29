import 'package:firebase_auth/firebase_auth.dart' show AuthProvider, FirebaseAuth, FirebaseAuthException;
import 'package:my_notes/services/auth_exception.dart';
import 'package:my_notes/services/auth_provider.dart';
import 'auth_user.dart';

class FirebaseAuthProvider implements Authprovider {
  @override
  Future<AuthUser> createUser({required String email, required String passward}) async {
    try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: passward);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      throw UserNotLoggedInuthException();
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      throw EmailAlreadyInUseAuthException();
    } else if (e.code == 'weak-password') {
      throw WrongPasswardAuthException();
    } else {
      throw GenericAuthException();
    }
  } catch (_) {
    throw GenericAuthException();
  }
}


  AuthUser? get currentUser {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return AuthUser.fromFirebase(user);
  } else {
    return null;
  }
}

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInuthException();
    }
  }

  @override
 Future<AuthUser> login({
   required String email,
   required String password,
 }) async {
   try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
     final user = FirebaseAuth.instance.currentUser;
     if (user != null) {
       return AuthUser.fromFirebase(user);
     } else {
       throw UserNotLoggedInuthException();
     }
   } on FirebaseAuthException catch (e) {
     if (e.code == 'user-not-found') {
       throw UserNotLoggedInuthException();
     } else if (e.code == 'wrong-password') {
       throw WrongPasswardAuthException();
     } else {
       throw GenericAuthException();
     }
   } catch (_) {
    throw GenericAuthException();
   }
 }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInuthException();
    }
  }

}




