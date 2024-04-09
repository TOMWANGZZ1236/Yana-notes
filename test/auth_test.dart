import 'package:hisnotes/services/auth/auth_exception.dart';
import 'package:hisnotes/services/auth/auth_provider.dart';
import 'package:hisnotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    //test1
    test("Should not be initialized to begin with:", () {
      expect(provider.isInitialized, false);
    });

    //test2
    test("Cannot log out if not initialized", () {
      expectLater(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    //test3
    test("Should be able to be initialzied", () async {
      await provider.initialize();
      expect(
        provider.isInitialized,
        true,
      );
    });
    //test4
    test("User should be null after initialization", () {
      expect(
        provider.currentUser,
        null,
      );
    });
    //test5
    test(
      "Should be able to be initialized within 2 seconds",
      () async {
        await provider.initialize();
        expect(
          provider.isInitialized,
          true,
        );
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    //test6
    test(
      "Create user should delegate to logIn function",
      () async {
        final badUserEmail = provider.createUser(
          email: "tomwangzz1236@gmail.com",
          password: "any password",
        );
        expect(
          badUserEmail,
          throwsA(const TypeMatcher<InvalidCredentialsAuthException>()),
        );

        final badPassword = provider.createUser(
          email: "anyuser@gmail.com",
          password: "Wlj20040620",
        );
        expect(
          badPassword,
          throwsA(const TypeMatcher<InvalidCredentialsAuthException>()),
        );

        final user = await provider.createUser(
          email: "tom",
          password: "Wlj",
        );
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      },
    );
    //test7
    test("Logged in user should be able to get verified", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Should be able to log out and log in again", () {
      provider.logOut();
      provider.logIn(email: "Email", password: "Password");
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    // await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required email,
    required password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'tomwangzz1236@gmail.com') {
      throw InvalidCredentialsAuthException();
    }
    if (password == 'Wlj20040620') throw InvalidCredentialsAuthException();
    const user = AuthUser(
      isEmailVerified: false,
      email: 'tomwangzz1236@gmail.com',
      id: 'my_id',
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException();
    const newUser = AuthUser(
      isEmailVerified: true,
      email: 'tomwangzz1236@gmail.com',
      id: 'my_id',
    );
    _user = newUser;
  }

  @override
  Future<void> sendResetPassword({required String toEmail}) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser() {
    throw UnimplementedError();
  }
}
