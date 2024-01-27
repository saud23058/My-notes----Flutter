import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/routes/routes.dart';


class SplashServices{
  void islog(BuildContext context){
    final auth= FirebaseAuth.instance.currentUser;
    if(auth!=null){
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
      });

    }
    else{
      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
    }
  }
}