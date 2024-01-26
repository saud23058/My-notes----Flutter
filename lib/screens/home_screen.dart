import 'package:flutter/material.dart';
import 'package:my_notes/screens/login_screen.dart';
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
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
          }, icon:const Icon(Icons.logout,color: Colors.black,)),
        ],
      ),
    );
  }
}
