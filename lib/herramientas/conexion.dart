import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

class conexion_Mysql {
  static String host = 'sql10.freesqldatabase.com',
      user = 'sql10625378',
      password = 'tajGtRKkPM',
      db = 'sql10625378';
  static int port = 3306;

  late MySqlConnection connection;

  Future<void> initialize() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );

    try {
      connection = await MySqlConnection.connect(settings);
      print('Connected to MySQL');
    } catch (e) {
      print('Error connecting to MySQL: $e');
      throw e;
    }
  }

  Future<bool> existeUsuario(String usuario, String contrasena) async {
    try {
      await initialize();

      var results = await connection.query('select * from USUARIOS');

      connection.close();

      if (results.isNotEmpty) {
        for (var row in results) {
          if (usuario == row[0] && contrasena == row[2]) {
            return true;
          }
          print('Name: ${row[0]}, Contrasena: ${row[2]}');
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error querying MySQL: $e');
      return false;
    }
  }

  Future<bool> existe(String valor, String columna) async {
    try {
      await initialize();

      var results = await connection.query('select $columna from USUARIOS');

      connection.close();

      if (results.isNotEmpty) {
        for (var row in results) {
          if (valor == row[0]) {
            return true;
          }
        }
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error querying MySQL: $e');
      return false;
    }
  }

  Future<bool> ingreso(
      String nombreUsuario,
      String email,
      String contrasena,
      String fechaNac,
      String nombre,
      String apellido,
      int estatura,
      double peso) async {
    try {
      await initialize();

      await connection.query(
          'insert into USUARIOS values (?, ?, ?, STR_TO_DATE(?,"%d/%m/%Y"), ?, ?, ?, ?)',
          [
            nombreUsuario,
            email,
            contrasena,
            fechaNac,
            nombre,
            apellido,
            estatura,
            peso
          ]);

      connection.close();
      return true;
    } catch (e) {
      print('Error querying MySQL: $e');
      return false;
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Color.fromRGBO(75, 68, 82, 1.0),
                ),
                SizedBox(width: 20),
                Text('Cargando...'),
              ],
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<bool> existeSQL(
      BuildContext context, String valor, String columna) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    bool dat = await existe(valor, columna);

    hideLoadingDialog(context);

    return dat;
  }
}
