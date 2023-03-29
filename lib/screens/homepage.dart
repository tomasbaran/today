// Home page screen

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,

          // on appbar text containing 'GEEKS FOR GEEKS'
          title: Text("GEEKS FOR GEEKS"),
        ),

        // In body text containing 'Home page ' in center
        body: Center(
          child: Text('Home page'),
        ));
  }
}
