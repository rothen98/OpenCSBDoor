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

class OpenButton extends StatefulWidget {
  final Door door;
  final Color backgroundColor;
  
  OpenButton({@required this.door, this.backgroundColor=Colors.white});

  @override
  OpenButtonState createState() => new OpenButtonState();
}

class OpenButtonState extends State<OpenButton> {
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
    Widget widgetToShow;
    if (_tryingToOpen) {
      widgetToShow = Loading(
          backgroundColor: Colors.transparent,
          loadingColor: Theme.of(context).backgroundColor,
          text: "Trying to open your door"
          );
    } else if (_doorResult != null) {
      widgetToShow = Result(
          success: _doorResult != null ? _doorResult.succes : false,
          text: _doorResult != null ? _doorResult.text : "An error occured");
    } else {
      widgetToShow = Column(children: <Widget>[
        Row( children:<Widget> [Expanded(child:Text(widget.door.name, textAlign: TextAlign.center,)),
        IconButton(
          icon:Icon(Icons.share),
        onPressed: () => cardKey.currentState.toggleCard(),)]
        //child: Text('Toggle'),
      ),
        Expanded(child: 
        /*FittedBox(child:FadeInImage.assetNetwork(
          placeholder: 'images/door.png',
          image: "https://agile-reaches-36891.herokuapp.com" +
              (widget.door.image != null ? widget.door.image : ""),
          fit: BoxFit.contain),fit:BoxFit.contain*/
          Container(
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://agile-reaches-36891.herokuapp.com" +
              (widget.door.image != null ? widget.door.image : "")),
                fit: BoxFit.fitHeight,
              ),
            )))
      ]);
    }
    return FlipCard(
    key: cardKey,
    flipOnTouch: false,
    front: 
      GestureDetector(
        onTap: !_tryingToOpen && _doorResult==null ? _openDoor : null,
        child: Container(
              //height:240,
              //width: 240,
                decoration: new BoxDecoration(
                  color: widget.backgroundColor,
                  //borderRadius: new BorderRadius.all(Radius.circular(40.0)),
                ),
                //child:AnimatedSwitcher(
            child: widgetToShow,
            //duration: const Duration(milliseconds: 500))
            )),
    
    back: Container(child:Column(children: <Widget>[
      Expanded(child:LinkSharer(door:widget.door, backgroundColor: widget.backgroundColor,),
      ),
      RaisedButton(onPressed:  () => cardKey.currentState.toggleCard(),
        child: Text('Back'),)])
    
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
