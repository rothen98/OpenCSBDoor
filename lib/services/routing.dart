import 'package:flutter/material.dart';
import 'package:open_csb_door/screens/home/home.dart';
import 'package:open_csb_door/screens/settings/settings.dart';
import 'package:open_csb_door/screens/init/init.dart';
import 'package:open_csb_door/screens/splash/splash.dart';
import 'package:open_csb_door/util/constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Constants.HOME_ROUTE:
        return MaterialPageRoute(builder: (_) => HomePage());
      case Constants.INIT_ROUTE:
        return MaterialPageRoute(builder: (_) => InitPage());
      case Constants.SETTINGS_ROUTE:
        return routerBuilder(SettingsPage());
        case Constants.SPLASH_ROUTE:
        return MaterialPageRoute(builder: (_) => Splash());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }

  static Route routerBuilder(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionDuration: Duration(milliseconds: 700),
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