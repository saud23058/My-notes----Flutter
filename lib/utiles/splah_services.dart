import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class SplashServices{
  void islog(BuildContext context){
    final _auth= FirebaseAuth.instance.currentUser;
    if(_auth!=null){
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const HomeScreen()));
      });

    }
    else{
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>const LoginScreen()));
    }
  }
}