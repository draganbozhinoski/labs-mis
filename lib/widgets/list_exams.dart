import '../model/exam.dart';
import 'package:flutter/material.dart';

class ListExams extends StatelessWidget {
  final List<Exam> selectedExams;
  const ListExams({Key? key,required this.selectedExams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: selectedExams.length,
      itemBuilder: (cnt, index) {
        return Container(
          margin:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(25)),
          child: ListTile(
            title: Text(selectedExams[index].predmet),
            subtitle: Text(selectedExams[index].sesija),
          ),
        );
      },
    );
  }
}
