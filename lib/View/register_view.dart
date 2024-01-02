// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:hisnotes/constants/routes.dart';
import 'package:hisnotes/services/auth/auth_exception.dart';
import 'package:hisnotes/services/auth/auth_service.dart';
import 'package:hisnotes/utilities/show_error_dialog.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            decoration:
                const InputDecoration(hintText: 'Please enter your email'),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            decoration:
                const InputDecoration(hintText: 'Please enter your password'),
          ),
          TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(
                    verifyEmailRoute,
                  );
                } on EmailInUseAuthException {
                  await showErrorDialog(
                    context,
                    "Email is already in use",
                  );
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    "Weak Password",
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    "Invalid email",
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    "Failed to register",
                  );
                }
              },
              child: const Text('Register')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text('Registered? Login in now!'))
        ],
      ),
    );
  }
}
