import 'dart:async';
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
      var results = await connection.query('select * from USUARIOS');

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
      var results = await connection.query('select $columna from USUARIOS');

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
      return true;
    } catch (e) {
      print('Error querying MySQL: $e');
      return false;
    }
  }
}



/*
Future main() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'sql9.freesqldatabase.com',
      port: 3306,
      user: 'sql9623690',
      db: 'sql9623690',
      password: 'PMI7FfYFf8'));

  await conn.query(
      'CREATE TABLE amigos (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name varchar(255), email varchar(255), age int)');

  var result = await conn.query(
      'insert into amigos (name, email, age) values (?, ?, ?)',
      ['Bob', 'bob@bob.com', 25]);
  print('Inserted row id=${result.insertId}');

  var results = await conn.query(
      'select name, email, age from users where id = ?', [result.insertId]);
  for (var row in results) {
    print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  }

  // Update some data
  await conn.query('update users set age=? where name=?', [26, 'Bob']);

  // Query again database using a parameterized query
  var results2 = await conn.query(
      'select name, email, age from users where id = ?', [result.insertId]);
  for (var row in results2) {
    print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
  }

  // Finally, close the connection
  await conn.close();
}
  */
