import 'package:eatwell/herramientas/conexion.dart';
import 'package:flutter/material.dart';
import 'herramientas/components.dart';

class MyMenu extends StatefulWidget {
  final conexion_Mysql conexion;
  MyArguments? arg;

  MyMenu({Key? key, required this.conexion, this.arg}) : super(key: key);

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  conexion_Mysql get conexion => widget.conexion;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data;
    final List<DataPoint> imc;
    final List<Map<String, dynamic>>? alimentos;
    final List<Map<String, dynamic>>? alimentosConsumidos;

    print("${widget.arg?.datos} ARGUMENTOS");

    if (widget.arg == null) {
      final MyArguments args =
          ModalRoute.of(context)!.settings.arguments as MyArguments;
      data = args.datos;
      imc = args.imc;
      alimentos = args.alimentos;
      alimentosConsumidos = args.alimentosConsumidos;
    } else {
      data = widget.arg!.datos;
      imc = widget.arg!.imc;
      alimentos = widget.arg!.alimentos;
      alimentosConsumidos = widget.arg!.alimentosConsumidos;
      widget.arg = null;
      print("${widget.arg} ARGUMENTOS DENUEVO ");
    }

    return WillPopScope(
      onWillPop: () async {
        // Evitar el retroceso automático

        return false;
      },
      child: Nav(
        conexion: conexion,
        datos: data,
        dataPoints: imc,
        alimentos: alimentos,
        alimentosConsumidos: alimentosConsumidos,
      ),
    );
  }
}
