// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'herramientas/components.dart';
import 'herramientas/conexion.dart';

class MyRegister extends StatefulWidget {
  final conexion_Mysql conexion;

  const MyRegister({Key? key, required this.conexion}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  conexion_Mysql get conexion => widget.conexion;
  List<TextFormField> todosLosTextFormFields = [];

  // Variables de estado para los valores ingresados en los campos de texto
  TextEditingController nombreUsuarioController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController estaturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool cuenta = true;
  bool adicional = false;
  Color colorCuenta = Colores.morado;
  Color colorAdicional = Colors.transparent;

  Future<bool> insertar() async {
    return await conexion.ingreso(
        nombreUsuarioController.text.trim(),
        emailController.text.trim(),
        contrasenaController.text.trim(),
        fechaNacimientoController.text.trim(),
        nombreController.text.trim(),
        apellidoController.text.trim(),
        int.parse(estaturaController.text.trim()),
        double.parse(pesoController.text.trim()));
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
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

  Future<void> insertarSQL(BuildContext context) async {
    // Mostrar el diálogo de carga
    showLoadingDialog(context);

    await insertar();

    // Ocultar el diálogo de carga después de completar la carga SQL
    hideLoadingDialog(context);
  }

//VALIDACIONES DE LOS CAMPOS DE TEXTO
  String? valNombreApellido(String value, String opcion) {
    if (value.isEmpty) {
      return 'El $opcion está vacío';
    }

    if (value.contains(RegExp(r'[0-9]'))) {
      return 'No se permiten números en el $opcion';
    }

    if (!RegExp(r'^[A-ZÑÁÉÍÓÚÜ][a-zñáéíóúü]*$').hasMatch(value)) {
      return 'el $opcion debe comenzar con mayúscula';
    }

    if (value.length < 3) {
      return '$opcion muy corto';
    }

    if (value.length > 10) {
      return '$opcion muy largo';
    }

    return null;
  }

  String? valContrasena(String value) {
    if (value.isEmpty) {
      return 'La contraseña está vacía';
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (value.length > 20) {
      return 'La contraseña debe tener menos de 20 caracteres';
    }

    return null;
  }

  String? valEstatura(String value) {
    if (value.isEmpty) {
      return 'La altura está vacía';
    }

    if (value.contains(RegExp(r'[a-zA-Z]'))) {
      return 'No se permiten letras en la estatura';
    }

    if (value.contains(RegExp(r'[^0-9]'))) {
      return 'Solo se permiten números enteros en la estatura';
    }

    if (value.length > 3) {
      return 'Estatura muy grande';
    }

    if (value.length < 2) {
      return 'Estatura muy pequeña';
    }

    if (int.parse(value) < 60) {
      return 'Estatura muy pequeña';
    }

    if (int.parse(value) > 250) {
      return 'Estatura muy grande';
    }

    return null;
  }

  String? valPeso(String value) {
    if (value.isEmpty) {
      return 'El peso está vacío';
    }

    if (value.contains(RegExp(r'[a-zA-Z]'))) {
      return 'No se permiten letras en el peso';
    }

    if (double.parse(value) > 590.00) {
      return 'Peso muy alto';
    }

    if (double.parse(value) < 10.00) {
      return 'Peso muy bajo';
    }

    RegExp regex = RegExp(r'^\d{2,3}(\.\d{1,2})?$');

    if (!regex.hasMatch(value)) {
      return 'Ingrese un peso válido con hasta 2 decimales';
    }
    return null;
  }

  String? valNomUsuario(String value) {
    if (value.isEmpty) {
      return 'El nombre de usuario está vacío';
    }

    if (value.contains(RegExp(r'[^a-zA-Z0-9]'))) {
      return 'Solo se permiten letras y números en el nombre de usuario';
    }

    if (value.length < 3) {
      return 'Nombre de usuario muy corto';
    }

    if (value.length > 10) {
      return 'Nombre de usuario muy largo';
    }

    return null;
  }

  String? valEmail(String value) {
    if (value.isEmpty) {
      return 'El email está vacío';
    }

    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.\w+)$');
    if (!emailRegex.hasMatch(value)) {
      return 'Ingrese un email válido';
    }

    return null;
  }

  String? valFecha(String value) {
    if (value.isEmpty) {
      return 'La fecha está vacía';
    }

    try {
      DateTime fecha = DateFormat('dd/MM/yyyy').parseStrict(value);

      if (fecha.year > DateTime.now().year - 3) {
        return 'Ingrese una fecha menor a ${DateTime.now().year - 3}';
      }

      if (fecha.year < 1980) {
        return 'Ingrese una fecha mayor a 1980';
      }

      return null;
    } catch (e) {
      return 'Ingrese una fecha válida';
    }
  }

  String? controlGeneral() {
    String? value = valNombreApellido(nombreController.text.trim(), "nombre");

    if (value != null) {
      return value;
    }

    value = valNombreApellido(apellidoController.text.trim(), "apellido");

    if (value != null) {
      return value;
    }

    value = valEstatura(estaturaController.text.trim());

    if (value != null) {
      return value;
    }

    value = valPeso(pesoController.text.trim());

    if (value != null) {
      return value;
    }

    value = valNomUsuario(nombreUsuarioController.text.trim());

    if (value != null) {
      return value;
    }

    value = valEmail(emailController.text.trim());

    if (value != null) {
      return value;
    }

    value = valFecha(fechaNacimientoController.text.trim());

    if (value != null) {
      return value;
    }

    value = valContrasena(contrasenaController.text.trim());

    if (value != null) {
      return value;
    }

    return null;
  }

  limpiar() {
    nombreController.clear();
    apellidoController.clear();
    estaturaController.clear();
    pesoController.clear();
    nombreUsuarioController.clear();
    emailController.clear();
    fechaNacimientoController.clear();
    contrasenaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/register.png'),
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
                filaComDoble(
                  marginHorizontal: 0,
                  marginVertical: 40,
                  width: 1,
                  height: 0.20,
                  children: const [
                    WelcomeComponent(
                        title: 'Nueva \nCuenta',
                        topMargin: 0.01,
                        leftMargin: 13,
                        alignment: Alignment.centerLeft,
                        color: Colors.white),
                    ImageComponent(
                      imagePath: 'assets/dieta.png',
                      topMargin: 0.01,
                      leftMargin: 39,
                      rightMargin: 13,
                      widthSize: 0.25,
                      heightSize: 0.35,
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.001),
                filaComDoble(
                    marginHorizontal: 0,
                    marginVertical: 0,
                    height: 0.1,
                    width: 1,
                    children: [
                      MaterialButton(
                        minWidth: 190.0,
                        height: 40.0,
                        onPressed: () {
                          setState(() {
                            cuenta = true;
                            adicional = false;
                            colorCuenta = Colores.morado;
                            colorAdicional = Colors.transparent;
                          });
                        },
                        color: colorCuenta,
                        child: Text('Cuenta',
                            style: TextStyle(color: Colors.white)),
                      ),
                      MaterialButton(
                        minWidth: 190.0,
                        height: 40.0,
                        onPressed: () {
                          setState(() {
                            cuenta = false;
                            adicional = true;
                            colorAdicional = Colores.morado;
                            colorCuenta = Colors.transparent;
                          });
                        },
                        color: colorAdicional,
                        child: Text('Adicional',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ]),
                Visibility(
                  visible: cuenta,
                  child: Column(
                    children: [
                      TextFormFields(
                        hintText: 'Nombre de usuario',
                        controller: nombreUsuarioController,
                        validacion: 5,
                        errorColor: Colors.red,
                        obscureText: false,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFields(
                        hintText: 'Email',
                        controller: emailController,
                        validacion: 6,
                        errorColor: Colors.red,
                        obscureText: false,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFields(
                        hintText: 'Contraseña',
                        controller: contrasenaController,
                        validacion: 2,
                        errorColor: Colors.red,
                        obscureText: true,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFieldsDate(
                        hintText: 'Fecha de nacimiento dd/mm/aaaa',
                        controller: fechaNacimientoController,
                        validacion: 7,
                        errorColor: Colors.red,
                        obscureText: false,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                    ],
                  ),
                ),
                Visibility(
                  visible: adicional,
                  child: Column(
                    children: [
                      TextFormFields(
                        hintText: 'Nombre',
                        controller: nombreController,
                        validacion: 1,
                        errorColor: Colors.red,
                        obscureText: false,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFields(
                        hintText: 'Apellido',
                        controller: apellidoController,
                        validacion: 1,
                        errorColor: Colors.red,
                        obscureText: false,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFields(
                        hintText: 'Estatura en cm',
                        controller: estaturaController,
                        validacion: 3,
                        errorColor: Colors.red,
                        obscureText: false,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      TextFormFields(
                        hintText: 'Peso en kg',
                        controller: pesoController,
                        validacion: 4,
                        errorColor: Colors.red,
                        obscureText: false,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                    ],
                  ),
                ),
                filaComDoble(
                    marginHorizontal: 55,
                    marginVertical: 0,
                    width: 1,
                    height: 0.1,
                    children: [
                      Textos(
                        text: "Sign Up",
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
                              offset: Offset(
                                  0, 5), // desplazamiento de la sombra en X e Y
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
                                String? valor = controlGeneral();

                                if (valor == null) {
                                  //Aqui se hace el insert

                                  try {
                                    await insertarSQL(context);

                                    await showDialog(
                                      context: context,
                                      builder: (_) => ExitoDialog(
                                          text: 'Usuario agregado con exito'),
                                      barrierDismissible: false,
                                    );

                                    DateFormat fecha = DateFormat('dd/MM/yyyy');
                                    String formattedDate =
                                        fecha.format(DateTime.now());

                                    var peso = double.parse(
                                        pesoController.text.trim());
                                    var estatura = double.parse(
                                        estaturaController.text.trim());
                                    var imc = (peso /
                                            ((estatura / 100) *
                                                (estatura / 100)))
                                        .toStringAsFixed(2);

                                    Map<String, dynamic>? datos = {
                                      "nombre": nombreController.text.trim(),
                                      "apellido":
                                          apellidoController.text.trim(),
                                      "email": emailController.text.trim(),
                                      "fecha": formattedDate,
                                      "imc": imc.toString(),
                                      "id": nombreController.text.trim(),
                                      "fecha_nacimiento":
                                          fechaNacimientoController.text.trim(),
                                      "contrasena":
                                          contrasenaController.text.trim(),
                                    };
                                    Navigator.pushNamed(context, 'menu',
                                        arguments: datos);
                                    limpiar();
                                  } catch (e) {
                                    print(e);

                                    if (e.toString().contains("'PRIMARY'")) {
                                      await showDialog(
                                        context: context,
                                        builder: (_) => ErrorDialog(
                                            text:
                                                'Nombre de usuario ya existente'),
                                        barrierDismissible: false,
                                      );
                                      Navigator.of(context).pop();
                                    } else if (e
                                        .toString()
                                        .contains("'uk_email'")) {
                                      await showDialog(
                                        context: context,
                                        builder: (_) => ErrorDialog(
                                            text: 'email ya existente'),
                                        barrierDismissible: false,
                                      );
                                      Navigator.of(context).pop();
                                    } else {
                                      await showDialog(
                                        context: context,
                                        builder: (_) => ErrorDialog(
                                            text: 'Intente nuevamente'),
                                        barrierDismissible: false,
                                      );
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      print("Error al ingresar");
                                    }
                                  }
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ErrorDialog(text: valor),
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
                            Navigator.pushNamed(context, 'login');
                          },
                          child: Textos(
                              text: "Sign In",
                              size: 19,
                              color: Colores.morado,
                              bold: true,
                              decoration: TextDecoration.underline,
                              height: 0,
                              letterSpacing: 0)),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
