import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'screens/home/home.dart';

import 'screens/init/init.dart';
import 'screens/splash/splash.dart';


void main() => runApp(MyApp());

final logger = Logger.Logger();



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Open CSB Door',
        theme: ThemeData(
            primaryColor: Colors.blue[300], //#64B5F6
            accentColor: Colors.white,
            fontFamily: 'AdventPro',
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 48.0),
              title: TextStyle(fontSize: 24),
              body1: TextStyle(fontSize: 14.0),
              button: TextStyle(fontSize: 20.0,),
            )),

        // Define the default font family.

        home: Splash(
          initWidgetRoute: _createRoute(Init(
              homeWidgetRoute:
                  _createRoute(HomePage(title: 'Open CSB Door')))),
          ordinaryWidgetRoute: _createRoute(HomePage(title: 'Open CSB Door')),
          haveBeenEntered: ["username", "password"],
        ));
  }

  Route _createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}




