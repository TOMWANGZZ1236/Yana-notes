import 'package:flutter/material.dart';
import 'package:hisnotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog(
          context: context,
          title: 'Delete',
          optionsBuilder: () => {
                'Delete': true,
                'Cancel': false,
              },
          content: 'Are you sure you want to delete this user?')
      .then((value) => value ?? false);
}
