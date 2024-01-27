import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/routes/routes.dart';
class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Verification'),),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text("we've sent you an verification. Please open it to verify your account"),
            const Text("If you haven't received an verfification email yet, press the button below"),
            TextButton(onPressed:() async{
              final user= FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
                child: const Text('Send verification code ')),
            TextButton(onPressed:() async{
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(signupRoute, (route) => false);
                          },
                child: const Text('Restart')),

          ],
        ),
      ),


    );

  }
}
