import 'package:flutter/material.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        const Text("Food Page"),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back"))
      ],
    ));
  }
}
