import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3/model/exam.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nanoid/nanoid.dart';

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class NovElement extends StatefulWidget {
  final Function addNewExam;
  final User user;

  const NovElement({Key? key, required this.addNewExam, required this.user})
      : super(key: key);

  @override
  State<NovElement> createState() => _NovElementState();
}

class _NovElementState extends State<NovElement> {
  final nameController = TextEditingController();
  final sesijaController = TextEditingController();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.user.email!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.purple[800]),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Predmet"),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: sesijaController,
            decoration: const InputDecoration(labelText: "Sesija"),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 15),
          Text(
            "Datum: ",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.purple[800],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
          Expanded(
            child: TableCalendar(
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
                });
              },
              shouldFillViewport: true,
            ),
          ),
          TextButton(onPressed: submitData, child: const Text("Додади")),
        ],
      ),
    );
  }

  void submitData() {
    if (nameController.text.isEmpty || sesijaController.text.isEmpty) {
      return;
    }
    widget.addNewExam(Exam(
        id: nanoid(5),
        predmet: nameController.text,
        sesija: sesijaController.text,
        dateTime: _selectedDay,
        userId: widget.user.uid));
    Navigator.of(context).pop();
  }
}
