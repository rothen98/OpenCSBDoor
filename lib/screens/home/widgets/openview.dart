import 'dart:async';
import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';
import '../../../services/webservice.dart';
import '../../../util/constants.dart';
import '../../../services/storage.dart';
import '../../../models/door.dart';

import 'dart:convert';
import 'loading.dart';
import 'result.dart';
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
    Webservice().post(DoorResult.open(await Storage.readValue(Constants.STORAGE_KEY_USERNAME),
     await Storage.readValue(Constants.STORAGE_KEY_PASSWORD), widget.door.key)).then((result){
       _setDoorResultReceived(result);
     }).catchError((err){
       _setDoorResultReceived(
          new DoorResult(succes: false, text: err.toString()));
     }).then((result) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        _removeDoorResult();
      });
    });
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
            child: Center(child:Padding(padding:EdgeInsets.only(top:3,bottom: 3), child:
                 Result(
                    success: _doorResult != null ? _doorResult.succes : false,
                    text: _doorResult != null
                        ? _doorResult.text
                        : "An error occured"))))
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

  static PostResource<DoorResult> open (String username, String password, String key){
    
    return PostResource(
      url: Constants.POST_OPEN_URL,
      parse: (response) {
        final result = json.decode(response.body); 
        return DoorResult.fromJson(result);
      },
      //headers: {"Content-type": "application/json"},
      body: {"username":username, "password":password, "key":key}
    );

  }
}
