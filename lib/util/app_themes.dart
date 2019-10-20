import 'package:flutter/material.dart';

enum AppTheme { Standard, Dark }

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
    secondary: Colors.white,
    onSecondary: Colors.blue[300],
    secondaryVariant: Colors.white,
    error: Colors.red,
    onError: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    brightness: Brightness.light,
  )),
  //base.copyWith(brightness: Brightness.light, primaryColor: Colors.blue[300],accentColor: Colors.white,highlightColor: Colors.black, buttonColor: Colors.green),
  AppTheme.Dark: base.copyWith(
      colorScheme: ColorScheme(
    primary: Color(0xff293132),
    onPrimary: Color(0xffDD7373),
    primaryVariant: Color(0xffB55F5F),
    background: Color(0xff293132),
    onBackground: Color(0xffDD7373),
    secondary: Colors.white,
    onSecondary: Colors.blue[300],
    secondaryVariant: Colors.white,
    error: Colors.red,
    onError: Colors.black,
    surface: Color(0xffDD7373),
    onSurface: Colors.black,
    brightness: Brightness.dark,
  )),
  
  /*base.copyWith(
      brightness: Brightness.dark,
      primaryColor: Color(0xff293132),
      accentColor: Color(0xffDD7373),
      highlightColor: Color(0xff5E4955),
      buttonColor: Color(0xff667761)),*/
};
