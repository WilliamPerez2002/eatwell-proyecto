import 'package:eatwell/register.dart';
import 'package:flutter/material.dart';
import 'herramientas/components.dart';
import 'herramientas/conexion.dart';
import 'login.dart';
import 'menu.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // ignore: unused_local_variable
  final conexion = conexion_Mysql();

  await conexion.initialize();

  Logger logger = Logger();

  logger.d('Iniciando la aplicación...');

  String inicial = 'login';

  String? id = await getData();

  MyArguments? argumentos;

  if (id != null) {
    inicial = 'menu';

    Map<String, dynamic>? datos = await conexion.datos(id.trim());

    List<DataPoint> imc = await conexion.getDatosIMC(id.trim());

    argumentos = MyArguments(datos!, imc);
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: inicial,
    routes: {
      'login': (context) {
        logger.i('Navegando a la pantalla de login...');

        return MyLogin(conexion: conexion);
      },
      'register': (context) {
        logger.i('Navegando a la pantalla de registro...');

        return MyRegister(
          conexion: conexion,
        );
      },
      'menu': (context) {
        logger.i('Navegando a la pantalla de menú...');
        return MyMenu(conexion: conexion, arg: argumentos);
      }
    },
  ));
}

Future<String?> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = await prefs.getString('nombre');
  print("${stringValue} este es el valor");
  return stringValue;
}
