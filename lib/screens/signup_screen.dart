import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/screens/login_screen.dart';

import 'home_screen.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final email= TextEditingController();
  final password= TextEditingController();
  void dispose(){
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void signup()async{
    setState(() {
      loading =true;
    });
    FirebaseAuth _auth = FirebaseAuth.instance;
    try{
      await _auth.createUserWithEmailAndPassword(
          email: email.text.toString(),
          password: password.text.toString()).then((value){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
      });
    }on FirebaseAuth catch(e){
      setState(() {
        loading =false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Center(child: Text('Sign up')),
     ),
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
          ),const SizedBox(height: 20),
          TextButton(onPressed: (){
            signup();
          }, child:loading?CircularProgressIndicator(): Text('sign up')),
          const SizedBox(height: 20),
          TextButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>const LoginScreen()));
          }, child: const Text("Already have an account"))
        ],
        ),
      ),
    );
  }
}
