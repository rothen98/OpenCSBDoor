import 'dart:async';
import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage.dart';

final logger = Logger.Logger();

class Splash extends StatefulWidget {
  final Widget initWidget;
  final Widget ordinaryWidget;
  final List<String> haveBeenEntered;
  Splash({@required this.initWidget, @required this.ordinaryWidget, @required this.haveBeenEntered});

@override
SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
Future checkFirstSeen() async {
    
    bool entered = await Storage.doesValuesExist(widget.haveBeenEntered);
    
    if (entered) {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => widget.ordinaryWidget));
    } else {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => widget.initWidget));
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