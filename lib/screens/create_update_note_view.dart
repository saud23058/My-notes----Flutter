import 'package:flutter/material.dart';
import 'package:my_notes/services/CRUD/note_services.dart';
import 'package:my_notes/services/auth_services.dart';
import 'package:my_notes/utiles/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNotes? _note;
  late final NotesServices _notesServices;
  late final TextEditingController _textController;

  @override
  initState(){
    _notesServices=NotesServices();
    _textController=TextEditingController();
    super.initState();
  }

  void _textControllerListener()async{
    final note=_note;
    if(note==null){
      return;
    }
    final text=_textController.text;
    await _notesServices.updatesNotes(note: note, text: text);
  }

  void _setupTextControllerListener(){
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNotes> createOrGetExistingNote(BuildContext context) async {

    final widgetNote=context.getArgument<DatabaseNotes>();
    if(widgetNote!=null){
      _note=widgetNote;
      _textController.text=widgetNote.text;
      return widgetNote;
    }
    final existingNote=_note;
    if(existingNote != null){
      return existingNote;
    }
    final currentUser=AuthServices.firebase().currentUser!;
    final email=currentUser.email;
    final owner = await _notesServices.getUser(email:email.toString());
    final newNote= await _notesServices.createNotes(owner: owner);
    _note=newNote;
    return newNote;
  }
  void _deleteNoteIfTextIsEmpty(){
    final note=_note;
    if(_textController.text.isEmpty && note !=null){
      _notesServices.deleteNote(id: note.id);
    }
  }

  Future<void> saveNoteIfTextIsNotEmpty() async {
    final note=_note;
    final text=_textController.text;
    if(note!=null && text.isNotEmpty){
      await _notesServices.updatesNotes(note: note, text: text);
    }
  }
  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note'),),
      body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.done:
                _note=snapshot.data ;
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'enter notes'
                  ),

                );
              default:
                return const CircularProgressIndicator();
            }
          }
      )
    );
  }
}
