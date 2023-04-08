// Home page screen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:today/services/calendar_service.dart';
import 'package:today/widgets/task_card.dart';

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

    // CalendarService().showTasksOnADate(DateTime.now());

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.green,
          centerTitle: true,

          // on appbar text containing 'GEEKS FOR GEEKS'
          title: Text("Today"),
        ),

        // In body text containing 'Home page ' in center
        body: Center(
          child: Column(
            children: [
              Text('Welcome $username'),
              const SizedBox(height: 32),
              TaskCard(title: 'First task'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Event event = Event(); // Create object of event
                  event.summary = 'summaryText'; //Setting summary of object

                  EventDateTime start = new EventDateTime(); //Setting start time
                  start.dateTime = DateTime.now();
                  start.timeZone = "GMT+05:00";
                  event.start = start;

                  EventDateTime end = new EventDateTime(); //setting end time
                  end.timeZone = "GMT+05:00";
                  end.dateTime = DateTime(2023, 4, 6, 20, 00);
                  event.end = end;

                  // CalendarService().addEvent();
                },
                child: const Text('Add Event'),
              ),
            ],
          ),
        ));
  }
}
