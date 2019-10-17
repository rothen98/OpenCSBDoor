import 'dart:async';
import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'storage.dart';
import 'dart:convert';

import 'loading.dart';
import 'result.dart';
import 'door.dart';
import 'link_sharer.dart';
import 'package:flip_card/flip_card.dart';

final logger = Logger.Logger();
typedef void CallBack();

class OpenView extends StatefulWidget {
  final Door door;
  final CallBack switchView;
  final Color backgroundColor;

  OpenView(
      {@required this.door,
      @required this.switchView,
      this.backgroundColor = Colors.white});

  @override
  OpenViewState createState() => new OpenViewState();
}

class OpenViewState extends State<OpenView> {
  bool _tryingToOpen = false;
  DoorResult _doorResult;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  void _setTryingToOpen(bool status) {
    setState(() {
      _tryingToOpen = status;
    });
  }

  void _setDoorResultReceived(DoorResult result) {
    setState(() {
      _doorResult = result;
      _tryingToOpen = false;
    });
  }

  void _removeDoorResult() {
    setState(() {
      _doorResult = null;
    });
  }

  _openDoor() async {
    _setTryingToOpen(true);

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
    String url = 'https://agile-reaches-36891.herokuapp.com/api/open/';
    Map<String, String> headers = {"Content-type": "application/json"};
    String username = await Storage.readValue("username");
    String password = await Storage.readValue("password");
    String key = widget.door.key;
    String jsonBody = '{"username": "' +
        username +
        '", "password": "' +
        password +
        '", "key":"' +
        key +
        '"}';
    logger.i(jsonBody);
    http.Response response;
    try {
      response = await http.post(url, headers: headers, body: jsonBody);
    } catch (err) {
      throw Exception(err.toString());
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

  @override
  Widget build(BuildContext context) {
    Widget expandedText = Expanded(
        child: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              widget.door.name,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.title,
            )));
    Widget widgetToShow;
    if (_tryingToOpen) {
      widgetToShow = Row(children: <Widget>[
        expandedText,
        //Text("test")
        Expanded(
            child: Loading(
                backgroundColor: Colors.transparent,
                loadingColor: Theme.of(context).backgroundColor,
                text: "Trying to open your door"))
      ]);
    } else if (_doorResult != null) {
      widgetToShow =
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        expandedText,
        Expanded(
            child: Center(
                child: Result(
                    success: _doorResult != null ? _doorResult.succes : false,
                    text: _doorResult != null
                        ? _doorResult.text
                        : "An error occured")))
      ]);
    } else {
      widgetToShow = Row(children: <Widget>[
        expandedText,
        Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              GestureDetector(
                onTap: this._openDoor,
                child: Container(child:
                 Center(
                   child: Text(
                     "Open",
                     style:(Theme.of(context).textTheme.button).copyWith(color: Colors.green),))),
              ),
              VerticalDivider(width: 20, color: Colors.transparent),
              GestureDetector(
                  onTap: this.widget.switchView,
                  child: Container(
                      child: Center(
                    child: Text(
                      "Share Link",
                      style:(Theme.of(context).textTheme.button).copyWith(color: Colors.blue),
                    ),
                  )))
            ]))
      ]);
    }
    return widgetToShow;
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
