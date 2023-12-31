// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatwell/herramientas/conexion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'herramientas/components.dart';
import 'package:eatwell/herramientas/envioEmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  final conexion_Mysql conexion;
  final EmailSender email = EmailSender();

  MyLogin({super.key, required this.conexion});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  conexion_Mysql get conexion => widget.conexion;
  EmailSender get email => widget.email;

// Variables de estado para los valores ingresados en los campos de texto
  TextEditingController nombreUsuarioController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController correoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<bool> controlarSignIn() async {
    return await conexion.existeUsuario(
        nombreUsuarioController.text.trim(), contrasenaController.text.trim());
  }

  Future<List<Map<String, dynamic>>> recuperarTodosLosAlimentos() async {
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

    alimentos.forEach((element) {
      print(element['Nombre']);
    });
    return alimentos;
  }

  Future<List<Map<String, dynamic>>> recuperarAlimentosConsumidos() async {
    final firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference =
        firestore.collection('Alimentacion');

    DateTime myDate = DateTime.now();

    // Utiliza la clase DateFormat para formatear la fecha
    String formattedDate = DateFormat('dd/MM/yyyy').format(myDate);

    QuerySnapshot querySnapshotA = await collectionReference
        .where('USUARIO', isEqualTo: nombreUsuarioController.text.trim())
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
      print(element['USUARIO']);
    });
    return alimentosConsumidos;
  }

  Future<void> showLoadingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
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
            ));
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<bool> fetchDataFromSQL(BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    bool dat = await controlarSignIn();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);

    return dat;
  }

  Future<String?> enviarCorreo(BuildContext context, String usuario) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    String? dat = await email.sendEmail(correoController.text.trim(), usuario);
    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);

    return dat;
  }

  Future<String?> existeUser(BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    String? dat = await conexion.nombreUser(correoController.text);
    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);

    return dat;
  }

  Future<Map<String, dynamic>?> datosC(BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    Map<String, dynamic>? dat =
        await conexion.datos(nombreUsuarioController.text.trim());
    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);

    return dat;
  }

  Future<List<DataPoint>> retornoIMC(BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    await guardarDatos(nombreUsuarioController.text.trim());

    List<DataPoint> dat =
        await conexion.getDatosIMC(nombreUsuarioController.text.trim());

    hideLoadingDialog(context);

    return dat;
  }

  Future<List<Map<String, dynamic>>> alimentosTodos(
      BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    List<Map<String, dynamic>> dat = await recuperarTodosLosAlimentos();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);

    return dat;
  }

  Future<List<Map<String, dynamic>>> alimentosConsumidos(
      BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    List<Map<String, dynamic>> dat = await recuperarAlimentosConsumidos();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);

    return dat;
  }

  limpiar() {
    nombreUsuarioController.clear();
    contrasenaController.clear();
    correoController.clear();
  }

  guardarDatos(String nombreUsuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nombre', nombreUsuario);
    print('Guardado');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey, // Assign the global key to the form
              child: Column(
                children: [
                  WelcomeComponent(
                    title: 'Bienvenido!',
                    topMargin: 0.175,
                    leftMargin: 0.7,
                    alignment: Alignment.center,
                    color: Colors.white,
                  ),
                  ImageComponent(
                    imagePath: 'assets/vegetariano.png',
                    topMargin: 0.0003,
                    leftMargin: 19,
                    rightMargin: 45,
                    widthSize: 0.50,
                    heightSize: 0.35,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0001),
                  TextFormFields(
                    hintText: 'Usuario',
                    controller: nombreUsuarioController,
                    validacion: 0,
                    errorColor: Colors.black,
                    obscureText: false,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextFormFields(
                    hintText: 'Contraseña',
                    controller: contrasenaController,
                    validacion: 0,
                    errorColor: Colors.black,
                    obscureText: true,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  filaComDoble(
                      marginHorizontal: 55,
                      marginVertical: 0,
                      width: 1,
                      height: 0.1,
                      children: [
                        Textos(
                          text: "Sign In",
                          size: 30,
                          color: Colores.morado,
                          bold: true,
                          decoration: TextDecoration.none,
                          height: 0,
                          letterSpacing: 0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0,
                                    5), // desplazamiento de la sombra en X e Y
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colores.morado,
                            child: IconButton(
                              icon: Icon(Icons.chevron_right_rounded, size: 30),
                              color: Colors.black,
                              onPressed: () async {
                                // Validate the form when the button is pressed //formKey.currentState!.validate()
                                if (_formKey.currentState!.validate()) {
                                  // Form is valid, perform additional actions here
                                  try {
                                    if (await fetchDataFromSQL(context)) {
                                      Map<String, dynamic>? datos =
                                          (await datosC(context));

                                      List<DataPoint> imc =
                                          await retornoIMC(context);

                                      List<Map<String, dynamic>> alimentos =
                                          await alimentosTodos(context);

                                      List<Map<String, dynamic>>
                                          alimentosConsumidosA =
                                          await alimentosConsumidos(context);

                                      if (datos!.isNotEmpty &&
                                          imc.isNotEmpty &&
                                          alimentos.isNotEmpty) {
                                        limpiar();
                                        Navigator.pushNamed(context, 'menu',
                                            arguments: MyArguments(
                                                datos,
                                                imc,
                                                alimentos,
                                                alimentosConsumidosA));
                                      } else {
                                        await showDialog(
                                          context: context,
                                          builder: (_) => ErrorDialog(
                                              text:
                                                  'Problemas con el servidor, por favor, reinicie la aplicación'),
                                          barrierDismissible: false,
                                        );
                                      }
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (_) => ErrorDialog(
                                            text:
                                                'Usuario o contraseña incorrectos'),
                                        barrierDismissible: false,
                                      );
                                    }
                                  } catch (e) {
                                    await showDialog(
                                      context: context,
                                      builder: (_) => ErrorDialog(
                                          text:
                                              'Problemas con el servidor, por favor, reinicie la aplicación'),
                                      barrierDismissible: true,
                                    );

                                    print(e);
                                  }
                                }
                              },
                            ),
                          ),
                        )
                      ]),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  filaComDoble(
                      marginHorizontal: 55,
                      marginVertical: 0,
                      width: 1,
                      height: 0.05,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Textos(
                                text: "Sign Up",
                                size: 19,
                                color: Colores.morado,
                                bold: true,
                                decoration: TextDecoration.underline,
                                height: 0,
                                letterSpacing: 0)),
                        TextButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10.0), // Personaliza el radio del borde
                                  ),
                                  backgroundColor: Colores.celeste,
                                  title: Text('¿Olvidaste tu contraseña?',
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center),
                                  content: SizedBox(
                                    height: 150,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Ingresa tu correo electrónico para poder enviarte tu contraseña momentanea',
                                            style: TextStyle(
                                              fontFamily: 'lato',
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 30),
                                          TextFormField(
                                            controller: correoController,
                                            style: TextStyle(
                                              fontFamily: 'lato',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () async {
                                        String? usuario =
                                            await existeUser(context);

                                        if (usuario != null) {
                                          String? contrasena =
                                              await enviarCorreo(
                                                  context, usuario);

                                          if (contrasena != null) {
                                            print("Correo enviado");

                                            conexion.cambiarContrasena(
                                                contrasena,
                                                correoController.text);
                                            correoController.clear();

                                            await showDialog(
                                              context: context,
                                              builder: (_) => ExitoDialog(
                                                  text: 'correo enviado!'),
                                              barrierDismissible: false,
                                            );
                                          } else {
                                            await showDialog(
                                              context: context,
                                              builder: (_) => ErrorDialog(
                                                  text:
                                                      'Error al enviar el correo'),
                                              barrierDismissible: false,
                                            );
                                          }

                                          Navigator.of(context).pop();
                                        } else {
                                          print("No existe el usuario");
                                          await showDialog(
                                            context: context,
                                            builder: (_) => ErrorDialog(
                                                text:
                                                    'el correo no pertenece a ningun usuario'),
                                            barrierDismissible: false,
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Enviar',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                  elevation: 54.0,
                                ),
                                barrierDismissible: true,
                              );
                            },
                            child: Textos(
                                text: "Forgot Password",
                                size: 19,
                                color: Colores.morado,
                                bold: true,
                                decoration: TextDecoration.underline,
                                height: 0,
                                letterSpacing: 0))
                      ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
