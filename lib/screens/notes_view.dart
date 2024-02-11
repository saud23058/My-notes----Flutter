import 'package:flutter/material.dart';
import 'package:my_notes/routes/routes.dart';
import 'package:my_notes/screens/notes_list_view.dart';
import 'package:my_notes/services/auth_services.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesServices;
  String get userId => AuthServices.firebase().currentUser!.id;

  @override
  void initState() {
    _notesServices = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesServices.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  onDeleteNote: (note) async {
                    await _notesServices.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note){
                    Navigator.of(context).pushNamed(createUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                  notes: allNotes,
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      )
    );
  }
}
