import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'package:open_csb_door/webservice.dart';

import 'loading.dart';

import 'result.dart';
import 'splash.dart';
import 'init.dart';
import 'storage.dart';
import 'settings.dart';
import 'open_button.dart';
import 'door.dart';

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
          initWidgetRoute: _createRoute(Init(
              homeWidgetRoute:
                  _createRoute(MyHomePage(title: 'Open CSB Door')))),
          ordinaryWidgetRoute: _createRoute(MyHomePage(title: 'Open CSB Door')),
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
  List<Door> _doors = new List();
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

  _toggleSettings() {
    setState(() {
      _showingSettings = !_showingSettings;
    });
  }

  @override
  void initState() {
    _fetchingData = true;
    _populateDoors();
    super.initState();
  }

  void _populateDoors() async {
    //todo implment with webservice
    http.Response response;
    try {
      response = await http.get(
          'https://agile-reaches-36891.herokuapp.com/api/doors/',
          headers: {"Accept": "application/json"});
    } catch (err) {
      throw Exception(err.toString());
    }
    logger.i(response.statusCode);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      final result = json.decode(response.body);
      Iterable list = result['doors'];
      List<Door> doors = list.map((model) => Door.fromJson(model)).toList();
      logger.i(doors.toString());
      setState(() {
        _fetchingData=false;
        _doors = doors;
      });
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

  Container _buildItemsForListView(BuildContext context, int index) {
      return Container(
        child:Center(child:OpenButton(door:_doors[index], size:240))//OpenButton(door:_doors[index])
      );
  }

  @override
  Widget build(BuildContext context) {
    Widget openOrSettings;

    if (!this._showingSettings) {
      
      Widget widgetToShow = Column(children:<Widget>[ListView.separated(
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,

          itemCount: _doors.length,
          itemBuilder: _buildItemsForListView,
          separatorBuilder: (BuildContext context, int index) => const Divider(color: Colors.transparent,),
        ), Container(
                          height: 80.0,
                          width: 80.0,
                          
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).accentColor),
                              child:IconButton(
                                icon: Icon(Icons.settings,color: Colors.black,),onPressed: this._toggleSettings,
                              ))]);
      

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
            SizedBox(height: 40),
            Container(
                height: 80.0,
                width: 80.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: this._toggleSettings,
                ))
          ]);
    }
    
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: SingleChildScrollView(
                child: Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
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
            )));
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
