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
        // try {
        //   final badUserEmail = await provider.createUser(
        //     email: "tomwangzz1236@gmail.com",
        //     password: "any password",
        //   );
        // } catch (e) {
        //   expect(
        //     e,
        //     const TypeMatcher<InvalidCredentialsAuthException>(),
        //   );
        // }
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

// class NotInitializedException implements Exception {}

// class MockAuthProvider implements AuthProvider {
//   AuthUser? _user;
//   var _isInitialized = false;
//   bool get isInitialized => _isInitialized;
//   @override
//   Future<AuthUser> createUser({
//     required email,
//     required password,
//   }) async {
//     if (!isInitialized) throw NotInitializedException;
//     await Future.delayed(const Duration(seconds: 1));
//     //When create the user we want to sign the user in as well
//     return logIn(
//       email: email,
//       password: password,
//     );
//   }

//   @override
//   AuthUser? get currentUser => _user;
//   @override
//   Future<void> initialize() async {
//     await Future.delayed(const Duration(seconds: 1));
//     _isInitialized = true;
//   }

//   @override
//   Future<AuthUser> logIn({
//     required email,
//     required password,
//   }) {
//     if (!isInitialized) {
//       throw NotInitializedException;
//     }
//     if (email == "tomwangzz1236@gmail.com")
//       throw InvalidCredentialsAuthException();
//     if (password == "Wlj20040620") throw InvalidCredentialsAuthException();
//     const user = AuthUser(isEmailVerified: false);
//     _user = user;
//     return Future.value(user);
//   }

//   @override
//   Future<void> logOut() async {
//     print('reached');
//     if (!isInitialized) {
//       print('reached');
//       throw NotInitializedException;
//     }
//     if (_user == null) throw UserNotLoggedInAuthException();
//     print('reached');
//     await Future.delayed(const Duration(seconds: 1));
//     _user = null;
//   }

//   @override
//   Future<void> sendEmailVerification() async {
//     if (!isInitialized) throw NotInitializedException;
//     final user = _user;
//     if (user == null) throw UserNotLoggedInAuthException();
//     await Future.delayed(const Duration(seconds: 1));
//     const newUser = AuthUser(isEmailVerified: true);
//     _user = newUser;
//   }
// }

// void main() {
//   group('Mock Authentication', () {
//     final provider = MockAuthProvider();
//     test('Should not be initialized to begin with', () {
//       expect(provider.isInitialized, false);
//     });

//     test('Cannot log out if not initialized', () {
//       expect(
//         provider.logOut(),
//         throwsA(const TypeMatcher<NotInitializedException>()),
//       );
//     });

//     test('Should be able to be initialized', () async {
//       await provider.initialize();
//       expect(provider.isInitialized, true);
//     });

//     test('User should be null after initialization', () {
//       expect(provider.currentUser, null);
//     });

//     test(
//       'Should be able to initialize in less than 2 seconds',
//       () async {
//         await provider.initialize();
//         expect(provider.isInitialized, true);
//       },
//       timeout: const Timeout(Duration(seconds: 2)),
//     );

//     test('Create user should delegate to logIn function', () async {
//       final badEmailUser = provider.createUser(
//         email: 'foo@bar.com',
//         password: 'anypassword',
//       );

//       expect(badEmailUser,
//           throwsA(const TypeMatcher<InvalidCredentialsAuthException>()));

//       final badPasswordUser = provider.createUser(
//         email: 'someone@bar.com',
//         password: 'foobar',
//       );
//       expect(badPasswordUser,
//           throwsA(const TypeMatcher<InvalidCredentialsAuthException>()));

//       final user = await provider.createUser(
//         email: 'foo',
//         password: 'bar',
//       );
//       expect(provider.currentUser, user);
//       expect(user.isEmailVerified, false);
//     });

//     test('Logged in user should be able to get verified', () {
//       provider.sendEmailVerification();
//       final user = provider.currentUser;
//       expect(user, isNotNull);
//       expect(user!.isEmailVerified, true);
//     });

//     test('Should be able to log out and log in again', () async {
//       await provider.logOut();
//       await provider.logIn(
//         email: 'email',
//         password: 'password',
//       );
//       final user = provider.currentUser;
//       expect(user, isNotNull);
//     });
//   });
// }

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
    const user =
        AuthUser(isEmailVerified: false, email: 'tomwangzz1236@gmail.com');
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
    const newUser =
        AuthUser(isEmailVerified: true, email: 'tomwangzz1236@gmail.com');
    _user = newUser;
  }

//   @override
//   Future<void> sendPasswordReset({required String toEmail}) {
//     throw UnimplementedError();
//   }
}
