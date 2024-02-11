import 'package:flutter/material.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import '../utiles/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final NoteCallback onDeleteNote;
  final Iterable<CloudNote> notes;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.onDeleteNote,
    required this.notes,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete != null && shouldDelete) {
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