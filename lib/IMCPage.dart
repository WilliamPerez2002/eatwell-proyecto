// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'herramientas/components.dart';
import 'herramientas/conexion.dart';

class IMCPage extends StatefulWidget {
  final conexion_Mysql? conexion;
  final Map<String, dynamic>? data;
  final Function(Map<String, dynamic>) actualizarDatos;

  const IMCPage(
      {super.key,
      required this.conexion,
      required this.data,
      required this.actualizarDatos});

  @override
  State<IMCPage> createState() => _IMCPageState();
}

class _IMCPageState extends State<IMCPage> {
  conexion_Mysql? get conexion => widget.conexion;
  Map<String, dynamic>? get data => widget.data;
  Function(Map<String, dynamic>) get actualizarDatos => widget.actualizarDatos;

  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController inicioController = TextEditingController();
  TextEditingController finalController = TextEditingController();

  Future<void> actualizarDatosEnPagina() async {
    Map<String, dynamic>? nuevosDatos =
        await conexion!.datosEspera(context, data!["id"]);

    actualizarDatos(nuevosDatos!);
  }

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

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
                    height: MediaQuery.of(context).size.height * 1.90,
                    width: MediaQuery.of(context).size.width * 0.95,
                    color: Colores.celeste,
                    elevation: 20,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Cards(
                        color: Colors.white,
                        height: 110,
                        width: 330,
                        elevation: 10,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Textos(
                                    text: "IMC",
                                    size: 40,
                                    color: Colores.morado,
                                    bold: true,
                                    decoration: TextDecoration.none,
                                    height: 1.3,
                                    letterSpacing: 1),
                                const SizedBox(
                                  width: 20,
                                ),
                                const ImageComponent(
                                  imagePath: 'assets/imc.png',
                                  topMargin: 0,
                                  leftMargin: 0,
                                  rightMargin: 0,
                                  widthSize: 0.14,
                                  heightSize: 0.10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 1.0,
                            width: 280, // Altura de la línea
                            color: Colores.rosa, // Color de la línea
                          ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Textos(
                                    text: "Agregar IMC",
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
                                  imagePath: 'assets/agregar.png',
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
                            color: Colores.rosa, // Color de la línea
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 82, right: 82),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: alturaController,
                                      obscureText: false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Por favor ingrese su altura';
                                        }
                                        if (value
                                            .trim()
                                            .contains(RegExp(r'[a-zA-Z]'))) {
                                          return 'No se permiten letras';
                                        }

                                        if (value
                                            .trim()
                                            .contains(RegExp(r'[^0-9]'))) {
                                          return 'Solo se permiten números enteros';
                                        }

                                        if (int.parse(value.trim()) < 60) {
                                          return 'Estatura muy pequeña';
                                        }

                                        if (int.parse(value.trim()) > 250) {
                                          return 'Estatura muy grande';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Altura (cm)',
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
                                      controller: pesoController,
                                      obscureText: false,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Por favor ingrese su peso';
                                        }
                                        if (value
                                            .trim()
                                            .contains(RegExp(r'[a-zA-Z]'))) {
                                          return 'No se permiten letras';
                                        }

                                        if (double.parse(value.trim()) >
                                            590.00) {
                                          return 'Peso muy alto';
                                        }

                                        if (double.parse(value.trim()) <
                                            10.00) {
                                          return 'Peso muy bajo';
                                        }

                                        RegExp regex =
                                            RegExp(r'^\d+(\.\d{1,2})?$');

                                        if (!regex.hasMatch(value.trim())) {
                                          return 'Ingrese un peso válido con hasta 2 decimales';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Peso (kg)',
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
                                                      Color>(Colores.rosa),
                                              elevation: MaterialStateProperty
                                                  .all<double>(10),
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                int pasar =
                                                    await ingresoNuevoIMC();

                                                if (pasar == 1) {
                                                  await actualizarDatosEnPagina();

                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) => ExitoDialog(
                                                        text:
                                                            'se ingreso el nuevo IMC.'),
                                                    barrierDismissible: false,
                                                  );
                                                } else if (pasar == -1) {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) => ErrorDialog(
                                                        text:
                                                            'No puedes ingresar el IMC mas de una vez al dia .'),
                                                    barrierDismissible: false,
                                                  );
                                                } else {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (_) => ErrorDialog(
                                                        text:
                                                            'no se pudo ingresar.'),
                                                    barrierDismissible: false,
                                                  );
                                                }
                                              }
                                            },
                                            child: Text("Guardar IMC"))),
                                  ],
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Cards(
                        color: Colors.white,
                        height: 790,
                        width: 330,
                        elevation: 10,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Textos(
                                    text: "Histograma IMC",
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
                                  imagePath: 'assets/histograma.png',
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
                            color: Colores.rosa, // Color de la línea
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 12, right: 12),
                            child: Form(
                                key: _formKey2,
                                child: Column(
                                  children: [
                                    TextFormFieldsDateIMC(
                                        hintText: "Fecha Inicio",
                                        controller: inicioController,
                                        validacion: 7),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormFieldsDateIMC(
                                        hintText: "Fecha Fin",
                                        controller: finalController,
                                        validacion: 7),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Center(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colores.rosa),
                                              elevation: MaterialStateProperty
                                                  .all<double>(10),
                                            ),
                                            onPressed: () async {
                                              if (_formKey2.currentState!
                                                  .validate()) {
                                                //AQUI VA A IR EL METODO QUE VA A DIBUJAR EL HISTOGRAMA
                                              }
                                            },
                                            child: Text("Dibujar"))),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      child: GraficoIMC(),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> ingresoNuevoIMC() async {
    return await conexion!.ingresarNuevoIMC(
        context,
        data!["id"],
        int.parse(alturaController.text.trim()),
        double.parse(pesoController.text.trim()));
  }
}
