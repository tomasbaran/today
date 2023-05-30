import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:today/screens/tasks_screen/tasks_screen.dart';
import 'package:today/services/auth.dart';
import 'package:today/services/service_locator.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupGetIt();

// initializing the firebase app
  await Firebase.initializeApp();

  // DEV-MODE:
  // check whether the user is signed in
  if (Auth().uid == null) {
    log(
      time: DateTime.now(),
      '${DateTime.now().minute}:${DateTime.now().second} NOT signed in',
    );
  } else {
    log(
      time: DateTime.now(),
      'signed in',
    );
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
      // home: Auth().uid == null ? LoginScreen() : const TasksScreen(),
      // onGenerateRoute (instead of home) is necessary for the showCupertinoModalBottomSheet to animate and shrink the background when adding a new task
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialWithModalsPageRoute(
              builder: (_) => Auth().uid == null ? LoginScreen() : const TasksScreen(),
              settings: settings,
            );
        }
      },
    );
  }
}
