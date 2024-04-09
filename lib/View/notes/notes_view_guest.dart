import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnotes/View/notes/note_list_view.dart';
import 'package:hisnotes/View/register_view.dart';
import 'package:hisnotes/constants/colors.dart';
import 'package:hisnotes/constants/routes.dart';
import 'package:hisnotes/enums/menu_action.dart';
import 'package:hisnotes/services/auth/auth_service.dart';
import 'package:hisnotes/services/auth/bloc/auth_bloc.dart';
import 'package:hisnotes/services/auth/bloc/auth_event.dart';
import 'package:hisnotes/services/cloud/cloud_note.dart';
import 'package:hisnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:hisnotes/utilities/dialogs/create_account_dialog.dart';
import 'package:hisnotes/utilities/dialogs/delete_dialog.dart';
import 'package:hisnotes/utilities/dialogs/logout_dialog.dart';

class GuestNoteView extends StatefulWidget {
  const GuestNoteView({super.key});

  @override
  State<GuestNoteView> createState() => _GuestNoteViewState();
}

class _GuestNoteViewState extends State<GuestNoteView> {
  List<CloudNote> templateNotes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Your Notes:'),
          backgroundColor: appBarColor,
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final decision = await showCreateAccountDialog(context);
                  if (decision) {
                    context.read<AuthBloc>().add(AuthEventShouldRegister());
                  }
                }),
          ]),
      body: const Opacity(
          opacity: 0.7,
          child: Center(
              child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Text('Your notes will appear here after creating them!'),
          ))),
    );
  }
}
