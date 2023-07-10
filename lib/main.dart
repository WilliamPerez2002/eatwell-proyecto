import 'dart:io';

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

  try {
    // ignore: unused_local_variable
    final conexion = conexion_Mysql();

    await conexion.initialize();

    Logger logger = Logger();

    logger.d('Iniciando la aplicación...');

    String inicial = 'login';

    String? id = await getData();

    bool pasar = false;

    print(id);

    MyArguments? argumentos;

    if (id != null) {
      inicial = 'menuPrincipal';

      Map<String, dynamic>? datos = await conexion.datos(id.trim());

      List<DataPoint> imc = await conexion.getDatosIMC(id.trim());

      argumentos = MyArguments(datos!, imc);

      pasar = imc.isNotEmpty && datos.isNotEmpty;

      print("datos ${datos} imc ${imc}");
    }

    print(pasar);

    if (pasar) {
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
            return MyMenu(conexion: conexion);
          },
          'menuPrincipal': (context) {
            logger.i('Navegando a la pantalla de menú...');
            return MyMenu(conexion: conexion, arg: argumentos);
          },
        },
      ));
    } else {
      logger.i('No hay datos para mostrar');
      runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            color: Colores.rosa,
            child: Center(
              child: AlertDialog(
                title: Text('Error!'),
                content: Text("No hay internet, reinicie la app"),
                actions: <Widget>[
                  TextButton(
                    onPressed: _exitApp,
                    child: Text('Aceptar',
                        style: TextStyle(color: Colores.morado)),
                  ),
                ],
                elevation: 54.0,
              ),
            ),
          ),
        ),
      ));
    }
  } catch (e) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colores.rosa,
          child: Center(
            child: AlertDialog(
              title: Text('Error!'),
              content: Text("No hay internet, reinicie la app"),
              actions: <Widget>[
                TextButton(
                  onPressed: _exitApp,
                  child:
                      Text('Aceptar', style: TextStyle(color: Colores.morado)),
                ),
              ],
              elevation: 54.0,
            ),
          ),
        ),
      ),
    ));
  }
}

Future<String?> getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = await prefs.getString('nombre');
  print("${stringValue} este es el valor");
  return stringValue;
}

Future<void> _exitApp() async {
  if (Platform.isAndroid) {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  } else if (Platform.isIOS) {
    exit(0);
  }
}
