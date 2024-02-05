import 'package:flutter/material.dart';
import 'package:my_notes/routes/routes.dart';
import 'package:my_notes/services/CRUD/note_services.dart';
import 'package:my_notes/services/auth_services.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NotesServices _notesServices;
  String get userEmail=>AuthServices.firebase().currentUser!.email!;

  @override
  void initState(){
 _notesServices=NotesServices();
 super.initState();
  }

  void dispose(){
    _notesServices.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Home'),automaticallyImplyLeading: false,
       actions: [
         IconButton(onPressed: (){
           Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
         }, icon: const Icon(Icons.logout))
       ],
      ),
      body: FutureBuilder(
        future: _notesServices.getOrCreateUser(email: userEmail),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesServices.allNotes,
                  builder: (context,snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                        return const Text('waiting for all notes');
                      default:
                        return const CircularProgressIndicator();
                    }
                  }
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
