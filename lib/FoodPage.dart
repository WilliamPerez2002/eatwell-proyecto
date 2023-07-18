// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'herramientas/components.dart';

class FoodPage extends StatefulWidget {
  final List<Map<String, dynamic>>? alimentos;
  final Function(List<Map<String, dynamic>> alimentos) actualizarAlimentos;
  List<Map<String, dynamic>>? alimentosConsumidos;
  final Map<String, dynamic>? datos;

  FoodPage(
      {super.key,
      required this.alimentos,
      required this.actualizarAlimentos,
      this.alimentosConsumidos,
      this.datos});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  var tamanoCardFondo = 2.55;
  var tamanoCard = 0.55;
  int num = 0;
  Map<String, elementoAlimento> widgetsList = <String, elementoAlimento>{};
  List<Map<String, dynamic>>? get alimentos => widget.alimentos;
  List<Map<String, dynamic>>? get alimentosConsumidos =>
      widget.alimentosConsumidos;
  List<Map<String, dynamic>> alimentosC = [];

  int cantidad = 1;

  static const List<String> error = [
    "No Data",
  ];

  static const List<String> categorias = [
    "Categorias",
    "Fruta",
    "Grano",
    "Bebida",
    "Grasa",
    "Proteina",
    "Verdura",
    "Lacteo"
  ];

  String categoriaSeleccionada = categorias[0];

  List<String> alimentosSeleccionados = error;
  String alimentoSelec = error[0];

  void borrarAlimentoIndice(String borrar, String nombre) async {
    await eliminarDocumento(borrar);
    print(nombre);
    widgetsList.remove(nombre);
    widget.alimentosConsumidos
        ?.removeWhere((element) => element["NOMBRE"] == nombre);

    List<Map<String, dynamic>>? nuevo = await updateFirebase(context);

    setState(() {
      widget.alimentosConsumidos = nuevo;
    });

    //widgetsList
  }

  String elegirImagen(categoria) {
    if (categoria == categorias[1]) {
      return "assets/frutas.png";
    } else if (categoria == categorias[2]) {
      return "assets/cereal.png";
    } else if (categoria == categorias[3]) {
      return "assets/refresco.png";
    } else if (categoria == categorias[4]) {
      return "assets/mantequilla.png";
    } else if (categoria == categorias[5]) {
      return "assets/proteina.png";
    } else if (categoria == categorias[6]) {
      return "assets/verduras.png";
    } else if (categoria == categorias[7]) {
      return "assets/productos-lacteos.png";
    }
    return "assets/dieta.png";
  }

  Future<void> agregarAlimentosdeBD() async {
    alimentosConsumidos?.forEach((element) {
      setState(() {
        widgetsList.addAll(<String, elementoAlimento>{
          element["NOMBRE"]: elementoAlimento(
            cantidad: element["CANTIDAD"],
            nombreAlimento: element["NOMBRE"],
            borrarAlimento: borrarAlimentoIndice,
            img: elegirImagen(
              element["CATEGORIA"],
            ),
            isVisibility: false,
            tamanoElement: 61,
            hora: element["HORA"],
            icono: Icons.arrow_drop_down_rounded,
            id: element["id"],
          )
        });
      });
    });
  }

  Future<List<Map<String, dynamic>>?> actualizarAlimentos() async {
    final firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference =
        firestore.collection('Alimentacion');

    DateTime myDate = DateTime.now();

    // Utiliza la clase DateFormat para formatear la fecha
    String formattedDate = DateFormat('dd/MM/yyyy').format(myDate);

    QuerySnapshot querySnapshotA = await collectionReference
        .where('USUARIO', isEqualTo: widget.datos!['id'])
        .where('FECHA_INGRESO', isEqualTo: formattedDate)
        .get();

    querySnapshotA.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        print(data['USUARIO'] + " FUNCIONA " + data['FECHA_INGRESO']);
        data['id'] = doc.id;
        alimentosC.add(data);
      }
    });

    alimentosC.forEach((element) {
      print(element['NOMBRE']);
    });

    widget.actualizarAlimentos(alimentosC);
    return alimentosC;
  }

  String valorInicio(String categoria) {
    alimentos?.forEach((element) {
      if (element["Categorias"].contains(categoria)) {
        alimentosSeleccionados.add(element["Nombre"]);
      }
    });

    if (alimentosSeleccionados.isNotEmpty) {
      return alimentosSeleccionados[0];
    } else {
      return "No Data";
    }
  }

  void valor(String categoria) {
    alimentosSeleccionados = [];
    alimentos?.forEach((element) {
      if (element["Categorias"].contains(categoria)) {
        print(element["Nombre"]);
        alimentosSeleccionados.add(element["Nombre"]);
      }
    });

    if (alimentosSeleccionados.isNotEmpty) {
      alimentoSelec = alimentosSeleccionados[0];
    } else {
      alimentosSeleccionados = error;
      alimentoSelec = "No Data";
    }
  }

  @override
  Widget build(BuildContext context) {
    alimentosConsumidos?.forEach((element) {
      print(element["NOMBRE"]);
    });
    print("NUEVA VUELTA");

    if (alimentosC.isNotEmpty) {
      widget.alimentosConsumidos = alimentosC;
    }
    agregarAlimentosdeBD();
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Expanded(
            child: Stack(
              children: [
                Cards(
                  height: MediaQuery.of(context).size.height * tamanoCardFondo,
                  width: MediaQuery.of(context).size.width * 0.95,
                  color: Colores.verde,
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
                                  text: "ALIMENTOS",
                                  size: 40,
                                  color: Colores.morado,
                                  bold: true,
                                  decoration: TextDecoration.none,
                                  height: 1.3,
                                  letterSpacing: 1),
                              const SizedBox(
                                width: 5,
                              ),
                              const ImageComponent(
                                imagePath: 'assets/dieta-equilibrada.png',
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
                          color: Colores.morado, // Color de la línea
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Cards(
                      color: Colors.white,
                      height: 490,
                      width: 330,
                      elevation: 10,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Textos(
                                  text: "Agregar Alimentos",
                                  size: 30,
                                  color: Colores.morado,
                                  bold: true,
                                  decoration: TextDecoration.none,
                                  height: 1,
                                  letterSpacing: 0.5),
                              SizedBox(
                                width: 5,
                              ),
                              ImageComponent(
                                imagePath: 'assets/plato.png',
                                topMargin: 0,
                                leftMargin: 0,
                                rightMargin: 0,
                                widthSize: 0.11,
                                heightSize: 0.10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          width: 280, // Altura de la línea
                          color: Colores.morado, // Color de la línea
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 2, right: 2),
                          child: Form(
                              child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colores.morado, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colores.morado,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                width: 280,
                                height: 40,
                                child: DropdownButton(
                                  value: categoriaSeleccionada,
                                  icon:
                                      const Icon(Icons.arrow_drop_down_rounded),
                                  isExpanded: true,
                                  elevation: 26,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontFamily: 'lato'),
                                  borderRadius: BorderRadius.circular(10),
                                  dropdownColor: Colores.morado,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.white,
                                  ),
                                  items: categorias.map((String items) {
                                    return DropdownMenuItem(
                                        value: items, child: Text(items));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      categoriaSeleccionada = value.toString();
                                      valor(categoriaSeleccionada);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colores.morado, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colores.morado,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                width: 280,
                                height: 40,
                                child: DropdownButton(
                                  value: alimentoSelec,
                                  icon:
                                      const Icon(Icons.arrow_drop_down_rounded),
                                  isExpanded: true,
                                  elevation: 26,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontFamily: 'lato'),
                                  borderRadius: BorderRadius.circular(10),
                                  dropdownColor: Colores.morado,
                                  underline: Container(
                                    height: 2,
                                    color: Colors.white,
                                  ),
                                  items: alimentosSeleccionados
                                      .map((String items) {
                                    return DropdownMenuItem(
                                        value: items, child: Text(items));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      alimentoSelec = value.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colores.morado, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colores.morado,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  width: 280,
                                  height: 50,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Cantidad:",
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontFamily: 'Lato',
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height: 25,
                                          width: 20,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text('$cantidad',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'Lato',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  cantidad++;
                                                });
                                              },
                                              child: Icon(
                                                Icons.arrow_drop_up_rounded,
                                                color: Colores.verde,
                                              ),
                                            ),
                                            SizedBox.shrink(),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (cantidad > 1) {
                                                    cantidad--;
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.arrow_drop_down_rounded,
                                                color: Colores.verde,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "vasos",
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontFamily: 'Lato',
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colores.verde),
                                        elevation:
                                            MaterialStateProperty.all<double>(
                                                10),
                                      ),
                                      onPressed: () async {
                                        if (alimentoSelec == "No Data") {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Seleccione un alimento"),
                                            backgroundColor: Colores.morado,
                                            duration: Duration(seconds: 2),
                                          ));
                                          return;
                                        } else if (existe()) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "El alimento ya fue registrado"),
                                            backgroundColor: Colores.morado,
                                            duration: Duration(seconds: 2),
                                          ));
                                          return;
                                        }
                                        List<Map<String, dynamic>>? nuevo =
                                            await insertarFirebase(context);

                                        setState(() {
                                          widget.alimentosConsumidos = nuevo!;
                                        });
                                      },
                                      child: Text("Registrar alimento",
                                          style: TextStyle(
                                              fontSize: 19,
                                              fontFamily: 'Lato',
                                              color: Colors.white)))),
                            ],
                          )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Cards(
                      color: Colors.white,
                      height: 550,
                      width: 330,
                      elevation: 10,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Textos(
                                  text: "Alimentos",
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
                                imagePath: 'assets/quitar.png',
                                topMargin: 0,
                                leftMargin: 0,
                                rightMargin: 0,
                                widthSize: 0.11,
                                heightSize: 0.10,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.0,
                          width: 280, // Altura de la línea
                          color: Colores.morado, // Color de la línea
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 10),
                          child: Row(children: [
                            Text(
                              "Fecha: ${date()}",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Lato',
                                color: Colores.morado,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 380,
                            width: 300,
                            child:
                                //COMPONENTE QUE VA A ESTAR SOLO
                                ListView.builder(
                              itemCount: widgetsList.length,
                              itemBuilder: (context, index) {
                                final List<elementoAlimento> elementos =
                                    widgetsList.values.toList();

                                // Aquí puedes utilizar la lista 'elementos' para construir los widgets elementoAlimento
                                return elementos[index];
                              },
                            )

                            //TERMINA
                            ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> guardarBD() async {
    try {
      DateTime myDate = DateTime.now();

      // Utiliza la clase DateFormat para formatear la fecha
      String formattedDate = DateFormat('dd/MM/yyyy').format(myDate);

      Map<String, dynamic> registro = {
        "CANTIDAD": cantidad,
        "FECHA_INGRESO": formattedDate,
        "HORA": obtenerHora24(),
        "NOMBRE": alimentoSelec,
        "USUARIO": widget.datos?["id"],
        "CATEGORIA": categoriaSeleccionada
      };

      await FirebaseFirestore.instance.collection("Alimentacion").add(registro);
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  String obtenerHora24() {
    // Obtiene la fecha y hora actual
    DateTime now = DateTime.now();

    // Formatea la hora en formato de 24 horas
    String formattedHour = DateFormat('HH:mm').format(now);

    return formattedHour;
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colores.verde,
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

  Future<List<Map<String, dynamic>>?> insertarFirebase(
      BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    await guardarBD();

    List<Map<String, dynamic>>? rsp = await actualizarAlimentos();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);
    return rsp;
  }

  Future<List<Map<String, dynamic>>?> updateFirebase(
      BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    List<Map<String, dynamic>>? rsp = await actualizarAlimentos();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);
    return rsp;
  }

  bool existe() {
    for (var i = 0; i < widget.alimentosConsumidos!.length; i++) {
      if (widget.alimentosConsumidos?[i]["NOMBRE"] == alimentoSelec) {
        return true;
      }
    }
    return false;
  }

  Future<void> eliminarDocumento(String id) async {
    try {
      var referenciaDocumento =
          FirebaseFirestore.instance.collection('Alimentacion').doc(id);

      // Eliminar el documento de Firestore
      await referenciaDocumento.delete();

      // Aquí puedes continuar con el flujo de trabajo después de eliminar el documento
      print('Documento eliminado exitosamente');
      // ... otras acciones que deseas realizar después de eliminar el documento ...
    } catch (e) {
      print('Error al eliminar el documento: $e');
      // Manejo de errores, si es necesario
    }
  }

  String date() {
    DateTime myDate = DateTime.now();

    // Utiliza la clase DateFormat para formatear la fecha
    String formattedDate = DateFormat('dd/MM/yyyy').format(myDate);
    return formattedDate;
  }
}
