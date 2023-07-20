// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously, void_checks
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'herramientas/components.dart';

class FoodPage extends StatefulWidget {
  List<Map<String, dynamic>>? alimentos;
  final Function(List<Map<String, dynamic>> alimentosConsumidos,
      List<Map<String, dynamic>> alimentos) actualizarAlimentos;
  List<Map<String, dynamic>>? alimentosConsumidos;
  final Map<String, dynamic>? datos;

  FoodPage(
      {super.key,
      required this.alimentos,
      required this.actualizarAlimentos,
      required this.alimentosConsumidos,
      required this.datos});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  var tamanoCardFondo = 4.9;
  var tamanoCard = 0.55;
  int num = 0;
  Map<String, elementoAlimento> widgetsList = <String, elementoAlimento>{};
  Map<String, elementoAlimentoBuscar> widgetsListBuscar =
      <String, elementoAlimentoBuscar>{};

  List<Map<String, dynamic>>? get alimentos => widget.alimentos;
  List<Map<String, dynamic>>? get alimentosConsumidos =>
      widget.alimentosConsumidos;
  List<Map<String, dynamic>>? alimentosRecuperados;

  Function(List<Map<String, dynamic>>, List<Map<String, dynamic>>)
      get actualizarDatos => widget.actualizarAlimentos;
  List<Map<String, dynamic>> alimentosC = [];

  final _formKey2 = GlobalKey<FormState>();
  int cantidad = 1;
  String fechainicial = "";
  String fechafinal = "";
  var mostrarDatos = false;
  double tamanoCardDatos = 200;
  String botonDato = 'Mostrar datos';
  List<AlimentoConsumido> listaDatosAlimentos = [
    AlimentoConsumido(nombre: "", calorias: 0)
  ];

  TextEditingController inicioController = TextEditingController();
  TextEditingController finalController = TextEditingController();

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

  List<double> listaR = [];
  List<double> listaB = [];

  List<double> rellenarListaC(alimentosCon) {
    List<double> lista = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    try {
      print("ENTRE A LA LISTA");
      alimentosCon!.forEach((element) {
        if (element["CATEGORIA"].contains('Fruta')) {
          lista[0] += element["CANTIDAD"] * 1;
        }

        if (element["CATEGORIA"].contains('Grano')) {
          lista[1] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Bebida')) {
          lista[2] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Grasa')) {
          lista[3] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Proteina')) {
          lista[4] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Verdura')) {
          lista[5] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Lacteo')) {
          lista[6] += element["CANTIDAD"] * 1;
        }
      });
      listaR = lista;

      print("FINAL");
      lista.forEach((element) {
        print(element);
      });
    } catch (e) {
      print("$e guardardatos");
    }
    return lista;
  }

  List<double> rellenarListaB(alimentosCon) {
    List<double> lista = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

    try {
      print("ENTRE A LA LISTA");
      alimentosCon!.forEach((element) {
        if (element["CATEGORIA"].contains('Fruta')) {
          lista[0] += element["CANTIDAD"] * 1;
        }

        if (element["CATEGORIA"].contains('Grano')) {
          lista[1] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Bebida')) {
          lista[2] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Grasa')) {
          lista[3] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Proteina')) {
          lista[4] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Verdura')) {
          lista[5] += element["CANTIDAD"] * 1;
        }
        if (element["CATEGORIA"].contains('Lacteo')) {
          lista[6] += element["CANTIDAD"] * 1;
        }
      });
      listaB = lista;

      print("FINAL");
      lista.forEach((element) {
        print(element);
      });
    } catch (e) {
      print("$e guardardatos");
    }
    return lista;
  }

  String categoriaSeleccionada = categorias[0];

  List<String> alimentosSeleccionados = error;
  String alimentoSelec = error[0];

  void borrarAlimentoIndice(String borrar, String nombre) async {
    await eliminarDocumento(borrar);
    widgetsList.remove(nombre);
    widget.alimentosConsumidos
        ?.removeWhere((element) => element["NOMBRE"] == nombre);

    List<Map<String, dynamic>>? nuevo = await updateFirebase(context);

    setState(() {
      widget.alimentosConsumidos = [];
      widget.alimentosConsumidos = nuevo;
    });

    //widgetsList
  }

  void actualizarA(int cantidad, String id) async {
    try {
      // Accede a la instancia de Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Accede al documento del usuario en la colección "usuarios"
      DocumentReference userRef = firestore.collection('Alimentacion').doc(id);

      // Actualiza el campo "nombre" con el nuevo valor
      await userRef.update({
        'CANTIDAD': cantidad,
      });

      List<Map<String, dynamic>>? dato = await updateFirebase(context);

      setState(() {
        widget.alimentosConsumidos = dato;
        alimentosC = dato!;
      });

      print('Datos actualizados con éxito.');
    } catch (e) {
      print('Error al actualizar los datos: $e');
    }
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

  String encontrarUnidad(alimento) {
    var unidad = "Unidad";
    alimentos?.forEach((element) {
      if (element["Nombre"] == alimento) {
        setState(() {
          unidad = element["Unidad"];
        });
      }
    });
    return unidad;
  }

  Future<void> agregarAlimentosdeBD() async {
    if (alimentosConsumidos == null) {
      return;
    }
    alimentosConsumidos?.forEach((element) {
      setState(() {
        widgetsList.addAll(<String, elementoAlimento>{
          element["NOMBRE"]: elementoAlimento(
            cantidad: element["CANTIDAD"],
            nombreAlimento: element["NOMBRE"],
            borrarAlimento: borrarAlimentoIndice,
            actualizarAlimento: actualizarA,
            img: elegirImagen(
              element["CATEGORIA"][0],
            ),
            isVisibility: false,
            tamanoElement: 61,
            hora: element["HORA"],
            icono: Icons.arrow_drop_down_rounded,
            id: element["id"],
            unidad: encontrarUnidad(element["NOMBRE"]),
          ),
        });
      });
    });
  }

  Future<void> agregarAlimentosRecuperadosdeBD() async {
    if (alimentosRecuperados == null) {
      return;
    }
    widgetsListBuscar = <String, elementoAlimentoBuscar>{};
    print("ENTRE A AGREGAR ALIMENTOS RECUPERADOS");
    alimentosRecuperados?.forEach((element) {
      setState(() {
        widgetsListBuscar.addAll(<String, elementoAlimentoBuscar>{
          element["id"]: elementoAlimentoBuscar(
            cantidad: element["CANTIDAD"],
            nombreAlimento: element["NOMBRE"],
            img: elegirImagen(
              element["CATEGORIA"][0],
            ),
            isVisibility: false,
            tamanoElement: 61,
            hora: element["HORA"],
            icono: Icons.arrow_drop_down_rounded,
            id: element["id"],
            unidad: encontrarUnidad(element["NOMBRE"]),
            fecha: element["FECHA_INGRESO"],
          ),
        });
      });
    });
  }

  Future<List<Map<String, dynamic>>?> actualizarAlimentos() async {
    alimentosC = [];
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
        data['id'] = doc.id;
        alimentosC.add(data);
      }
    });

    alimentosC.forEach((element) {
      print("$element EN ACTUALIZAR");
    });

    return alimentosC;
  }

  Future<List<Map<String, dynamic>>?> actualizarAlimentosT() async {
    final firestore = FirebaseFirestore.instance;

    CollectionReference collectionReferenceA =
        firestore.collection('Alimentos');

    QuerySnapshot querySnapshotB = await collectionReferenceA.get();

    List<Map<String, dynamic>> alimentosT = [];

    querySnapshotB.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        data['id'] = doc.id;

        alimentosT.add(data);
      }
    });

    return alimentosT;
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
    try {
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
    } catch (e) {
      print(e);
      alimentosSeleccionados = error;
      alimentoSelec = "No Data";
    }
  }

  double mayorTamao() {
    if (listaR.isEmpty) {
      return 0;
    }
    double maxNumber =
        listaR.reduce((value, element) => value > element ? value : element);
    print(
        "El número más grande es: $maxNumber"); // Salida: El número más grande es: 30

    return maxNumber;
  }

  double mayorTamaoBuscar() {
    if (listaB.isEmpty) {
      return 0;
    }
    double maxNumber =
        listaB.reduce((value, element) => value > element ? value : element);
    print(
        "El número más grande es: $maxNumber"); // Salida: El número más grande es: 30

    return maxNumber;
  }

  @override
  Widget build(BuildContext context) {
    print("ENTRE A BUILD");

    agregarAlimentosdeBD();
    agregarAlimentosRecuperadosdeBD();

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
                                          encontrarUnidad(alimentoSelec),
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

                                        List<Map<String, dynamic>>? asd =
                                            await updateFirebaseT(context);

                                        setState(() {
                                          widget.alimentosConsumidos = nuevo!;
                                          widget.alimentos = asd!;
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
                                  text: "Alimentos del dia",
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
                                    text: "Tipo de alimentos",
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
                                  imagePath: 'assets/grafico-de-barras.png',
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
                            color: Colores.morado, // Color de la línea
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 25, right: 10),
                            child: Row(children: [
                              Text(
                                "Histograma de categoria de alimentos consumidos",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Lato',
                                  color: Colores.morado,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 7,
                          ),

                          //AQUI VA A IR EL HISTOGRAMA
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        offset: Offset(0, 5))
                                  ]),
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Center(
                                  child: SizedBox(
                                height: 300,
                                child: GraficoAlimentos(
                                    lista: rellenarListaC(alimentosConsumidos),
                                    tamano: mayorTamao() + 1),
                              ))),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Elemento en el extremo izquierdo
                                    Container(
                                      color: Colores.verde,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Frutas",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    // Espacio flexible entre los elementos
                                    Spacer(),
                                    // Elemento en el extremo derecho
                                    Container(
                                      color: Colors.brown,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Granos     ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Spacer(),
                                    Container(
                                      color: Colores.morado,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Bebida     ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    // Elemento en el extremo izquierdo
                                    Container(
                                      color: Colores.amarillo,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Grasa",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    // Espacio flexible entre los elementos
                                    Spacer(),
                                    // Elemento en el extremo derecho
                                    Container(
                                      color: Colores.rosa,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Proteina",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Spacer(),
                                    Container(
                                      color: Colores.celeste,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Verduras",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: Color.fromRGBO(13, 155, 221, 1),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Lacteos",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]),
                    SizedBox(
                      height: 30,
                    ),

                    //SECCION DE BUSQUEDA
                    Cards(
                        children: [
                          Container(
                            height: 1.0,
                            width: 280, // Altura de la línea
                            color: Colores.morado,
                            // Color de la línea
                          )
                        ],
                        width: 330,
                        height: 20,
                        color: Colores.morado,
                        elevation: 10),
                    SizedBox(
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
                                  text: "Busqueda",
                                  size: 35,
                                  color: Colores.morado,
                                  bold: true,
                                  decoration: TextDecoration.none,
                                  height: 1.3,
                                  letterSpacing: 1),
                              const SizedBox(
                                width: 5,
                              ),
                              const ImageComponent(
                                imagePath: 'assets/alimentosS.png',
                                topMargin: 0,
                                leftMargin: 0,
                                rightMargin: 0,
                                widthSize: 0.12,
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
                      height: 400,
                      width: 330,
                      elevation: 10,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Textos(
                                  text: "Buscar Alimentos",
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
                                imagePath: 'assets/busquedaA.png',
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
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 25, right: 10),
                          child: Row(children: [
                            Text(
                              "Ingrese el rango de fechas para buscar los alimentos consumidos.",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Lato',
                                color: Colores.morado,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 12, right: 12),
                          child: Form(
                              key: _formKey2,
                              child: Column(
                                children: [
                                  TextFormFieldsDateFood(
                                      hintText: "Fecha Inicio",
                                      controller: inicioController,
                                      validacion: 7),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormFieldsDateFood(
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
                                                    Color>(Colores.morado),
                                            elevation: MaterialStateProperty
                                                .all<double>(10),
                                          ),
                                          onPressed: () async {
                                            if (_formKey2.currentState!
                                                .validate()) {
                                              if (fechaMayor(
                                                      inicioController.text,
                                                      finalController.text) ||
                                                  fechaIguales(
                                                      inicioController.text,
                                                      finalController.text)) {
                                                List<Map<String, dynamic>> a =
                                                    await listaRec();

                                                fechainicial =
                                                    inicioController.text;
                                                fechafinal =
                                                    finalController.text;

                                                setState(() {
                                                  alimentosRecuperados = a;
                                                });

                                                List<AlimentoConsumido> b =
                                                    await recuperarAlimentos(
                                                        context);

                                                setState(() {
                                                  listaDatosAlimentos = b;
                                                });
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "La fecha inicial debe ser menor o igual a la fecha final"),
                                                  backgroundColor:
                                                      Colores.morado,
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));
                                              }

                                              //AQUI VA A IR EL METODO QUE VA A DIBUJAR EL HISTOGRAMA
                                            }
                                          },
                                          child: Text("Buscar"))),
                                ],
                              )),
                        ),
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
                                    text: "Tipo de alimentos",
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
                                  imagePath: 'assets/grafico-de-barras.png',
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
                            color: Colores.morado, // Color de la línea
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 25, right: 10),
                            child: Row(children: [
                              Text(
                                "Histograma de categoria de alimentos consumidos",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Lato',
                                  color: Colores.morado,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ]),
                          ),
                          SizedBox(
                            height: 7,
                          ),

                          //AQUI VA A IR EL HISTOGRAMA
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        offset: Offset(0, 5))
                                  ]),
                              margin: EdgeInsets.only(left: 20, right: 20),
                              child: Center(
                                  child: SizedBox(
                                height: 300,
                                child: GraficoAlimentos(
                                    lista: rellenarListaB(alimentosRecuperados),
                                    tamano: mayorTamaoBuscar() + 1),
                              ))),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Elemento en el extremo izquierdo
                                    Container(
                                      color: Colores.verde,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Frutas",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    // Espacio flexible entre los elementos
                                    Spacer(),
                                    // Elemento en el extremo derecho
                                    Container(
                                      color: Colors.brown,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Granos     ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Spacer(),
                                    Container(
                                      color: Colores.morado,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Bebida     ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    // Elemento en el extremo izquierdo
                                    Container(
                                      color: Colores.amarillo,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Grasa",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    // Espacio flexible entre los elementos
                                    Spacer(),
                                    // Elemento en el extremo derecho
                                    Container(
                                      color: Colores.rosa,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Proteina",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Spacer(),
                                    Container(
                                      color: Colores.celeste,
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Verduras",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: Color.fromRGBO(13, 155, 221, 1),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Lacteos",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          color: Colores.morado,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]),
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
                                imagePath: 'assets/alimentos-organicos.png',
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
                              "$fechainicial - $fechafinal",
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
                              itemCount: widgetsListBuscar.length,
                              itemBuilder: (context, index) {
                                List<elementoAlimentoBuscar> elementos =
                                    widgetsListBuscar.values.toList();

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
                    Cards(
                      color: Colors.white,
                      height: tamanoCardDatos,
                      width: 330,
                      elevation: 10,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Textos(
                                  text: "Datos Alimentos",
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
                                imagePath: 'assets/datos.png',
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
                          color: Colores.morado, // Color de la línea
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: mostrarDatos,
                          child: Column(
                            children: [
                              TablaDatosAlimentos(datas: listaDatosAlimentos),
                            ],
                          ),
                        ),
                        Center(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colores.verde),
                                  elevation:
                                      MaterialStateProperty.all<double>(10),
                                ),
                                onPressed: () {
                                  setState(() {
                                    mostrarDatos = !mostrarDatos;
                                    if (mostrarDatos) {
                                      tamanoCardDatos = 500;
                                      botonDato = "Ocultar Datos";
                                      tamanoCardFondo = 5.30;
                                    } else {
                                      tamanoCardDatos = 200;
                                      botonDato = "Mostrar Datos";
                                      tamanoCardFondo = 4.90;
                                    }
                                  });
                                },
                                child: Text(botonDato))),
                      ],
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

  List<String> encontrarCategorias(nombre) {
    List<String> retur = [];

    alimentos?.forEach((element) {
      if (nombre == element["Nombre"]) {
        element["Categorias"].forEach((element) {
          retur.add(element);
        });
      }
    });
    return retur;
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
        "CATEGORIA": encontrarCategorias(alimentoSelec)
      };

      print("LLEGO ASÍ ${encontrarCategorias(alimentoSelec)}");

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
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
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
            ));
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

  Future<List<Map<String, dynamic>>?> updateFirebaseT(
      BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    List<Map<String, dynamic>>? rsp = await actualizarAlimentosT();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);
    return rsp;
  }

  Future<List<Map<String, dynamic>>> recuperarBD(
      List<String> fecha, BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    List<Map<String, dynamic>>? rsp = await recuperarAlimentosConsumidos(fecha);

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);
    return rsp;
  }

  Future<List<AlimentoConsumido>> recuperarAlimentos(
      BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    List<AlimentoConsumido>? rsp = await listaDatosAlimentosMethod();

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

  Future<List<Map<String, dynamic>>> recuperarAlimentosConsumidos(
      List<String> fechas) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
        firestore.collection('Alimentacion');
    List<Map<String, dynamic>> alimentosRecupera = [];

    for (String fecha in fechas) {
      QuerySnapshot querySnapshotA = await collectionReference
          .where('USUARIO', isEqualTo: widget.datos!['id'])
          .where('FECHA_INGRESO', isEqualTo: fecha)
          .get();

      querySnapshotA.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          print(data['USUARIO'] + " FUNCIONA " + data['FECHA_INGRESO']);
          data['id'] = doc.id;
          alimentosRecupera.add(data);
        }
      });
    }

    print("TERMINASDASDADASDA");
    return alimentosRecupera;
  }

  Future<double> recuperarCalorias(String nombre) async {
    double a = 0;
    final firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference = firestore.collection('Alimentos');

    QuerySnapshot querySnapshotA =
        await collectionReference.where('Nombre', isEqualTo: nombre).get();

    querySnapshotA.docs.forEach((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        print("${data['Calorias']} +  FUNCIONA  + data['Nombre']");
        a = data['Calorias'];
      }
    });

    return a;
  }

  List<String> generateDatesInRange(DateTime startDate, DateTime endDate) {
    List<String> datesInRange = [];

    DateFormat formatter = DateFormat('dd/MM/yyyy');

    // Agregar la fecha inicial a la lista
    datesInRange.add(formatter.format(startDate));

    // Generar las fechas adicionales en el rango
    DateTime nextDate = startDate;
    while (nextDate.isBefore(endDate)) {
      nextDate = nextDate.add(Duration(days: 1));
      datesInRange.add(formatter.format(nextDate));
    }

    datesInRange.forEach((element) {
      print(element + " FECHA");
    });

    return datesInRange;
  }

  bool fechaMayor(fechaInicio, fechaFinal) {
    // Convertir las cadenas a objetos DateTime
    DateTime date1 = DateTime.parse(getFormattedDateString(fechaInicio));
    DateTime date2 = DateTime.parse(getFormattedDateString(fechaFinal));

    // Calcular la diferencia en años

    return date2.isAfter(date1);
  }

  String getFormattedDateString(String fecha) {
    List<String> dateParts = fecha.split('/');
    return '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
  }

  String convertirFecha(String fecha) {
    List<String> dateParts = fecha.split('-');
    return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
  }

  bool fechaIguales(String text, String text2) {
    return text == text2;
  }

  Future<List<Map<String, dynamic>>> listaRec() async {
    List<Map<String, dynamic>> lista = await recuperarBD(
        generateDatesInRange(
            DateTime.parse(getFormattedDateString(inicioController.text)),
            DateTime.parse(getFormattedDateString(finalController.text))),
        context);
    return lista;
  }

  Future<List<AlimentoConsumido>> listaDatosAlimentosMethod() async {
    List<AlimentoConsumido> lista = [];

    for (var element in alimentosRecuperados!) {
      lista.add(AlimentoConsumido(
        nombre: element["NOMBRE"],
        calorias: await recuperarCalorias(element["NOMBRE"]),
      ));
    }
    return lista;
  }
}
