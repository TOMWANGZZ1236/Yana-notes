// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnotes/constants/colors.dart';
import 'package:hisnotes/constants/routes.dart';
import 'package:hisnotes/services/auth/auth_exception.dart';
import 'package:hisnotes/services/auth/auth_service.dart';
import 'package:hisnotes/services/auth/bloc/auth_bloc.dart';
import 'package:hisnotes/services/auth/bloc/auth_event.dart';
import 'package:hisnotes/services/auth/bloc/auth_state.dart';
import 'package:hisnotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is EmailInUseAuthException) {
            await showErrorDialog(
              context,
              "Email is already in use",
            );
          } else if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              "Weak Password",
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              "Invalid email",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "Failed to register",
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: appBarColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'Please provide your email and password to register your account '),
              TextField(
                controller: _email,
                autocorrect: false,
                autofocus: true,
                enableSuggestions: false,
                decoration:
                    const InputDecoration(hintText: 'Please enter your email'),
              ),
              TextField(
                controller: _password,
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Please enter your password'),
              ),
              TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                    context.read<AuthBloc>().add(
                          AuthEventRegister(
                            email,
                            password,
                          ),
                        );
                  },
                  child: const Text('Register')),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text('Registered? Login in now!'))
            ],
          ),
        ),
      ),
    );
  }
}
