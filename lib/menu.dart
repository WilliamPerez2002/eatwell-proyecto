import 'package:eatwell/herramientas/conexion.dart';
import 'package:flutter/material.dart';
import 'herramientas/components.dart';

class MyMenu extends StatefulWidget {
  final conexion_Mysql conexion;

  MyMenu({Key? key, required this.conexion}) : super(key: key);

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  conexion_Mysql get conexion => widget.conexion;

  @override
  Widget build(BuildContext context) {
    final MyArguments args =
        ModalRoute.of(context)!.settings.arguments as MyArguments;

    final Map<String, dynamic>? data = args.datos;
    final List<DataPoint> imc = args.imc;

    return WillPopScope(
      onWillPop: () async {
        // Evitar el retroceso automático

        return false;
      },
      child: Nav(
        conexion: conexion,
        datos: data,
        dataPoints: imc,
      ),
    );
  }
}
