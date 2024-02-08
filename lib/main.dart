import 'package:flutter/material.dart';
import 'package:my_notes/routes/routes.dart';
import 'package:my_notes/screens/notes_view.dart';
import 'package:my_notes/screens/login_screen.dart';
import 'package:my_notes/screens/create_update_note_view.dart';
import 'package:my_notes/screens/signup_screen.dart';
import 'package:my_notes/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_notes/screens/verify_email.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme:const AppBarTheme(backgroundColor: Colors.teal) ),
      home:const SplashScreen() ,
      routes: {
        loginRoute:(context)=>const LoginScreen(),
        signupRoute:(context)=>const SignupScreen(),
        homeRoute:(context)=>const NotesView(),
        verifyEmailRoute:(context)=>const VerifyEmail(),
        createUpdateNoteRoute:(context)=>const CreateUpdateNoteView()
      },
    );
  }
}
