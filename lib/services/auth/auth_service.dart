//Auth Service relays the messages of the given auth provider, but can have more logic.
//Auth Service exposes all the functionalities of the given auth provider to the UI
import 'package:hisnotes/services/auth/auth_user.dart';
import 'package:hisnotes/services/auth/auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService(this.provider);

  @override
  Future<AuthUser> createUser({
    required email,
    required password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required email,
    required password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
