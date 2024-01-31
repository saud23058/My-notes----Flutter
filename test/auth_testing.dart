import 'package:my_notes/services/auth_exception.dart';
import 'package:my_notes/services/auth_provider.dart';
import 'package:my_notes/services/auth_user.dart';
import 'package:test/test.dart';
void main(){
group('MOCK authentication',(){
  final provider= MockAuthProvider();
  test('Should not be initialized to begin with',(){
    expect(provider.isInitialied,false);
  });
  test('Cannot logout if not initialized', () {
    expect(provider.logOut(),
      throwsA(const TypeMatcher<NotInitialiedException>()),
    );
  });
  test('Should be able to be initialized', () async{
    await provider.initialize();
    expect(provider.isInitialied, true);
  });
  test('User should be null after initialization', () {
    expect(provider.currentUser, null);
  });
  test('Should be able to initialize in less than 2 seconds', () async{
    await provider.isInitialied;
    expect(provider.isInitialied, true);
  },timeout: const Timeout(Duration(seconds: 2)),
  );
  test('Create user should delegate to logIn funtion', () async {
    final badEmailUser=provider.createUser(
        email: 'admin@gmail.com',
        passward:'123456');
    expect(badEmailUser,throwsA(const TypeMatcher<UserNotAuthFoundException>()));
    final badPasswordUser=provider.createUser(
        email: 'some@gmail.com',
        passward: '1234567');
    expect(badPasswordUser, throwsA(const TypeMatcher<WrongPasswordAuthException>()));
    final user =await provider.createUser(email: 'foo', passward: 'bar');
    expect(provider.currentUser, user);
    expect(user.isEmailVerified, false);
  });
test('LogIn user should be able to get  verified ', () {
  provider.sendEmailVerification();
  final user=provider.currentUser;
  expect(user, isNotNull);
  expect(user!.isEmailVerified, true);
});
test('Should be able to log out and log in again',() async {
  await provider.logOut();
  await provider.login(email: 'abc@gmail.com', password:'12345678');
  final user=provider.currentUser;
  expect(user, isNotNull);
});
});
}

class NotInitialiedException implements Exception{}

class MockAuthProvider implements Authprovider{
  AuthUser? _user;
  var _isInitialized= false;

  bool get isInitialied =>_isInitialized;
  @override
  Future<AuthUser> createUser({required String email, required String passward}) async{
    if(!isInitialied) throw NotInitialiedException();
    await Future.delayed(const Duration(seconds: 1));
    return login(email: email, password: passward);
  }


  @override
  // TODO: implement currentUser
  AuthUser? get currentUser =>_user;

  @override
  Future<void> logOut() async{
    if(!isInitialied) throw NotInitialiedException();
    if(_user==null) throw UserNotAuthFoundException();
    await Future.delayed(const Duration(seconds: 1));
    _user=null;
  }

  @override
  Future<AuthUser> login({required String email, required String password}) {
    if(!isInitialied) throw NotInitialiedException();
    if (email=='admin@gmail.com') throw UserNotAuthFoundException();
    if(password=='123456')throw WrongPasswordAuthException();
    const user=AuthUser(isEmailVerified: false);
    _user=user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if(!isInitialied) throw NotInitialiedException();
    final user=_user;
    if(user==null)throw UserNotAuthFoundException();
    const newUser=AuthUser(isEmailVerified: true);
    _user=newUser;
  }
  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized=true;
  }

}