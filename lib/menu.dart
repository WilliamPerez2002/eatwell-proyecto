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
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Menu'),
              backgroundColor: const Color.fromRGBO(255, 71, 70, 1.0),
            ),
            body: const Center(
              child: Text('Hello Worlsd'),
            )));
  }
}
