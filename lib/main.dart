// main.dart file
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:today/screens/tasks_screen/tasks_screen.dart';
import 'package:today/services/service_locator.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();

// initializing the firebase app
  await Firebase.initializeApp();

  // DEV-MODE:
  if (FirebaseAuth.instance.currentUser != null) {
    // check whether the user is signed in
    log(
      time: DateTime.now(),
      'signed in',
    );
  } else {
    log(time: DateTime.now(), '${DateTime.now().minute}:${DateTime.now().second} NOT signed in');
  }
  // FirebaseAuth.instance.signOut();

  runApp(const TodayApp());
}

class TodayApp extends StatelessWidget {
  const TodayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today',
      home: FirebaseAuth.instance.currentUser == null ? LoginScreen() : TasksScreen(date: DateTime.now()),
    );
  }
}
