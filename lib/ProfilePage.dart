// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'herramientas/components.dart';
import 'herramientas/conexion.dart';

class ProfilePage extends StatefulWidget {
  final conexion_Mysql? conexion;
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) actualizarDatos;

  const ProfilePage(
      {super.key,
      required this.conexion,
      required this.data,
      required this.actualizarDatos});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  conexion_Mysql? get conexion => widget.conexion;
  Map<String, dynamic>? get data => widget.data;

  TextEditingController antiguaController = TextEditingController();
  TextEditingController nuevaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  int edad() {
    DateFormat dateFormat;
    DateTime nacimiento;

    if (data!["fecha_nacimiento"].contains("/")) {
      dateFormat = DateFormat('dd/MM/yyyy');
      nacimiento = dateFormat.parse(data!["fecha_nacimiento"]);
    } else {
      dateFormat = DateFormat('yyyy-MM-dd');
      nacimiento = dateFormat.parse(data!["fecha_nacimiento"]);
    }

    var now = DateTime.now();

    Duration diferencia = nacimiento.difference(now);
    int diferenciaEnDias = diferencia.inDays.abs();

    return diferenciaEnDias ~/ 365;
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colores.rosa,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Colores.morado,
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

  Future<bool> cerrarSesionDialog(BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    bool dat = await cerrarSesion();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);

    return dat;
  }

  Future<bool> cerrarSesion() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('nombre');
      print('Datos borrados');
      return true;
    } catch (e) {
      print('Error al borrar datos');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Stack(
                children: [
                  Cards(
                    height: MediaQuery.of(context).size.height * 1.50,
                    width: MediaQuery.of(context).size.width * 0.95,
                    color: Colores.morado,
                    elevation: 20,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Cards(
                        color: Colors.white,
                        height: 280,
                        width: 280,
                        elevation: 10,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      Colores.amarillo, // Color de los bordes
                                  width: 2.0, // Grosor de los bordes
                                ),
                              ),
                              child: ClipOval(
                                child: ImageComponent(
                                  imagePath: 'assets/hambre.png',
                                  topMargin: 0.006,
                                  leftMargin: 0,
                                  rightMargin: 0,
                                  widthSize: 0.40,
                                  heightSize: 0.25,
                                ),
                              )),
                          Textos(
                              text: data!["id"],
                              size: 30,
                              color: Colores.morado,
                              bold: true,
                              decoration: TextDecoration.none,
                              height: 1,
                              letterSpacing: 0.5),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Cards(
                        color: Colors.white,
                        height: 260,
                        width: 330,
                        elevation: 10,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 50),
                            child: Row(
                              children: [
                                Textos(
                                    text: "Información",
                                    size: 30,
                                    color: Colores.morado,
                                    bold: true,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                                SizedBox(
                                  width: 20,
                                ),
                                ImageComponent(
                                  imagePath: 'assets/cv.png',
                                  topMargin: 0,
                                  leftMargin: 0,
                                  rightMargin: 0,
                                  widthSize: 0.10,
                                  heightSize: 0.10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 280, // Altura de la línea
                            color: Colores.amarillo, // Color de la línea
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 22),
                            child: Row(
                              children: [
                                Textos(
                                    text: "Nombre: ",
                                    size: 20,
                                    color: Colores.morado,
                                    bold: true,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                                SizedBox(
                                  width: 23,
                                ),
                                Textos(
                                    text: "${data!["nombre"]}",
                                    size: 20,
                                    color: Colores.morado,
                                    bold: false,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 22),
                            child: Row(
                              children: [
                                Textos(
                                    text: "Apellido: ",
                                    size: 20,
                                    color: Colores.morado,
                                    bold: true,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                                SizedBox(
                                  width: 20,
                                ),
                                Textos(
                                    text: "${data!["apellido"]}",
                                    size: 20,
                                    color: Colores.morado,
                                    bold: false,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 22),
                            child: Row(
                              children: [
                                Textos(
                                    text: "Edad: ",
                                    size: 20,
                                    color: Colores.morado,
                                    bold: true,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                                SizedBox(
                                  width: 55,
                                ),
                                Textos(
                                    text: "${edad()}",
                                    size: 20,
                                    color: Colores.morado,
                                    bold: false,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 22, right: 22),
                            child: Row(
                              children: [
                                Textos(
                                    text: "Email: ",
                                    size: 20,
                                    color: Colores.morado,
                                    bold: true,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                                SizedBox(
                                  width: 49,
                                ),
                                Flexible(
                                  child: Textos(
                                      text: "${data!["email"]}",
                                      size: 20,
                                      color: Colores.morado,
                                      bold: false,
                                      decoration: TextDecoration.none,
                                      height: 1,
                                      letterSpacing: 0.5),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Cards(
                        color: Colors.white,
                        height: 390,
                        width: 330,
                        elevation: 10,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 50),
                            child: Row(
                              children: [
                                Textos(
                                    text: "Contraseña",
                                    size: 30,
                                    color: Colores.morado,
                                    bold: true,
                                    decoration: TextDecoration.none,
                                    height: 1,
                                    letterSpacing: 0.5),
                                SizedBox(
                                  width: 20,
                                ),
                                ImageComponent(
                                  imagePath: 'assets/seguro.png',
                                  topMargin: 0,
                                  leftMargin: 0,
                                  rightMargin: 0,
                                  widthSize: 0.10,
                                  heightSize: 0.10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 280, // Altura de la línea
                            color: Colores.amarillo, // Color de la línea
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 22, right: 22),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: antiguaController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Por favor ingrese una contraseña';
                                        }

                                        if (value != data!["contrasena"]) {
                                          return 'La contraseña no es correcta';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña actual',
                                        labelStyle: TextStyle(
                                          color: Colores.morado,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colores.morado),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      controller: nuevaController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Por favor ingrese una contraseña';
                                        }

                                        if (value.length < 8) {
                                          return 'La contraseña debe tener al menos 6 caracteres';
                                        }

                                        if (value == antiguaController.text) {
                                          return 'La contraseña nueva debe ser diferente a la actual';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Contraseña nueva',
                                        labelStyle: TextStyle(
                                          color: Colores.morado,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colores.morado),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Center(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colores.amarillo),
                                              elevation: MaterialStateProperty
                                                  .all<double>(10),
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                print("ENTRO");

                                                if (await actualizarContrasena()) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => ExitoDialog(
                                                        text:
                                                            'se cambió la contraseña.'),
                                                    barrierDismissible: false,
                                                  );
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) => ErrorDialog(
                                                        text:
                                                            'no se pudo cambiar la contraseña.'),
                                                    barrierDismissible: false,
                                                  );
                                                }
                                              }
                                            },
                                            child: Text("Cambiar contraseña"))),
                                  ],
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                          child: Container(
                        height: 50,
                        width: 300,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colores.amarillo),
                              elevation: MaterialStateProperty.all<double>(10),
                            ),
                            onPressed: () async {
                              if (await cerrarSesionDialog(context)) {
                                Navigator.pushNamed(context, 'login');
                              }
                            },
                            child: Textos(
                                text: "Cerrar sesión",
                                size: 20,
                                color: Colors.white,
                                bold: true,
                                decoration: TextDecoration.none,
                                height: 1,
                                letterSpacing: 1)),
                      )),
                    ],
                  ),
                ],
              ),

              // Add more widgets here
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> actualizarContrasena() async {
    var conf = await conexion!.actualizarContrasena(
        context, nuevaController.text.trim(), data!["id"]);

    nuevaController.clear();
    antiguaController.clear();
    return conf;
  }
}
