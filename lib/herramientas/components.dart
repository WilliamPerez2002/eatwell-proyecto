// ignore: file_names
// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers, camel_case_types

import 'package:eatwell/herramientas/conexion.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/src/text_element.dart' as elements;
import 'package:charts_flutter/src/text_style.dart' as styles;
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
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

class TextFormFieldsDateFood extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final int validacion;

  const TextFormFieldsDateFood({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.validacion,
  }) : super(key: key);

  @override
  State<TextFormFieldsDateFood> createState() => _textFormFieldsDateFood();
}

class _textFormFieldsDateFood extends State<TextFormFieldsDateFood> {
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
                  color: presion ? Colores.morado : Colores.verde),
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
  List<DataPoint> dataPoints;
  List<Map<String, dynamic>> alimentos = [];
  List<Map<String, dynamic>> alimentosConsumidos = [];

  Nav(
      {super.key,
      required this.conexion,
      required this.datos,
      required this.dataPoints,
      required this.alimentos,
      required this.alimentosConsumidos});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  conexion_Mysql? get conexion => widget.conexion;
  Map<String, dynamic>? get datos => widget.datos;
  List<DataPoint> get dataPoints => widget.dataPoints;
  List<Map<String, dynamic>> get alimentos => widget.alimentos;
  List<Map<String, dynamic>> get alimentosConsumidos =>
      widget.alimentosConsumidos;

  int _selectedIndex = 0;
  late Color color = Colores.rosa;

  void actualizarDatos(Map<String, dynamic> nuevosDatos) {
    setState(() {
      widget.datos?.addAll(nuevosDatos);
    });
  }

  void actualizarAlimentos(
    List<Map<String, dynamic>> alimentosConsumidos,
    List<Map<String, dynamic>> alimentos,
  ) {
    setState(() {
      widget.alimentosConsumidos.addAll(alimentosConsumidos);

      widget.alimentos.addAll(alimentos);
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
        actualizarDatos: actualizarDatos,
        dataPoints: dataPoints,
      ),
      FoodPage(
        alimentos: alimentos,
        actualizarAlimentos: actualizarAlimentos,
        alimentosConsumidos: alimentosConsumidos,
        datos: datos,
      ),
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

class GraficoIMC2 extends StatefulWidget {
  final Function() onDataUpdated;
  List<DataPoint> datas;

  GraficoIMC2({Key? key, required this.onDataUpdated, required this.datas})
      : super(key: key);

  @override
  State<GraficoIMC2> createState() => _GraficoIMC2State();
}

class _GraficoIMC2State extends State<GraficoIMC2> {
  void updateData() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          height: 300.0,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: widget.datas.map((point) {
                    return FlSpot(
                      point.date.millisecondsSinceEpoch.toDouble(),
                      point.imc.toDouble(),
                    );
                  }).toList(),
                  isCurved: true,
                  colors: [
                    Colores.rosa,
                  ],
                  barWidth: 3,
                  belowBarData: BarAreaData(
                    show: true,
                    colors: [
                      Colores.rosa.withOpacity(0.7),
                      Colores.rosa.withOpacity(0.3),
                    ],
                    gradientColorStops: [0.0, 0.8],
                    gradientFrom: const Offset(0, 0),
                    gradientTo: const Offset(0, 1),
                  ),
                ),
              ],
              minX: widget.datas.first.date.millisecondsSinceEpoch.toDouble() -
                  (30 * 60 * 1000),
              maxX: widget.datas.last.date.millisecondsSinceEpoch.toDouble() +
                  (30 * 60 * 1000),
              minY: 10,
              maxY: widget.datas
                      .map((point) => point.imc)
                      .reduce((a, b) => a > b ? a : b)
                      .toDouble() +
                  10,
              titlesData: FlTitlesData(
                bottomTitles: SideTitles(showTitles: false),
                leftTitles: SideTitles(showTitles: false),
              ),
              gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colores.rosa.withOpacity(0.2),
                    strokeWidth: 0.2,
                  );
                },
              ),
              backgroundColor: Colors.white.withOpacity(0.5),
              borderData: FlBorderData(
                show: true,
                border: Border.all(
                  color: Colores.rosa,
                  width: 1,
                ),
              ),
              axisTitleData: FlAxisTitleData(
                show: true,
                leftTitle: AxisTitle(
                  showTitle: true,
                  titleText: 'IMC',
                  margin: 2,
                  textStyle: const TextStyle(
                      color: Color.fromRGBO(75, 68, 82, 1.0),
                      fontSize: 12,
                      fontFamily: 'lato'),
                ),
                bottomTitle: AxisTitle(
                  showTitle: true,
                  titleText: 'Fecha',
                  margin: 4,
                  textStyle: const TextStyle(
                    color: Color.fromRGBO(75, 68, 82, 1.0),
                    fontSize: 12,
                    fontFamily: 'lato',
                  ),
                ),
              ),
              rangeAnnotations: RangeAnnotations(
                verticalRangeAnnotations: [
                  VerticalRangeAnnotation(
                    x1: widget.datas.first.date.millisecondsSinceEpoch
                        .toDouble(),
                    x2: widget.datas.last.date.millisecondsSinceEpoch
                        .toDouble(),
                    color: Colores.rosa.withOpacity(0.1),
                  ),
                ],
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colores.celeste.withOpacity(0.8),
                  getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                    return lineBarsSpot.map((lineBarSpot) {
                      DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              lineBarSpot.x.toInt(),
                              isUtc: true)
                          .toLocal();
                      print(date);

                      DateTime nextDay = date.add(Duration(days: 1));
                      double imc = lineBarSpot.y.toDouble();

                      return LineTooltipItem(
                        'IMC: $imc\nFecha: ${nextDay.day}/${date.month}/${date.year}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TablaDatos extends StatefulWidget {
  List<DataPoint> datas;

  TablaDatos({super.key, required this.datas});

  @override
  State<TablaDatos> createState() => _TablaDatosState();
}

class _TablaDatosState extends State<TablaDatos> {
  List<DataPoint> get datas => widget.datas;
  List<DataRow> dataRows = [];

  convertirRows() {
    dataRows = [];
    for (var i = 0; i < datas.length; i++) {
      dataRows.add(
        DataRow(cells: [
          DataCell(Text(
            DateFormat('dd-MM-yyyy').format(datas[i].date),
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'lato',
                color: Colores.morado,
                fontWeight: FontWeight.bold),
          )),
          DataCell(Text(
            datas[i].imc.toString(),
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'lato',
                color: Colores.morado,
                fontWeight: FontWeight.bold),
          )),
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    convertirRows();

    return Container(
      decoration: BoxDecoration(
        color: Colores.rosa.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colores.morado,
          width: 2,
        ),
      ),
      constraints: BoxConstraints(maxHeight: 300),
      width: 300, // Establece una altura máxima
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(
                label: Text(
              'FECHA',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'lato',
                  color: Colores.morado,
                  fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'IMC',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'lato',
                  color: Colores.morado,
                  fontWeight: FontWeight.bold),
            )),
          ],
          rows: [
            for (var i = 0; i < dataRows.length; i++) dataRows[i],
          ],
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Colores.morado,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class TablaDatosAlimentos extends StatefulWidget {
  List<AlimentoConsumido> datas;

  TablaDatosAlimentos({super.key, required this.datas});

  @override
  State<TablaDatosAlimentos> createState() => _TablaDatosAlimentosState();
}

class _TablaDatosAlimentosState extends State<TablaDatosAlimentos> {
  List<AlimentoConsumido> get datas => widget.datas;
  List<DataRow> dataRows = [];

  convertirRows() {
    dataRows = [];
    for (var i = 0; i < datas.length; i++) {
      dataRows.add(
        DataRow(cells: [
          DataCell(Text(
            datas[i].getNombre(),
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'lato',
                color: Colores.morado,
                fontWeight: FontWeight.bold),
          )),
          DataCell(Text(
            datas[i].getCalorias().toString(),
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'lato',
                color: Colores.morado,
                fontWeight: FontWeight.bold),
          )),
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    convertirRows();

    return Container(
      decoration: BoxDecoration(
        color: Colores.verde.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colores.morado,
          width: 2,
        ),
      ),
      constraints: BoxConstraints(maxHeight: 300),
      width: 300, // Establece una altura máxima
      child: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(
                label: Text(
              'ALIMENTO',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'lato',
                  color: Colores.morado,
                  fontWeight: FontWeight.bold),
            )),
            DataColumn(
                label: Text(
              'CALORIAS U',
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'lato',
                  color: Colores.morado,
                  fontWeight: FontWeight.bold),
            )),
          ],
          rows: [
            for (var i = 0; i < dataRows.length; i++) dataRows[i],
          ],
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Colores.morado,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class elementoAlimento extends StatefulWidget {
  final String nombreAlimento;
  final Function(String, String) borrarAlimento;
  final Function(int, String) actualizarAlimento;
  int cantidad;
  final String img;
  bool isVisibility;
  double tamanoElement;
  IconData icono;
  String hora;
  String id;
  String unidad;

  elementoAlimento(
      {super.key,
      required this.nombreAlimento,
      required this.cantidad,
      required this.borrarAlimento,
      required this.img,
      required this.isVisibility,
      required this.tamanoElement,
      required this.icono,
      required this.hora,
      required this.id,
      required this.actualizarAlimento,
      required this.unidad});

  @override
  State<elementoAlimento> createState() => _elementoAlimentoState();
}

class _elementoAlimentoState extends State<elementoAlimento> {
  String get nombreAlimento => widget.nombreAlimento;
  int get cantidad => widget.cantidad;
  set cantidad(int value) => widget.cantidad = value;
  Function(String, String) get borrarAlimento => widget.borrarAlimento;
  double get tamanoElement => widget.tamanoElement.toDouble();
  bool get isVisible => widget.isVisibility;
  Function(int, String) get actualizarAlimento => widget.actualizarAlimento;
  int num = 0;

  void borrar() {
    borrarAlimento(widget.id, widget.nombreAlimento);
  }

  void actualizar() {
    actualizarAlimento(widget.cantidad, widget.id);
  }

  showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Confirmar Acción',
        message: '¿Estás seguro de que deseas eliminar?',
        onConfirm: () {
          borrar();
          Navigator.pop(context); // Cerrar el diálogo después de confirmar
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (num == 0) {
      num = cantidad;
    }
    return SizedBox(
      width: 300,
      height: tamanoElement, //61 solo y desplegado 120
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 10, top: 3, bottom: 3, right: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colores.verde,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 9,
                        offset: Offset(
                            0, 4), // Desplazamiento de la sombra en x y y
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colores.verde,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.asset(
                        widget.img,
                        fit: BoxFit.cover,
                        width: 25,
                        height: 25,
                      ),
                    ), // Ruta de la imagen que deseas mostrar
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(nombreAlimento,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(widget.hora,
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.isVisibility = !isVisible;
                            widget.tamanoElement =
                                tamanoElement == 61 ? 220 : 61;
                            widget.icono = tamanoElement == 61
                                ? Icons.arrow_drop_down_rounded
                                : Icons.arrow_drop_up_rounded;
                          });
                        },
                        child: Icon(
                          size: 30,
                          widget.icono,
                          color: Colores.verde,
                        ),
                      ),

                      // Aquí puedes agregar más widgets en el medio
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 30, top: 20, bottom: 10),
                child: Column(
                  children: [
                    Container(
                      height: 1.0,
                      width: 217, // Altura de la línea
                      color: Colores.morado, // Color de la línea
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 250,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Cantidad:",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 25,
                                width: 20,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text('$cantidad'),
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
                                widget.unidad,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 20,
                              width: 75,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colores.celeste),
                                    elevation:
                                        MaterialStateProperty.all<double>(10),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      if (num != cantidad) {
                                        actualizar();
                                        num = 0;
                                      }
                                    });
                                  },
                                  child: Text("Actualizar",
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold)))),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              height: 20,
                              width: 70,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colores.rosa),
                                    elevation:
                                        MaterialStateProperty.all<double>(10),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      showConfirmationDialog(context);
                                    });
                                  },
                                  child: Text("Eliminar",
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold))))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class elementoAlimentoBuscar extends StatefulWidget {
  final String nombreAlimento;
  int cantidad;
  final String img;
  bool isVisibility;
  double tamanoElement;
  IconData icono;
  String hora;
  String id;
  String unidad;
  String fecha;

  elementoAlimentoBuscar(
      {super.key,
      required this.nombreAlimento,
      required this.cantidad,
      required this.img,
      required this.isVisibility,
      required this.tamanoElement,
      required this.icono,
      required this.hora,
      required this.id,
      required this.unidad,
      required this.fecha});

  @override
  State<elementoAlimentoBuscar> createState() => _elementoAlimentoBuscarState();
}

class _elementoAlimentoBuscarState extends State<elementoAlimentoBuscar> {
  String get nombreAlimento => widget.nombreAlimento;
  int get cantidad => widget.cantidad;
  set cantidad(int value) => widget.cantidad = value;
  double get tamanoElement => widget.tamanoElement.toDouble();
  bool get isVisible => widget.isVisibility;
  String get fecha => widget.fecha;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: tamanoElement, //61 solo y desplegado 120
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 10, top: 3, bottom: 3, right: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colores.verde,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 9,
                        offset: Offset(
                            0, 4), // Desplazamiento de la sombra en x y y
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colores.rosa,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Image.asset(
                        widget.img,
                        fit: BoxFit.cover,
                        width: 25,
                        height: 25,
                      ),
                    ), // Ruta de la imagen que deseas mostrar
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(nombreAlimento,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold)),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(widget.hora,
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.isVisibility = !isVisible;
                            widget.tamanoElement =
                                tamanoElement == 61 ? 200 : 61;
                            widget.icono = tamanoElement == 61
                                ? Icons.arrow_drop_down_rounded
                                : Icons.arrow_drop_up_rounded;
                          });
                        },
                        child: Icon(
                          size: 30,
                          widget.icono,
                          color: Colores.verde,
                        ),
                      ),

                      // Aquí puedes agregar más widgets en el medio
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 30, top: 20, bottom: 10),
                child: Column(
                  children: [
                    Container(
                      height: 1.0,
                      width: 217, // Altura de la línea
                      color: Colores.morado, // Color de la línea
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        width: 250,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Cantidad:",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold),
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
                                          color: Colores.celeste)),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.unidad,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                    Container(
                        width: 250,
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Fecha:",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 25,
                                width: 90,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(fecha,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Lato',
                                          fontWeight: FontWeight.bold,
                                          color: Colores.celeste)),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GraficoAlimentos extends StatefulWidget {
  final List lista;
  final double tamano;
  const GraficoAlimentos(
      {super.key, required this.lista, required this.tamano});

  @override
  State<GraficoAlimentos> createState() => _GraficoAlimentosState();
}

class _GraficoAlimentosState extends State<GraficoAlimentos> {
  @override
  Widget build(BuildContext context) {
    widget.lista.forEach((element) {
      print(element);
    });

    BarData myBar = BarData(
        fruta: widget.lista[0],
        grano: widget.lista[1],
        bebida: widget.lista[2],
        grasa: widget.lista[3],
        proteina: widget.lista[4],
        verdura: widget.lista[5],
        lacteo: widget.lista[6]);
    myBar.initializeBarData();

    return BarChart(BarChartData(
      maxY: widget.tamano,
      minY: 0,
      titlesData: FlTitlesData(show: false),
      backgroundColor: Colores.verde.withOpacity(0.1),
      gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colores.verde, strokeWidth: 1)),
      borderData: FlBorderData(
        border: Border.all(
            color: Colores.verde, width: 1, style: BorderStyle.solid),
      ),
      barGroups: myBar.barData
          .map((e) => BarChartGroupData(
                x: e.x,
                barRods: [
                  BarChartRodData(
                    y: e.y,
                    colors: [e.color],
                    width: 30,
                    borderRadius: BorderRadius.circular(5),
                  )
                ],
              ))
          .toList(),
      groupsSpace: 13,
    ));
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;

  ConfirmationDialog({
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar',
              style: TextStyle(color: Colores.morado, fontFamily: 'Lato')),
        ),
        ElevatedButton(
            onPressed: onConfirm,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colores.rosa),
              elevation: MaterialStateProperty.all<double>(10),
            ),
            child: Text('Confirmar', style: TextStyle(fontFamily: 'Lato'))),
      ],
    );
  }
}

class DataPoint {
  final double imc;
  final DateTime date;

  DataPoint(this.imc, this.date);

  double getImc() {
    return imc;
  }

  DateTime getDate() {
    return date;
  }
}

class MyArguments {
  final Map<String, dynamic> datos;
  final List<DataPoint> imc;
  final List<Map<String, dynamic>> alimentos;
  final List<Map<String, dynamic>> alimentosConsumidos;

  MyArguments(this.datos, this.imc, this.alimentos, this.alimentosConsumidos);
}

class Colores {
  static Color verde = Color.fromRGBO(146, 181, 95, 1.0);
  static Color morado = Color.fromRGBO(75, 68, 82, 1.0);
  static Color rosa = Color.fromRGBO(255, 71, 70, 1.0);
  static Color celeste = Color.fromRGBO(72, 125, 118, 1.0);
  static Color amarillo = Color.fromRGBO(232, 218, 94, 1.0);
}

class IndividualBar {
  final int x;
  final double y;
  final Color color;

  IndividualBar({required this.x, required this.y, required this.color});
}

class BarData {
  final double fruta;
  final double grano;
  final double bebida;
  final double grasa;
  final double proteina;
  final double verdura;
  final double lacteo;

  BarData(
      {required this.fruta,
      required this.grano,
      required this.bebida,
      required this.grasa,
      required this.proteina,
      required this.verdura,
      required this.lacteo});

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: fruta, color: Colores.verde),
      IndividualBar(x: 1, y: grano, color: Colors.brown),
      IndividualBar(x: 2, y: bebida, color: Colores.morado),
      IndividualBar(x: 3, y: grasa, color: Colores.amarillo),
      IndividualBar(x: 4, y: proteina, color: Colores.rosa),
      IndividualBar(x: 5, y: verdura, color: Colores.celeste),
      IndividualBar(x: 6, y: lacteo, color: Color.fromRGBO(13, 155, 221, 1))
    ];
  }
}

class AlimentoConsumido {
  final String nombre;
  final double calorias;

  AlimentoConsumido({required this.nombre, required this.calorias});

  String getNombre() {
    return nombre;
  }

  double getCalorias() {
    return calorias;
  }
}
