// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously
import 'package:eatwell/herramientas/conexion.dart';
import 'package:flutter/material.dart';
import 'herramientas/components.dart';

class MyLogin extends StatefulWidget {
  final conexion_Mysql conexion;

  const MyLogin({super.key, required this.conexion});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  conexion_Mysql get conexion => widget.conexion;

// Variables de estado para los valores ingresados en los campos de texto
  TextEditingController nombreUsuarioController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<bool> controlarSignIn() async {
    return await conexion.existeUsuario(
        nombreUsuarioController.text.trim(), contrasenaController.text.trim());
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

  Future<bool> fetchDataFromSQL(BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    bool dat = await controlarSignIn();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);

    return dat;
  }

  @override
  void dispose() {
    // Liberar los controladores de texto al finalizar
    nombreUsuarioController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        color: Color.fromRGBO(75, 68, 82, 1.0),
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
                              offset: Offset(
                                  0, 5), // desplazamiento de la sombra en X e Y
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromRGBO(75, 68, 82, 1.0),
                          child: IconButton(
                            icon: Icon(Icons.chevron_right_rounded, size: 30),
                            color: Colors.black,
                            onPressed: () async {
                              // Validate the form when the button is pressed //formKey.currentState!.validate()
                              if (_formKey.currentState!.validate()) {
                                // Form is valid, perform additional actions here
                                if (await fetchDataFromSQL(context)) {
                                  Navigator.pushNamed(context, 'menu');
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ErrorDialog(
                                        text:
                                            'Usuario o contraseña incorrectos'),
                                    barrierDismissible: false,
                                  );
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
                              color: Color.fromRGBO(75, 68, 82, 1.0),
                              bold: true,
                              decoration: TextDecoration.underline,
                              height: 0,
                              letterSpacing: 0)),
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Personaliza el radio del borde
                                ),
                                title: Text('¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(75, 68, 82, 1.0))),
                                content: Container(
                                  height: 200,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            'Ingresa tu correo electrónico para poder enviarte un correo con tu contraseña momentanea'),
                                        SizedBox(height: 30),
                                        TextFormField(),
                                      ]),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Aceptar',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(75, 68, 82, 1.0)),
                                    ),
                                  ),
                                ],
                                elevation: 54.0,
                              ),
                              barrierDismissible: false,
                            );
                          },
                          child: Textos(
                              text: "Forgot Password",
                              size: 19,
                              color: Color.fromRGBO(75, 68, 82, 1.0),
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
    );
  }
}
