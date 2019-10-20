import 'package:flutter/material.dart';

enum AppTheme { Standard, Marsala, Dark }

/// Returns enum value name without enum class name.
String enumName(AppTheme anyEnum) {
  return anyEnum.toString().split('.')[1];
}

final ThemeData base = ThemeData(
    //primaryColor: Colors.blue[300], //#64B5F6
    //accentColor: Colors.white,
    //highlightColor: Colors.green,
    fontFamily: 'AdventPro',
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 48.0),
      title: TextStyle(fontSize: 24),
      body1: TextStyle(fontSize: 14.0),
      button: TextStyle(
        fontSize: 20.0,
      ),
    ));

final appThemeData = {
  AppTheme.Standard: base.copyWith(
      colorScheme: ColorScheme(
    primary: Colors.blue[300],
    onPrimary: Colors.white,
    primaryVariant: Colors.blue[600],
    background: Colors.blue[300],
    onBackground: Colors.white,
    secondary: Color(0xff57ad21),
    onSecondary: Colors.blue[300],
    secondaryVariant: Color(0xff427d1d),
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.white,
    onSurface: Colors.blue[300],
    brightness: Brightness.light,
  )),
  //base.copyWith(brightness: Brightness.light, primaryColor: Colors.blue[300],accentColor: Colors.white,highlightColor: Colors.black, buttonColor: Colors.green),
  AppTheme.Marsala: base.copyWith(
      colorScheme: ColorScheme(
    primary: Color(0xff293132),
    onPrimary: Color(0xffDD7373),
    primaryVariant: Color(0xff202626),
    background: Color(0xff293132),
    onBackground: Color(0xffDD7373),
    secondary: Color(0xffF1DAC4),
    onSecondary: Colors.white,
    secondaryVariant: Color(0xffb8afa7),
    error: Colors.red,
    onError: Colors.black,
    surface: Color(0xffDD7373),
    onSurface: Colors.black,
    brightness: Brightness.dark,
  )),

  AppTheme.Dark: base.copyWith(
      colorScheme: ColorScheme(
    primary: Color(0xff293132),
    onPrimary: Color(0xff6E7E85),
    primaryVariant: Color(0xff202626),
    background: Color(0xff293132),
    onBackground: Color(0xff6E7E85),
    secondary: Color(0xffAAA95A),
    onSecondary: Colors.white,
    secondaryVariant: Color(0xff6D6C3A),
    error: Colors.red,
    onError: Colors.black,
    surface: Color(0xff051B1D),
    onSurface: Color(0xff6E7E85),
    brightness: Brightness.dark,
  )),
  
  /*base.copyWith(
      brightness: Brightness.dark,
      primaryColor: Color(0xff293132),
      accentColor: Color(0xffDD7373),
      highlightColor: Color(0xff5E4955),
      buttonColor: Color(0xff667761)),*/
};
