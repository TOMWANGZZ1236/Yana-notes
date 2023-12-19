import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String error) {
  return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("An error has occured"),
          content: Text("Error： $error has occured"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK')),
          ],
        );
      });
}
