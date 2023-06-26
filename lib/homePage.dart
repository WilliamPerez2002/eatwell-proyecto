// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'herramientas/components.dart';
import 'herramientas/conexion.dart';

class HomePage extends StatefulWidget {
  final conexion_Mysql? conexion;
  final Map<String, dynamic>? data;

  HomePage({Key? key, required this.conexion, required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  conexion_Mysql? get conexion => widget.conexion;
  Map<String, dynamic>? get data => widget.data;
  Map<String, dynamic>? newData;

  void actualizarDatos(Map<String, dynamic> nuevosDatos) {
    setState(() {
      newData = nuevosDatos;
    });
  }

  String elegirHora() {
    var now = DateTime.now();
    var formattedTime = DateFormat.H().format(now);

    if (int.parse(formattedTime) >= 5 && int.parse(formattedTime) <= 12) {
      return 'Buenos días';
    } else if (int.parse(formattedTime) >= 13 &&
        int.parse(formattedTime) <= 19) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  String elegirImagen() {
    var now = DateTime.now();
    var formattedTime = DateFormat.H().format(now);

    if (int.parse(formattedTime) >= 5 && int.parse(formattedTime) <= 12) {
      return "assets/dias.png";
    } else if (int.parse(formattedTime) >= 13 &&
        int.parse(formattedTime) <= 19) {
      return "assets/tarde.png";
    } else {
      return "assets/noche2.png";
    }
  }

  String fechaIMC() {
    DateTime fecha = DateFormat('yyyy-MM-dd').parse(data!["fecha"]);
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);
    print("Fecha: $fechaFormateada");
    return fechaFormateada;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 1,
                    margin: const EdgeInsets.only(top: 1),
                    child: ImageComponent(
                      imagePath: 'assets/pageHome.png',
                      topMargin: 0.03,
                      leftMargin: 19,
                      rightMargin: 19,
                      widthSize: 2.90,
                      heightSize: 2.35,
                    ),
                  ),
                  ImageComponent(
                    imagePath: 'assets/ensalada.png',
                    topMargin: 0.14,
                    leftMargin: 299,
                    rightMargin: 19,
                    widthSize: 0.12,
                    heightSize: 0.18,
                  ),
                  WelcomeComponent(
                      title: '${elegirHora()}, ${data!["nombre"]}!',
                      topMargin: 0.15,
                      leftMargin: 29.62,
                      alignment: Alignment.centerLeft,
                      color: Colors.white),
                  ImageComponent(
                    imagePath: elegirImagen(),
                    topMargin: 0.33,
                    leftMargin: 75,
                    rightMargin: 19,
                    widthSize: 0.60,
                    heightSize: 0.18,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              // Add more widgets here
              Cards(
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width * 0.90,
                color: Colores.rosa,
                elevation: 20,
                children: [
                  WelcomeComponent(
                      title: "IMC",
                      topMargin: 0.03,
                      leftMargin: 10,
                      alignment: Alignment.center,
                      color: Colors.white),
                  ImageComponent(
                    imagePath: 'assets/vegetales.png',
                    topMargin: 0.015,
                    leftMargin: 25,
                    rightMargin: 19,
                    widthSize: 0.50,
                    heightSize: 0.15,
                  ),

                  SizedBox(height: 20),

                  Cards(
                    children: [
                      SizedBox(height: 10),
                      Textos(
                          text: "Este es tu ultimo IMC:",
                          size: 24,
                          color: Colors.white,
                          bold: false,
                          decoration: TextDecoration.none,
                          height: 1,
                          letterSpacing: 0.5),
                      SizedBox(height: 15),
                      Textos(
                          text: data!['imc'],
                          size: 84,
                          color: Colores.verde,
                          bold: true,
                          decoration: TextDecoration.none,
                          height: 1,
                          letterSpacing: 0.5),
                      SizedBox(height: 20),
                      Textos(
                          text: "Fecha: ${fechaIMC()}",
                          size: 24,
                          color: Colors.white,
                          bold: true,
                          decoration: TextDecoration.none,
                          height: 1,
                          letterSpacing: 0.5)
                    ],
                    width: 300,
                    height: 190,
                    color: Colores.rosa,
                    elevation: 10,
                  )

                  // Agrega más widgets aquí según tus necesidades
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              // Add more widgets here
              Cards(
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width * 0.90,
                color: Colores.rosa,
                elevation: 20,
                children: const [
                  WelcomeComponent(
                      title: "IMC",
                      topMargin: 0.03,
                      leftMargin: 10,
                      alignment: Alignment.center,
                      color: Colors.white),
                  ImageComponent(
                    imagePath: 'assets/vegetales.png',
                    topMargin: 0.015,
                    leftMargin: 25,
                    rightMargin: 19,
                    widthSize: 0.50,
                    heightSize: 0.15,
                  ),

                  SizedBox(height: 20),

                  Cards(
                    children: [
                      SizedBox(height: 10),
                      Textos(
                          text: "Este es tu ultimo IMC:",
                          size: 24,
                          color: Colors.white,
                          bold: false,
                          decoration: TextDecoration.none,
                          height: 1,
                          letterSpacing: 0.5),
                      SizedBox(height: 15),
                      Textos(
                          text: "25.5",
                          size: 84,
                          color: Color.fromRGBO(146, 181, 95, 1.0),
                          bold: true,
                          decoration: TextDecoration.none,
                          height: 1,
                          letterSpacing: 0.5),
                      SizedBox(height: 20),
                      Textos(
                          text: "Fecha: 12/12/2021",
                          size: 24,
                          color: Colors.white,
                          bold: true,
                          decoration: TextDecoration.none,
                          height: 1,
                          letterSpacing: 0.5)
                    ],
                    width: 300,
                    height: 190,
                    color: Color.fromRGBO(204, 56, 56, 1.0),
                    elevation: 10,
                  )

                  // Agrega más widgets aquí según tus necesidades
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
