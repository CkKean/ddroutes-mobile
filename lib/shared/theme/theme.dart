import 'package:flutter/material.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: createMaterialColor(Color(0xFF008C8C)),
      accentColor: createMaterialColor(Color(0xFF008C8C)),
      scaffoldBackgroundColor: createMaterialColor(Color(0xFFF5F7FA)),
      fontFamily: 'Montserrat',
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        buttonColor: createMaterialColor(Color(0xFF0477C1)),
      ),
      textTheme: _textTheme(ThemeData.light().textTheme),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

TextTheme _textTheme(TextTheme base) {
  return base.copyWith(
    bodyText1: base.bodyText1.copyWith(
        fontWeight: FontWeight.w800,
        fontSize: 16.0,
        fontFamily: 'Montserrat',
        color: createMaterialColor(Color(0xFF424B57))),
    bodyText2: base.bodyText2.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        fontFamily: 'Montserrat',
        color: createMaterialColor(Color(0xFF646C77))),
    headline1: base.headline1.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 26.0,
        fontFamily: 'Montserrat',
        color: createMaterialColor(Color(0xFF424B57))),
    headline2: base.headline2.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 24.0,
        fontFamily: 'Montserrat',
        color: createMaterialColor(Color(0xFF424B57))),
    headline3: base.headline3.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
        fontFamily: 'Montserrat',
        color: createMaterialColor(Color(0xFF424B57))),
    headline4: base.headline4.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 20.0,
        fontFamily: 'Montserrat',
        color: createMaterialColor(Color(0xFF424B57))),
    headline5: base.headline5.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 18.0,
        fontFamily: 'Montserrat',
        color: createMaterialColor(Color(0xFF424B57))),
    headline6: base.headline6.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
        fontFamily: 'Montserrat',
        color: createMaterialColor(Color(0xFF646C77))),
  );
}
