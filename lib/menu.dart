import 'package:flutter/material.dart';

class menu extends StatefulWidget {
  const menu({super.key});

  @override
  State<menu> createState() => _menuState();
}

class _menuState extends State<menu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: const Color.fromRGBO(255, 71, 70, 1.0),
            appBar: AppBar(
              title: const Text('Menu'),
              backgroundColor: Colors.white,
            ),
            body: const Center(
              child: Text('Hello Worlsd'),
            )));
  }
}
