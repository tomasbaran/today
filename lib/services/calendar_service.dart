import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/tasks/v1.dart';

class CalendarService {
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[CalendarApi.calendarScope, TasksApi.tasksScope],
  );

  showTasksOnADate(DateTime date) async {
    print('date: $date');

    var httpClient = (await googleSignIn.authenticatedClient())!;
    var calendarApi = CalendarApi(httpClient);
    Event event = Event();

    var _calendar = await calendarApi.calendarList.get('primary');
    print(_calendar.summary);

    var algo2 = await calendarApi.events.list('tomas@ambee.app');

    if (algo2 != null) {
      print('length: ${algo2.summary}: ${algo2.items?.length}');
      for (event in algo2.items!) {
        // print('${event.start?.dateTime}: ${event.summary}');
        if ((event.start?.dateTime?.day == DateTime.now().day) &&
            (event.start?.dateTime?.month == DateTime.now().month) &&
            (event.start?.dateTime?.year == DateTime.now().year)) {
          print('TODAY:[${event.start?.dateTime?.toLocal().hour}:${event.start?.dateTime?.toLocal().minute}]${event.summary}');
        }
      }
    }
    var taskApi = TasksApi(httpClient);
    // var taskLists = await taskApi.tasks.list(tasklist);
    // print(taskLists);
    // print('taskList: ${taskLists.items?.first.title}');
    var tasks = await taskApi.tasks.list('MDgwNTI1MzE5Njg0OTU4NzczMzc6MDow', showHidden: true);
    print('tasks: ${tasks.items?.length}');

    if (tasks != null) {
      for (var task in tasks.items!) {
        print('${task.kind}: ${task.due}: ${task.completed} ${task.title}');
        // if ((task.due. .start?.dateTime?.day == DateTime.now().day) &&
        //     (event.start?.dateTime?.month == DateTime.now().month) &&
        //     (event.start?.dateTime?.year == DateTime.now().year)) {
        //   print('TODAY:[${event.start?.dateTime?.toLocal().hour}:${event.start?.dateTime?.toLocal().minute}]${event.summary}');
        // }
      }
    }
  }

  addEvent() async {
    await googleSignIn.signInSilently();

    var httpClient = (await googleSignIn.authenticatedClient())!;
    var calendarApi = CalendarApi(httpClient);

    Event event = Event(); // Create object of event
    event.summary = 'summaryText'; //Setting summary of object

    EventDateTime start = EventDateTime(); //Setting start time
    start.dateTime = DateTime.now();
    start.timeZone = "GMT+05:00";
    event.start = start;

    EventDateTime end = EventDateTime(); //setting end time
    end.timeZone = "GMT+05:00";
    end.dateTime = DateTime(2023, 4, 7, 2, 00);
    event.end = end;

    // var algo = await calendarApi.events.insert(Event(summary: 'serus', start: start, end: end), "primary");
    // print(algo.created);
  }
}
