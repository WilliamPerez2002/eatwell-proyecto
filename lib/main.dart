import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatwell/register.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'herramientas/components.dart';
import 'herramientas/conexion.dart';
import 'login.dart';
import 'menu.dart';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    final firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference = firestore.collection('Alimentos');

    QuerySnapshot querySnapshot = await collectionReference.get();

    List<Map<String, dynamic>> alimentos = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        data['id'] = doc.id;

        alimentos.add(data);
      }
    });

    CollectionReference collectionReferenceUsers =
        firestore.collection('Alimentacion');

    await conexion.initialize();

    Logger logger = Logger();

    logger.d('Iniciando la aplicación...');

    String inicial = 'login';

    String? id = await getData();

    bool pasar = true;

    print(id);

    MyArguments? argumentos;

    if (id != null) {
      inicial = 'menuPrincipal';

      Map<String, dynamic>? datos = await conexion.datos(id.trim());

      List<DataPoint> imc = await conexion.getDatosIMC(id.trim());

      DateTime myDate = DateTime.now();

      // Utiliza la clase DateFormat para formatear la fecha
      String formattedDate = DateFormat('dd/MM/yyyy').format(myDate);

      QuerySnapshot querySnapshotA = await collectionReferenceUsers
          .where('USUARIO', isEqualTo: id)
          .where('FECHA_INGRESO', isEqualTo: formattedDate)
          .get();

      List<Map<String, dynamic>> alimentosConsumidos = [];
      querySnapshotA.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          print(data['USUARIO'] + " FUNCIONA " + data['FECHA_INGRESO']);
          data['id'] = doc.id;
          alimentosConsumidos.add(data);
        }
      });

      alimentosConsumidos.forEach((element) {
        print("HOLA SOY ELEMENTO CONSUMIDO");
        print(element);
      });

      argumentos = MyArguments(datos!, imc, alimentos, alimentosConsumidos);

      pasar = imc.isNotEmpty && datos.isNotEmpty && alimentos.isNotEmpty;

      print(pasar);
    }

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
                content: Text("No hay conexion, reinicie la app"),
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
              content: Text("No hay conexion, reinicie la app"),
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
