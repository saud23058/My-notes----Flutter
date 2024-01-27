import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/Error_Handling/error_dialoge.dart';
import 'package:my_notes/routes/routes.dart';
import 'package:my_notes/screens/login_screen.dart';
import 'package:my_notes/screens/verify_email.dart';
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
      // loading =true;
    });
    FirebaseAuth _auth = FirebaseAuth.instance;
    try{
      await _auth.createUserWithEmailAndPassword(
          email: email.text.toString(),
          password: password.text.toString());
      final user= FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      Navigator.push(context, MaterialPageRoute(builder:(context)=>VerifyEmail() ));
    }on FirebaseAuthException catch(e){
      String errormessage;
      if(e.code=='email-already-in-use'){
        errormessage='Email already used in another account';
      }else if(e.code=='weak-passward'){
        errormessage='Weak Passward';
      }else{
        errormessage= 'Error occurred : ${e.code}';
      }
      showErrorDialog(context, errormessage);
    }finally{
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
          }, child:loading?const CircularProgressIndicator(): const Text('sign up')),
          const SizedBox(height: 20),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
          }, child: const Text("Already have an account"))
        ],
        ),
      ),
    );
  }
}
