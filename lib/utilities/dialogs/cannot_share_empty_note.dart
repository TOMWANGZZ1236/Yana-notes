import 'package:flutter/material.dart';
import 'package:hisnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(
  BuildContext context,
) {
  return showGenericDialog<void>(
      context: context,
      title: 'Sharing',
      optionsBuilder: () => {
            'Ok': null,
          },
      content: 'You cannot share an empty note');
}
