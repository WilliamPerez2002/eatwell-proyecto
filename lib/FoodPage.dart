import 'package:flutter/material.dart';

import 'herramientas/components.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageComponent(
          imagePath: 'assets/trabajo.png',
          topMargin: 0.006,
          leftMargin: 15,
          rightMargin: 10,
          widthSize: 0.9,
          heightSize: 0.70,
        ),
      ],
    ));
  }
}
