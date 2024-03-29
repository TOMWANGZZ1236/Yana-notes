import 'package:flutter/material.dart';
import 'package:hisnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetEmailSentDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
      context: context,
      title: 'Password reset',
      optionsBuilder: () => {
            'Ok': null,
          },
      content:
          'We have sent you a password reset link, please check your email');
}
