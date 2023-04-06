// Home page screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String username = currentUser?.displayName ?? 'unknown';
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,

          // on appbar text containing 'GEEKS FOR GEEKS'
          title: Text("Today"),
        ),

        // In body text containing 'Home page ' in center
        body: Center(
          child: Text('Welcome $username'),
        ));
  }
}
