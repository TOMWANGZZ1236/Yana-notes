import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hisnotes/services/cloud/cloud_note.dart';
import 'package:hisnotes/services/cloud/cloud_service_constants.dart';
import 'package:hisnotes/services/crud/crud_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('note');
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
        documentId: fetchedNote.id, ownerUserId: ownerUserId, text: '');
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDelete();
    }
  }

  Future<void> deleteAllNote({required String owneruserId}) async {
    try {
      var snapshots =
          await notes.where(ownerUserIdFieldName, isEqualTo: owneruserId).get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw CouldNotDelete();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNote();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String owneruserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: owneruserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapShot(doc)));

    return allNotes;
  }
}
