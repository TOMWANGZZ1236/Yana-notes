import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hisnotes/View/forget_password_view.dart';
import 'package:hisnotes/View/login_view.dart';
import 'package:hisnotes/View/notes/create_update_note_view.dart';
import 'package:hisnotes/View/notes/notes_view.dart';
import 'package:hisnotes/View/register_view.dart';
import 'package:hisnotes/View/verify_email_view.dart';
import 'package:hisnotes/constants/routes.dart';
import 'package:hisnotes/helpers/loading/loading_screen.dart';
import 'package:hisnotes/services/auth/bloc/auth_bloc.dart';
import 'package:hisnotes/services/auth/bloc/auth_event.dart';
import 'package:hisnotes/services/auth/bloc/auth_state.dart';
import 'package:hisnotes/services/auth/firebase_auth_provider.dart';
import 'firebase_options.dart';
import 'dart:developer' as devdart show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Future.delayed(const Duration(seconds: 3));

  FlutterNativeSplash.remove();

  runApp(MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const NewNoteView(),
      }));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateLoggedIn) {
          return const NoteView();
        } else if (state is AuthStateForgetPassword) {
          return const ForgetPasswordView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
      listener: (BuildContext context, AuthState state) {
        if (state.isLoading == true) {
          LoadingScreen().show(context: context, text: state.loadingText!);
        } else {
          LoadingScreen().hide();
        }
      },
    );
  }
}
