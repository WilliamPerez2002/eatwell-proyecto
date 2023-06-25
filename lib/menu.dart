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
  var data;
  String? nombreUser;
  String? id;

  @override
  Widget build(BuildContext context) {
    // Obtener los argumentos enviados desde la pantalla anterior
    data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    id = data!['id'];
    nombreUser = data!['nombre'];

    return WillPopScope(
      onWillPop: () async {
        // Evitar el retroceso automático
        print(id! + nombreUser!);
        conexion.datos(id!);
        return false;
      },
      child: Nav(
        conexion: conexion,
        datos: data,
      ),
    );
  }
}
