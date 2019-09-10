import 'dart:async';
import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';

import 'storage.dart';

final logger = Logger.Logger();

class Splash extends StatefulWidget {
  final Route initWidgetRoute;
  final Route ordinaryWidgetRoute;
  final List<String> haveBeenEntered;
  Splash({@required this.initWidgetRoute, @required this.ordinaryWidgetRoute, @required this.haveBeenEntered});

@override
SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
Future checkFirstSeen() async {
    await storage.deleteAll();
    bool entered = await Storage.doesValuesExist(widget.haveBeenEntered);
    
    if (entered) {
    Navigator.of(context).pushReplacement(
        widget.ordinaryWidgetRoute);
    } else {
    Navigator.of(context).pushReplacement(
        widget.initWidgetRoute);
    }
}

@override
void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
    checkFirstSeen();
    });
}

@override
Widget build(BuildContext context) {
    return new Scaffold(
    body: new Center(
        child: new Text('Loading...'),
    ),
    );
}
}