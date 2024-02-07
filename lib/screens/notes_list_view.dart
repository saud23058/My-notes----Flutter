import 'package:flutter/material.dart';
import '../services/CRUD/note_services.dart';
import '../utiles/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNotes note);

class NotesListView extends StatelessWidget {
  final DeleteNoteCallback onDeleteNote;
  final List<DatabaseNotes> notes;

  const NotesListView({
    Key? key,
    required this.onDeleteNote,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
             final shouldDelete=await showDeleteDialog(context);
             if(shouldDelete){
               onDeleteNote(note); // Call onDeleteNote callback with the note
             }
            },
            icon: Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
