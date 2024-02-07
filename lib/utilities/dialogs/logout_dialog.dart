import 'package:flutter/material.dart';
import 'package:hisnotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog(
          context: context,
          title: 'LogOut',
          optionsBuilder: () => {
                'Log Out': true,
                'Cancel': false,
              },
          content: 'Are you sure you want to log out?')
      .then((value) => value ?? false);
}
