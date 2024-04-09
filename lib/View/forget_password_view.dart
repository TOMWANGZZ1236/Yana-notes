import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnotes/constants/colors.dart';
import 'package:hisnotes/services/auth/bloc/auth_bloc.dart';
import 'package:hisnotes/services/auth/bloc/auth_event.dart';
import 'package:hisnotes/services/auth/bloc/auth_state.dart';
import 'package:hisnotes/utilities/dialogs/error_dialog.dart';
import 'package:hisnotes/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgetPassword) {
          if (state.hasSentEmail == true && state.exception == null) {
            _controller.clear();
            await showPasswordResetEmailSentDialog(context);
          } else if (state.exception != null) {
            await showErrorDialog(context,
                "Please enter a registered user, we can't find the provided email");
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Forget Password'),
            backgroundColor: appBarColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                    'Please enter your email if you forget your passowrd'),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  decoration:
                      const InputDecoration(hintText: "Your email address"),
                ),
                TextButton(
                    onPressed: () {
                      final email = _controller.text;
                      context
                          .read<AuthBloc>()
                          .add(AuthEventForgetPassword(email: email));
                    },
                    child: const Text('Send me password reset link')),
                TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: const Text('Click here to back to the login page'))
              ],
            ),
          )),
    );
  }
}
