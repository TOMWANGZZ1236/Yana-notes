import 'package:flutter/material.dart';
import 'package:hisnotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog(
          context: context,
          title: 'Delete',
          optionsBuilder: () => {
                'Yes': true,
                'Cancel': false,
              },
          content: 'Are you sure you want to delete?')
      .then((value) => value ?? false);
}
