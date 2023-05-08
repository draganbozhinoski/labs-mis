import 'package:flutter/material.dart';
import 'package:lab3/main.dart';
import 'package:lab3/pages/login_register_page.dart';
import 'package:lab3/auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChages,
      builder: (context,snapshot) {
        if(snapshot.hasData) {
          return const ExamsApp();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
