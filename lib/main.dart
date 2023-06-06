import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3/widgets/list_exams.dart';
import 'package:lab3/widgets/nov_element.dart';
import 'auth.dart';
import 'model/exam.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lab3/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/notification_service.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: WidgetTree(),
  ));
}

class ExamsApp extends StatefulWidget {
  const ExamsApp({Key? key}) : super(key: key);

  @override
  State<ExamsApp> createState() => _ExamsAppState();
}

class _ExamsAppState extends State<ExamsApp> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final User? user = Auth().currentUser!;
  final cron = Cron();
  late final LocalNotificationService service;
  static int increment = 0;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  static List<Exam> selectedExams = [];
  static List<Exam> exams = [];

  @override
  void initState() {
    _selectedDay = _focusedDay;
    selectedExams = _getExamsForDay(DateTime.now(),user!);
    service = LocalNotificationService();
    service.intialize();
    startCron();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Exams App"),
        backgroundColor: Colors.purple[900],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => addExam(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: kToday,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(outsideDaysVisible: false),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                selectedExams = _getExamsForDay(_selectedDay,user!);
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return _getExamsForDay(day,user!);
            },
          ),
          const SizedBox(height: 10.0),
          const Divider(
            height: 2,
            color: Colors.purple,
            thickness: 2,
          ),
          ListExams(selectedExams: selectedExams),
        ],
      ),
    );
  }

  List<Exam> _getExamsForDay(DateTime date,User user) {
    return exams
        .where((exam) =>
            exam.dateTime.day == date.day &&
            exam.dateTime.month == date.month &&
            exam.dateTime.year == date.year && exam.userId == user.uid)
        .toList();
  }

  void addExam(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NovElement(
              addNewExam: addNewExam,
              user: user!
            ),
          );
        });
  }

  void addNewExam(Exam exam) {
    setState(() {
      exams.add(exam);
    });
  }
  void startCron() async {
    cron.schedule(Schedule.parse("0 * * * *"), () => sendNotification());
  }
  sendNotification() async {
    await service.showNotification(
        id: increment++,
        title: 'Exams',
        body: 'Maybe there are new exams, please check the calendar!');
  }
}
