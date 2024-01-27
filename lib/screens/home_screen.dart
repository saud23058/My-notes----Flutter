import 'package:flutter/material.dart';
import 'package:my_notes/routes/routes.dart';
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
           Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
         }, icon: const Icon(Icons.logout))
       ],
      ),
    );
  }
}
