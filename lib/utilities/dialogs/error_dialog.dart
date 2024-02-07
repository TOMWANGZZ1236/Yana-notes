import 'package:flutter/material.dart';
import 'package:hisnotes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
      context: context,
      title: 'An error occured',
      optionsBuilder: () => {'OK': null},
      content: text);
}
