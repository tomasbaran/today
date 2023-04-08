import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  const TaskCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          // width: 350,
          height: 40,
          child: Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '#list',
                style: TextStyle(color: Color.fromARGB(255, 228, 9, 9)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
