import 'package:flutter/material.dart';

import 'herramientas/components.dart';
import 'herramientas/conexion.dart';

class IMCPage extends StatefulWidget {
  final conexion_Mysql? conexion;
  final Map<String, dynamic>? data;

  const IMCPage({super.key, required this.conexion, required this.data});

  @override
  State<IMCPage> createState() => _IMCPageState();
}

class _IMCPageState extends State<IMCPage> {
  conexion_Mysql? get conexion => widget.conexion;
  Map<String, dynamic>? get data => widget.data;

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
                                    text: "",
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
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
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
}
