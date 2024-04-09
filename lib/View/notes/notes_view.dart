import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisnotes/View/notes/note_list_view.dart';
import 'package:hisnotes/constants/colors.dart';
import 'package:hisnotes/constants/routes.dart';
import 'package:hisnotes/enums/menu_action.dart';
import 'package:hisnotes/services/auth/auth_service.dart';
import 'package:hisnotes/services/auth/bloc/auth_bloc.dart';
import 'package:hisnotes/services/auth/bloc/auth_event.dart';
import 'package:hisnotes/services/cloud/cloud_note.dart';
import 'package:hisnotes/services/cloud/firebase_cloud_storage.dart';
import 'package:hisnotes/utilities/dialogs/delete_dialog.dart';
import 'package:hisnotes/utilities/dialogs/logout_dialog.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes:'),
          backgroundColor: appBarColor,
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                }),
            PopupMenuButton<MenuItems>(
              onSelected: (value) async {
                switch (value) {
                  case MenuItems.logout:
                    final choice = await showLogOutDialog(context);
                    if (choice) {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    }

                  case MenuItems.delete:
                    final choice = await showDeleteDialog(context);
                    if (choice) {
                      context.read<AuthBloc>().add(
                            const AuthEventDeleteUser(),
                          );
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuItems>(
                      value: MenuItems.logout, child: Text('logout')),
                  PopupMenuItem<MenuItems>(
                      value: MenuItems.delete, child: Text('Delete User'))
                ];
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: StreamBuilder(
            stream: _notesService.allNotes(owneruserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allNotes = snapshot.data as Iterable<CloudNote>;
                    return NotesListView(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(
                            documentId: note.documentId);
                      },
                      onTap: (CloudNote note) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments: note,
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                default:
                  return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
