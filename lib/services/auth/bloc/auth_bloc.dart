import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnotes/services/auth/auth_provider.dart';
import 'package:hisnotes/services/auth/bloc/auth_event.dart';
import 'package:hisnotes/services/auth/bloc/auth_state.dart';
import 'package:hisnotes/services/cloud/firebase_cloud_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    //Forgot password
    on<AuthEventForgetPassword>((event, emit) async {
      emit(const AuthStateForgetPassword(
        exception: null,
        isLoading: false,
        hasSentEmail: false,
      ));
      final email = event.email;
      //user only wants to go to the forget password page
      if (email == null) {
        return;
      }
      //user wants to send a forget email password
      emit(const AuthStateForgetPassword(
        exception: null,
        isLoading: true,
        hasSentEmail: false,
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendResetPassword(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }
      emit(AuthStateForgetPassword(
        exception: exception,
        isLoading: false,
        hasSentEmail: didSendEmail,
      ));
    });

    //ShouldRegister
    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        isLoading: false,
      ));
    });
    //Send email verification
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendEmailVerification();
      emit(state);
    });
    //Register
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await provider.createUser(
          email: email,
          password: password,
        );
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          isLoading: false,
        ));
      }
    });
    //Initialize
    on<AuthEventInitialize>((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } else if (!(user.isEmailVerified)) {
        emit(const AuthStateNeedsVerification(
          isLoading: false,
        ));
      } else {
        emit(AuthStateLoggedIn(user: user, isLoading: false));
      }
    });

    //Log In
    on<AuthEventLogIn>((event, emit) async {
      emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: 'Please wait while I am logging you in'));
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );

        if (!user.isEmailVerified) {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          emit(const AuthStateNeedsVerification(
            isLoading: false,
          ));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ));
          emit(AuthStateLoggedIn(
            user: user,
            isLoading: false,
          ));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    //Guest LogIn
    on<AuthEventLogInAsGuest>((event, emit) async {
      emit(const AuthStateLoggedInAsGuest(
        isLoading: false,
      ));
    });

    //Log Out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });

    //Delete User
    on<AuthEventDeleteUser>((event, emit) async {
      try {
        FirebaseCloudStorage()
            .deleteAllNote(owneruserId: provider.currentUser!.id);
        await Future.delayed(const Duration(seconds: 3));
        await provider.deleteUser();

        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: false,
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
