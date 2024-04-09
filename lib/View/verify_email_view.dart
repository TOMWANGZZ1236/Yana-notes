import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnotes/constants/colors.dart';
import 'package:hisnotes/constants/routes.dart';
import 'package:hisnotes/services/auth/auth_service.dart';
import 'package:hisnotes/services/auth/bloc/auth_bloc.dart';
import 'package:hisnotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verify Email"),
          backgroundColor: appBarColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            const Text(
                'We\'ve sent the verification to the email provided, please check your email. If you haven\'t received email yet, click the button below!'),
            TextButton(
                onPressed: () async {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventSendEmailVerification());
                },
                child: const Text('Send Email Verification')),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Restart'))
          ]),
        ));
  }
}
