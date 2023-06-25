import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class conexion_Mysql {
  static String host = 'sql9.freesqldatabase.com',
      user = 'sql9627390',
      password = 'zlz2f7cWFN',
      db = 'sql9627390';
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
      rethrow;
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

  Future<String?> nombreUser(String email) async {
    try {
      await initialize();

      var results = await connection.query(
          'select NOM_USU from USUARIOS where EMA_USU = ?', [email.trim()]);

      connection.close();
      return results.elementAt(0)[0];
    } catch (e) {
      print('Error querying MySQL: $e');
      return null;
    }
  }

  Future<String?> columnaUser(String user, String columna) async {
    try {
      await initialize();

      var usuario = await connection.query(
          'select $columna from USUARIOS where ID_USU = ?', [user.trim()]);

      connection.close();
      print(usuario.elementAt(0)[0]);
      return usuario.elementAt(0)[0].toString();
    } catch (e) {
      print('Error querying MySQL: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> datos(String user) async {
    String? nombre = await columnaUser(user, 'NOM_USU');
    String? apellido = await columnaUser(user, 'APE_USU');
    String? contrasena = await columnaUser(user, 'CONT_USU');
    String? fechaNac = await columnaUser(user, 'FEC_NAC_USU');
    String? email = await columnaUser(user, 'EMA_USU');

    try {
      await initialize();

      var results = await connection.query(
          "SELECT FEC_REG, IMC FROM IMC_DETALLE WHERE ID_USU = ? ORDER BY FEC_REG DESC LIMIT 1;",
          [user.trim()]);

      connection.close();

      DateFormat fecha = DateFormat('yyyy-MM-dd');
      String formattedDate = fecha.format(results.elementAt(0)[0]);
      String imc = results.elementAt(0)[1].toString();
      String nacimiento = fecha.format(DateTime.parse(fechaNac!));

      Map<String, dynamic>? datosObtenidos = {
        "nombre": nombre,
        "apellido": apellido,
        "fecha_nacimiento": nacimiento,
        "fecha": formattedDate,
        "imc": imc,
        "id": user,
        "email": email,
        "contrasena": contrasena
      };

      print(formattedDate);
      print(imc);

      return datosObtenidos;
    } catch (e) {
      print('Error querying MySQL: $e');
      return null;
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
    await initialize();

    DateTime date = DateTime.now();
    final fecha = DateFormat('yyyy-MM-dd').format(date);

    DateTime fechaNacimiento = DateFormat('dd/MM/yyyy').parse(fechaNac);
    String fechaFormateada = DateFormat('yyyy-MM-dd').format(fechaNacimiento);
    print(fechaFormateada);

    //ERROR
    await connection.query(
        "insert into USUARIOS values (?, ?, ?, STR_TO_DATE(?, '%Y-%m-%d') , ?, ?)",
        [nombreUsuario, email, contrasena, fechaFormateada, nombre, apellido]);

    await connection.query('insert into IMC_DETALLE values (?, ?, ?, ?, ?)', [
      nombreUsuario,
      fecha,
      estatura,
      peso,
      (peso / ((estatura / 100) * (estatura / 100)))
    ]);

    connection.close();
    return true;
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromRGBO(255, 71, 70, 1.0),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: const Row(
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

  Future<bool> cambiarContrasena(String contrasena, String email) async {
    try {
      await initialize();
      await connection.query(
          'UPDATE USUARIOS set CONT_USU = ? WHERE EMA_USU = ?',
          [contrasena, email]);
      connection.close();
      return true;
    } catch (e) {
      print('Error querying MySQL: $e');
      return false;
    }
  }

  Future<bool> actualizarContrasena(
      BuildContext context, String nueva, String user) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    bool dat = await actCont(nueva, user);

    hideLoadingDialog(context);

    return dat;
  }

  Future<bool> actCont(String nueva, String user) async {
    try {
      await initialize();

      await connection.query(
          'UPDATE USUARIOS set CONT_USU = ? WHERE ID_USU = ?', [nueva, user]);

      connection.close();

      return true;
    } catch (e) {
      print('Error querying MySQL: $e');
      return false;
    }
  }
}
