import 'dart:async';
import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';
import 'package:open_csb_door/services/storage.dart';
import 'package:open_csb_door/util/constants.dart';


final logger = Logger.Logger();

class Splash extends StatefulWidget {
  

@override
SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
Future checkFirstSeen() async {
    //await storage.deleteAll();
    bool entered = await Storage.doesValuesExist([Constants.STORAGE_KEY_USERNAME,Constants.STORAGE_KEY_PASSWORD]);
    
    if (entered) {
    Navigator.pushReplacementNamed(context, Constants.HOME_ROUTE);
    } else {
    Navigator.pushReplacementNamed(context, Constants.INIT_ROUTE);
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
    body: Center(
        child: Text(
          "Open the door!",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).colorScheme.onBackground))
    ),
    );
}
}