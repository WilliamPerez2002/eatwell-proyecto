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
  Nav(
      {super.key,
      required this.conexion,
      required this.datos,
      required this.dataPoints});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  conexion_Mysql? get conexion => widget.conexion;
  Map<String, dynamic>? get datos => widget.datos;
  List<DataPoint> get dataPoints => widget.dataPoints;
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
        actualizarDatos: actualizarDatos,
        dataPoints: dataPoints,
      ),
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

  MyArguments(this.datos, this.imc);
}

class Colores {
  static Color verde = Color.fromRGBO(146, 181, 95, 1.0);
  static Color morado = Color.fromRGBO(75, 68, 82, 1.0);
  static Color rosa = Color.fromRGBO(255, 71, 70, 1.0);
  static Color celeste = Color.fromRGBO(72, 125, 118, 1.0);
  static Color amarillo = Color.fromRGBO(232, 218, 94, 1.0);
}
