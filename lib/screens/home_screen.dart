import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/screens/login_screen.dart';
import 'package:my_notes/utiles/menu_action.dart';
import 'dart:developer' as devtools show log;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Home'),automaticallyImplyLeading: false,
       actions: [
         PopupMenuButton<MenuAction>(
             onSelected:(value)async{
               switch(value)
             {
                 case MenuAction.logout:
                   final shouldLogOut= await showDialoge(context);
                   if(shouldLogOut){
                     await FirebaseAuth.instance.signOut();
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                   }
               }

               },
             itemBuilder: (context){
           return const [
             PopupMenuItem<MenuAction>(
                 child:Text('Log out')
             )
           ];
         })
       ],
      ),
    );
  }
}


Future<bool> showDialoge(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to Sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Sign out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
