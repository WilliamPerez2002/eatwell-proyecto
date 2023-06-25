import 'package:eatwell/register.dart';
import 'package:flutter/material.dart';
import 'herramientas/conexion.dart';
import 'login.dart';
import 'menu.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
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

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
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
        return MyMenu(conexion: conexion);
      }
    },
  ));
}
