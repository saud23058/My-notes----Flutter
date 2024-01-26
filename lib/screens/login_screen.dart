import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/screens/home_screen.dart';
import 'package:my_notes/screens/signup_screen.dart';
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

  void login()async{
    setState(() {
      loading=true;
    });
    FirebaseAuth _auth = FirebaseAuth.instance;
    try{
      await _auth.signInWithEmailAndPassword(email: email.text.toString(), password: password.text.toString()).then((value){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      });
    }on FirebaseAuth catch(e){
      setState(() {
        loading=false;
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
            Navigator.push(context,MaterialPageRoute(builder: (context)=>const SignupScreen()));
          }, child: const Text("Don't have an account"))
        ],
        ),
      ),
    );
  }
}
