import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'package:open_csb_door/services/routing.dart';
import 'package:open_csb_door/services/theme_manager.dart';
//import 'package:open_csb_door/services/theme.dart';
import 'package:open_csb_door/util/constants.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

void main() => runApp(MyApp());

final logger = Logger.Logger();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext buildcontext) {
    return ChangeNotifierProvider(
        //Here we provide our ThemeManager to child widget tree
        builder: (_) => ThemeManager(),
        //Consumer will call builder method each time ThemeManager calls notifyListeners()
        child: Consumer<ThemeManager>(builder: (buildcontext, manager, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Open CSB Door',
            theme: (manager.themeData),
            onGenerateRoute: Router.generateRoute,
            initialRoute: Constants.SPLASH_ROUTE,
          );
        }));
  }
}
