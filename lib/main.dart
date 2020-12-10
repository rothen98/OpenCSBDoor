import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:logger/logger.dart' as Logger;
import 'package:open_csb_door/services/routing.dart' as Routing;
import 'package:open_csb_door/services/theme_manager.dart';
import 'package:open_csb_door/util/constants.dart';
import 'package:open_csb_door/widgets/token_inherited.dart';
import 'package:provider/provider.dart';

///This is the root of the application.

void main() => runApp(MyApp());

final logger = Logger.Logger();

class MyApp extends StatefulWidget {
  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();
}

class _PushMessagingExampleState extends State<MyApp> {
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  String _token;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    _firebaseMessaging.getToken().then((token){
      print(token);
      setState(() {
       _token=token; 
      });
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onMessage: $message");
        _showItemDialog(message);
        /**/
      },
      onLaunch: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        setState(() {
          _messageText = "Push Messaging message: $message";
        });
        print("onResume: $message");
      },
      onBackgroundMessage: _backgroundMessageHandler,
    );
  }

  void _showItemDialog(Map<String,dynamic> message){
    print("Show dialog!");
    print(message['notification']['title']);
    showDialog(
          context: context,
          builder: (context) { return AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );},
        );
  }

  @override
  Widget build(BuildContext buildcontext) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return InheritedToken(this._token, ChangeNotifierProvider(
        //Here we provide our ThemeManager to child widget tree
        builder: (_) => ThemeManager(),
        //Consumer will call builder method each time ThemeManager calls notifyListeners()
        child: Consumer<ThemeManager>(builder: (buildcontext, manager, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Open CSB Door',
            theme: (manager.themeData),
            onGenerateRoute: Routing.Router.generateRoute,
            initialRoute: Constants.SPLASH_ROUTE,
          );
        })));
  }
}

Future<dynamic> _backgroundMessageHandler(Map<String, dynamic> message) {
  print("_backgroundMessageHandler");
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("_backgroundMessageHandler data: ${data}");
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("_backgroundMessageHandler notification: ${notification}");
  }
}
