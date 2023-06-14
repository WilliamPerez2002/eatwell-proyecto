// ignore: file_names
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, camel_case_types

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WelcomeComponent extends StatelessWidget {
  final String title;
  final double topMargin;
  final double leftMargin;
  final Alignment alignment;

  const WelcomeComponent(
      {Key? key,
      required this.title,
      required this.topMargin,
      required this.leftMargin,
      required this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * topMargin, //0.175
          left: leftMargin,
        ),
        child: Textos(
            text: title,
            size: 45,
            color: Colors.white,
            bold: true,
            decoration: TextDecoration.none,
            height: 1,
            letterSpacing: 1));
  }
}

class ImageComponent extends StatelessWidget {
  final String imagePath;
  final double topMargin;
  final double leftMargin;
  final double rightMargin;
  final double widthSize;
  final double heightSize;

  const ImageComponent(
      {Key? key,
      required this.imagePath,
      required this.topMargin,
      required this.leftMargin,
      required this.rightMargin,
      required this.widthSize,
      required this.heightSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * topMargin, //0.004
        left: leftMargin, //19
        right: rightMargin, //45
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * widthSize, //0.50
        height: MediaQuery.of(context).size.height * heightSize, //0.35
        child: Image.asset(imagePath),
      ),
    );
  }
}

class TextFormFields extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int validacion;
  final Color errorColor;
  final bool obscureText;

  // Esta variable es para saber a que campo estamos validando
//1: nombre y apellido, 2: contraseña 3:estatura, 4:peso, 5: nombreUsuario, 6:email
//7: fecha de nacimiento

  const TextFormFields(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.validacion,
      required this.errorColor,
      required this.obscureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        // ignore: prefer_const_constructors
        margin: EdgeInsets.symmetric(horizontal: 55, vertical: 0),
        child: Column(children: [
          TextFormField(
            obscureText: obscureText,
            onSaved: (value) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo vacío';
              }

              if (validacion == 1) {
                if (value.trim().contains(RegExp(r'[0-9]'))) {
                  return 'No se permiten números';
                }

                if (!RegExp(r'^[A-ZÑÁÉÍÓÚÜ][a-zñáéíóúü]*$')
                    .hasMatch(value.trim())) {
                  return 'nombre con la primera letra mayúscula';
                }

                if (value.trim().length < 3) {
                  return 'muy corto';
                }

                if (value.trim().length > 20) {
                  return 'muy largo';
                }
              }

              if (validacion == 2) {
                if (value.trim().length < 8) {
                  return 'muy corto';
                }

                if (value.trim().length > 20) {
                  return 'muy largo';
                }
              }

              if (validacion == 3) {
                if (value.trim().contains(RegExp(r'[a-zA-Z]'))) {
                  return 'No se permiten letras';
                }

                if (value.trim().contains(RegExp(r'[^0-9]'))) {
                  return 'Solo se permiten números enteros';
                }

                if (value.trim().length > 3) {
                  return 'Estatura muy grande';
                }

                if (value.trim().length < 2) {
                  return 'Estatura muy pequeña';
                }

                if (int.parse(value.trim()) < 60) {
                  return 'Estatura muy pequeña';
                }

                if (int.parse(value.trim()) > 250) {
                  return 'Estatura muy grande';
                }
              }

              if (validacion == 4) {
                if (value.trim().contains(RegExp(r'[a-zA-Z]'))) {
                  return 'No se permiten letras';
                }

                if (double.parse(value.trim()) > 590.00) {
                  return 'Peso muy alto';
                }

                if (double.parse(value.trim()) < 10.00) {
                  return 'Peso muy bajo';
                }

                RegExp regex = RegExp(r'^\d+(\.\d{1,2})?$');

                if (!regex.hasMatch(value.trim())) {
                  return 'Ingrese un peso válido con hasta 2 decimales';
                }
              }

              if (validacion == 5) {
                if (value.trim().contains(RegExp(r'[^a-zA-Z0-9]'))) {
                  return 'Solo se permiten letras y números';
                }

                if (value.trim().length < 3) {
                  return 'muy corto';
                }

                if (value.trim().length > 20) {
                  return 'muy largo';
                }
              }

              if (validacion == 6) {
                final emailRegex =
                    RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.\w+)$');
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Ingrese un email válido';
                }
              }

              if (validacion == 7) {
                try {
                  DateTime fecha =
                      DateFormat('dd/MM/yyyy').parseStrict(value.trim());

                  if (fecha.year > DateTime.now().year) {
                    return 'Ingrese una fecha menor a ${DateTime.now().year}';
                  }

                  if (fecha.year < 1900) {
                    return 'Ingrese una fecha mayor a 1900';
                  }

                  return null;
                } catch (e) {
                  return 'Ingrese una fecha válida';
                }
              }

              return null;
            },
            controller: controller,
            decoration: InputDecoration(
                hintText: hintText,
                // ignore: prefer_const_constructors
                hintStyle: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 20,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                errorStyle: TextStyle(
                  color: errorColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ]));
  }
}

// ignore: must_be_immutable
class filaComDoble extends StatelessWidget {
  final double marginHorizontal;
  final double marginVertical;
  final double width;
  final double height;
  var children = <Widget>[];

  filaComDoble(
      {Key? key,
      required this.marginHorizontal,
      required this.marginVertical,
      required this.height,
      required this.width,
      required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * height,
      margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal, vertical: marginVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var child in children) child,
        ],
      ),
    );
  }
}

class Textos extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final bool bold;
  final TextDecoration decoration;
  final double height;
  final double letterSpacing;

  const Textos(
      {Key? key,
      required this.text,
      required this.size,
      required this.color,
      required this.bold,
      required this.decoration,
      required this.height,
      required this.letterSpacing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'lato',
        fontSize: size,
        color: color,
        fontWeight: (bold ? FontWeight.bold : FontWeight.normal),
        decoration: decoration,
        letterSpacing: 1,
        height: 1,
      ),
    );
  }
}

class ErrorDialog extends StatelessWidget {
  final String text;
  const ErrorDialog({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error!'),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Aceptar'),
        ),
      ],
      elevation: 54.0,
    );
  }
}

class ExitoDialog extends StatelessWidget {
  final String text;
  const ExitoDialog({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Exito!'),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Aceptar'),
        ),
      ],
      elevation: 54.0,
    );
  }
}
