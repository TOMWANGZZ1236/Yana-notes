import 'package:flutter/material.dart';
import 'package:hisnotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showCreateAccountDialog(
  BuildContext context,
) {
  return showGenericDialog(
          context: context,
          title: 'Reminder',
          optionsBuilder: () => {
                'Go to register screen': true,
                'Cancel': false,
              },
          content:
              'You can only create your own notes after registering with us')
      .then((value) => value ?? false);
}
