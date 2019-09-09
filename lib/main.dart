import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;

import 'loading.dart';
import 'dialog.dart';
import 'result.dart';
import 'splash.dart';
import 'init.dart';
import 'storage.dart';
import 'settings.dart';

void main() => runApp(MyApp());

final logger = Logger.Logger();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Open CSB Door',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primaryColor: Colors.blue[300],
            accentColor: Colors.white,
            fontFamily: 'Montserrat',
            textTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              body1: TextStyle(fontSize: 14.0),
            )),

        // Define the default font family.

        home: Splash(
          initWidget: Init(homeWidget: MyHomePage(title: 'Open CSB Door')),
          ordinaryWidget: MyHomePage(title: 'Open CSB Door'),
          haveBeenEntered: ["username", "password"],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool _fetchingData = false;
  DoorResult _doorResult;
  bool _showingSettings = false;

  void _setFetchingData(bool status) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _fetchingData = status;
    });
  }

  void _setDoorResultReceived(DoorResult result) {
    setState(() {
      _doorResult = result;
      _fetchingData = false;
    });
  }

  void _removeDoorResult() {
    setState(() {
      _doorResult = null;
    });
  }

  _toggleSettings() {
    setState(() {
      _showingSettings = !_showingSettings;
    });
  }

  _openDoor() async {
    _setFetchingData(true);

    _callDoorOpener().then((result) {
      _setDoorResultReceived(result);
      //_showTheDialog(result.succes, result.text);
    }, onError: (err) {
      _setDoorResultReceived(
          new DoorResult(succes: false, text: err.toString()));
      //_showTheDialog(false, "An error occured");
    }).then((result) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        _removeDoorResult();
      });
    });
  }

  Future<DoorResult> _callDoorOpener() async {
    logger.i("Open door!");
    String url = 'https://agile-reaches-36891.herokuapp.com/open/';
    Map<String, String> headers = {"Content-type": "application/json"};
    String username = await Storage.readValue("username");
    String password = await Storage.readValue("password");
    String jsonBody =
        '{"username": "' + username + '", "password": "' + password + '"}';
    logger.i(jsonBody);
    http.Response response;
    try {
      response = await http.post(url, headers: headers, body: jsonBody);
    } catch (err) {
      throw Exception("Failed to connect to server...");
    }
    logger.i(response.statusCode);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return DoorResult.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<bool> _onWillPop() async {
    if (_showingSettings) {
      _toggleSettings();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget openOrSettings;

    if (!this._showingSettings) {
      Widget widgetToShow;
      if (_doorResult != null) {
        widgetToShow = Result(
            success: _doorResult != null ? _doorResult.succes : false,
            text: _doorResult != null ? _doorResult.text : "An error occured");
      } else if (_fetchingData) {
        widgetToShow = Loading(
            backgroundColor: Colors.transparent,
            loadingColor: Theme.of(context).accentColor,
            text: "Trying to open your door");
      } else {
        widgetToShow = Column(
          
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: _openDoor,
                  child: Container(
                    height: 240.0,
                    width: 240.0,
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: new AssetImage('images/door.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                        color: Theme.of(context).accentColor),
                  )),
                  SizedBox(height: 40),
                   Container(
                    height: 80.0,
                    width: 80.0,
                    
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).accentColor),
                        child:IconButton(
                          icon: Icon(Icons.settings,color: Colors.black,),onPressed: this._toggleSettings,
                        ))
                  
              /*FlatButton(
              onPressed: _openDoor,
              color: Theme.of(context).accentColor,
              textColor: Theme.of(context).backgroundColor,
              child: Text("Open the door"),
            )*/
            ]);
      }

      openOrSettings = AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Interval(
            0.1,
            0.5,
            curve: Curves.linear,
          ),
          switchOutCurve: Interval(
            0.6,
            1,
            curve: Curves.linear,
          ),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: widgetToShow);
    } else {
      openOrSettings = Column(
          
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Settings(),
              SizedBox(height:40),
              Container(
                    height: 80.0,
                    width: 80.0,
                    
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).accentColor),
                        child:IconButton(
                          icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: this._toggleSettings,
                        ))]);

    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              // Column is also layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    switchInCurve: Interval(
                      0.5,
                      1,
                      curve: Curves.easeIn,
                    ),
                    switchOutCurve: Interval(
                      0.5,
                      1,
                      curve: Curves.linear,
                    ),
                    child: openOrSettings),
              ],
            ),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}

class DoorResult {
  final bool succes;
  final String text;

  DoorResult({this.succes, this.text});

  factory DoorResult.fromJson(Map<String, dynamic> json) {
    return DoorResult(succes: json['succes'], text: json['text']);
  }
}
