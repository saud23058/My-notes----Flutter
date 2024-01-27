import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/screens/home_screen.dart';
import 'package:my_notes/screens/signup_screen.dart';
import '../Error_Handling/error_dialoge.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final  email= TextEditingController();
  final password= TextEditingController();
  bool loading=false;
  void dispose(){
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() async {
    setState(() {
      loading = true;
    });
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.text.toString(),
        password: password.text.toString(),
      );
      // If login is successful, navigate to the HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle different Firebase authentication errors
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'User not found';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password';
      } else {
        // Handle other Firebase authentication errors
        errorMessage = 'An error occurred: ${e.message}';
      }
      // Show error dialog
      showErrorDialog(context, errorMessage);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Center(child: Text('Login')),automaticallyImplyLeading: false,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
                hintText: 'email'
            ),
          ),
          const SizedBox(height: 30,),
          TextFormField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
                hintText: 'password',
            ),
          ),
          const SizedBox(height: 20),
          TextButton(onPressed: (){
            login();
          }, child:loading?const CircularProgressIndicator():const Text('Login')),
          const SizedBox(height: 10),
          TextButton(onPressed: (){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const SignupScreen()));
          }, child: const Text("Don't have an account"))
        ],
        ),
      ),
    );
  }
}


