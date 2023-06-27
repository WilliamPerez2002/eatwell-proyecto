// ignore: file_names
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, camel_case_types

import 'package:eatwell/herramientas/conexion.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as elements;
import 'package:charts_flutter/src/text_style.dart' as styles;

import 'dart:math';
import '../FoodPage.dart';
import '../IMCPage.dart';
import '../ProfilePage.dart';
import '../homePage.dart';

class WelcomeComponent extends StatelessWidget {
  final String title;
  final double topMargin;
  final double leftMargin;
  final Alignment alignment;
  final Color color;

  const WelcomeComponent(
      {Key? key,
      required this.title,
      required this.topMargin,
      required this.leftMargin,
      required this.alignment,
      required this.color})
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
            color: color,
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

                if (value.trim().length > 10) {
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

                if (value.trim().length > 10) {
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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colores.verde, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
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

class TextFormFieldsDate extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final int validacion;
  final Color errorColor;
  final bool obscureText;

  const TextFormFieldsDate(
      {Key? key,
      required this.hintText,
      required this.controller,
      required this.validacion,
      required this.errorColor,
      required this.obscureText})
      : super(key: key);

  @override
  State<TextFormFieldsDate> createState() => _textFormFieldsDate();
}

// Esta variable es para saber a que campo estamos validando
//1: nombre y apellido, 2: contraseña 3:estatura, 4:peso, 5: nombreUsuario, 6:email
//7: fecha de nacimiento

class _textFormFieldsDate extends State<TextFormFieldsDate> {
  bool presion = false;
  DateTime date = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy')
          .parseStrict('${date.day}/${date.month}/${date.year - 4}'),
      firstDate: DateTime(1980),
      lastDate: DateTime(date.year - 2),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Colores.morado, // Cambia el color principal del DatePicker
              onPrimary:
                  Colors.white, // Cambia el color del texto del DatePicker
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        widget.controller.text = formattedDate;
        // Actualiza el valor del TextFormField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // ignore: prefer_const_constructors
        margin: EdgeInsets.symmetric(horizontal: 55, vertical: 0),
        child: Column(children: [
          TextFormField(
            obscureText: widget.obscureText,
            onSaved: (value) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo vacío';
              }

              if (widget.validacion == 7) {
                try {
                  DateTime fecha =
                      DateFormat('dd/MM/yyyy').parseStrict(value.trim());

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

              return null;
            },
            controller: widget.controller,
            readOnly: true,
            onTap: () {
              presion = true;
              _selectDate(
                  context); // Abre el DatePicker cuando se toca el TextFormField
            },
            onChanged: (value) {
              presion = false;
            },
            decoration: InputDecoration(
                hintText: widget.hintText,
                suffixIcon: Icon(Icons.calendar_today_outlined,
                    color: presion ? Colores.verde : Colors.grey),

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
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colores.verde, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                errorStyle: TextStyle(
                  color: widget.errorColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ]));
  }
}

class TextFormFieldsDateIMC extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final int validacion;

  const TextFormFieldsDateIMC({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.validacion,
  }) : super(key: key);

  @override
  State<TextFormFieldsDateIMC> createState() => _textFormFieldsDateIMC();
}

class _textFormFieldsDateIMC extends State<TextFormFieldsDateIMC> {
  bool presion = false;
  DateTime date = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy')
          .parseStrict('${date.day}/${date.month}/${date.year}'),
      firstDate: DateTime(2023),
      lastDate: DateTime(date.year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  Colores.morado, // Cambia el color principal del DatePicker
              onPrimary:
                  Colors.white, // Cambia el color del texto del DatePicker
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        widget.controller.text = formattedDate;
        // Actualiza el valor del TextFormField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // ignore: prefer_const_constructors
        margin: EdgeInsets.symmetric(horizontal: 55, vertical: 0),
        child: Column(children: [
          TextFormField(
            onSaved: (value) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo vacío';
              }

              return null;
            },
            controller: widget.controller,
            readOnly: true,
            onTap: () {
              presion = true;
              _selectDate(
                  context); // Abre el DatePicker cuando se toca el TextFormField
            },
            onChanged: (value) {
              presion = false;
            },
            decoration: InputDecoration(
              labelText: widget.hintText,
              suffixIcon: Icon(Icons.calendar_today_outlined,
                  color: presion ? Colores.morado : Colores.rosa),
              labelStyle: TextStyle(
                color: Colores.morado,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colores.morado),
              ),
            ),
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
        letterSpacing: letterSpacing,
        height: height,
        overflow: TextOverflow.visible,
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
          child: Text('Aceptar', style: TextStyle(color: Colores.morado)),
        ),
      ],
      elevation: 54.0,
    );
  }
}

class Cards extends StatefulWidget {
  final List<Widget> children;
  final double width;
  final double height;
  final Color color;
  final double elevation;

  const Cards(
      {Key? key,
      required this.children,
      required this.width,
      required this.height,
      required this.color,
      required this.elevation})
      : super(key: key);

  @override
  State<Cards> createState() => _CardState();
}

class _CardState extends State<Cards> {
  get width => widget.width;
  get height => widget.height;
  get color => widget.color;
  get elevation => widget.elevation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: color,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: widget.children,
          ),
        ),
      ),
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
          child: Text('Aceptar', style: TextStyle(color: Colores.morado)),
        ),
      ],
      elevation: 54.0,
    );
  }
}

class Nav extends StatefulWidget {
  final conexion_Mysql? conexion;
  Map<String, dynamic>? datos;
  Nav({super.key, required this.conexion, required this.datos});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  conexion_Mysql? get conexion => widget.conexion;
  Map<String, dynamic>? get datos => widget.datos;
  int _selectedIndex = 0;
  late Color color = Colores.rosa;

  void actualizarDatos(Map<String, dynamic> nuevosDatos) {
    setState(() {
      widget.datos?.addAll(nuevosDatos);
    });
  }

  late List<Widget> _pages = [];

  void changePage(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        color = Colores.rosa;
      } else if (index == 1) {
        color = Colores.celeste;
      } else if (index == 2) {
        color = Colores.verde;
      } else if (index == 3) {
        color = Colores.morado;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(
          conexion: widget.conexion,
          data: datos,
          actualizarDatos: actualizarDatos),
      IMCPage(
          conexion: widget.conexion,
          data: datos,
          actualizarDatos: actualizarDatos),
      FoodPage(),
      ProfilePage(
          conexion: widget.conexion,
          data: datos,
          actualizarDatos: actualizarDatos),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
                backgroundColor: Colors.white,
                padding: EdgeInsets.all(7),
                color: color,
                activeColor: Colors.white,
                tabBackgroundColor: color,
                curve: Curves.easeInCirc,
                onTabChange: changePage,
                gap: 8,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.assessment_rounded,
                    text: 'IMC',
                  ),
                  GButton(
                    icon: Icons.dining,
                    text: 'food',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'Profile',
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class GraficoIMC extends StatefulWidget {
  const GraficoIMC({super.key});

  @override
  State<GraficoIMC> createState() => _GraficoIMCState();
}

class _GraficoIMCState extends State<GraficoIMC> {
  static String? pointerAmount;
  static String? pointerDate;
  @override
  Widget build(BuildContext context) {
    final data = [
      Expenses(89, DateTime(2023, 7, 1)),
      Expenses(13, DateTime(2023, 7, 2)),
      Expenses(14, DateTime(2023, 7, 3)),
      Expenses(0, DateTime(2023, 7, 4)),
      Expenses(16, DateTime(2023, 7, 5)),
    ];

    //VAMOS A INSTANCIAR DESDE UN PRIMER MOMENTO LA GRAFICA CON TODOS LOS VALORES QUE SE HAN INGRESADO

    List<charts.Series<Expenses, DateTime>> series = [
      charts.Series<Expenses, DateTime>(
          id: 'Lineal',
          domainFn: (v, i) => v.date,
          measureFn: (v, i) => v.imc,
          data: data,
          colorFn: (v, i) => charts.ColorUtil.fromDartColor(Colores.rosa))
    ];
    return Center(
      child: SizedBox(
        height: 300.0,
        child: charts.TimeSeriesChart(
          series,
          selectionModels: [
            charts.SelectionModelConfig(
                changedListener: (charts.SelectionModel model) {
              if (model.hasDatumSelection) {
                pointerAmount = model.selectedSeries[0]
                    .measureFn(model.selectedDatum[0].index)
                    ?.toStringAsFixed(2);
                pointerDate = model.selectedSeries[0]
                    .domainFn(model.selectedDatum[0].index)
                    ?.toString();
              }
            })
          ],
          behaviors: [
            charts.LinePointHighlighter(symbolRenderer: SimbolRender()),
          ],
        ),
      ),
    );
  }
}

class SimbolRender extends charts.CircleSymbolRenderer {
  @override
  void paint(charts.ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      charts.Color? fillColor,
      charts.FillPatternType? fillPattern,
      charts.Color? strokeColor,
      double? strokeWidthPx}) {
    // TODO: implement paint
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        fillPattern: fillPattern,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);

    canvas.drawRect(
        Rectangle(bounds.left - 30, bounds.top - 32, bounds.width + 68,
            bounds.height + 18),
        fill: charts.Color.white,
        stroke: charts.Color.black,
        strokeWidthPx: 2);

    String formattedDate = '';

    String? pointerDate = _GraficoIMCState.pointerDate;
    if (pointerDate != null) {
      DateTime date = DateTime.parse(pointerDate);
      formattedDate = DateFormat('dd/MM/yyyy').format(date);
    }

    var style = styles.TextStyle();
    style.fontSize = 10;
    style.color = charts.Color.black;
    style.fontFamily = 'lato';

    canvas.drawText(
        elements.TextElement(
          '${_GraficoIMCState.pointerAmount}\n$formattedDate',
          style: style,
        ),
        (bounds.left - 20).round(),
        (bounds.top - 28).round());
  }
}

class Expenses {
  final double imc;
  final DateTime date;

  Expenses(this.imc, this.date);
}

class Colores {
  static Color verde = Color.fromRGBO(146, 181, 95, 1.0);
  static Color morado = Color.fromRGBO(75, 68, 82, 1.0);
  static Color rosa = Color.fromRGBO(255, 71, 70, 1.0);
  static Color celeste = Color.fromRGBO(72, 125, 118, 1.0);
  static Color amarillo = Color.fromRGBO(232, 218, 94, 1.0);
}
