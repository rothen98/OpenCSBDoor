import 'dart:async';
import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'storage.dart';
import 'dart:convert';

import 'loading.dart';
import 'door.dart';


final logger = Logger.Logger();

class LinkSharer extends StatefulWidget {
  final Door door;
  final Color backgroundColor;
  
  LinkSharer({@required this.door, this.backgroundColor=Colors.white});

  @override
  LinkSharerState createState() => new LinkSharerState();
}

class LinkSharerState extends State<LinkSharer> {
  bool _tryingToFetchLink = false;
  LinkResult _linkResult;
  

 

  void _setTryingToFetchLink(bool status) {
    setState(() {
      _tryingToFetchLink = status;
    });
  }

  void _setLinkResultReceived(LinkResult result) {
    setState(() {
      _linkResult = result;
      _tryingToFetchLink = false;
    });
  }

  void _removeLinkResult() {
    setState(() {
      _linkResult = null;
    });
  }

  _getLink() async {
    _setTryingToFetchLink(true);

    _fetchLink().then((result) {
      _setLinkResultReceived(result);
      //_showTheDialog(result.succes, result.text);
    }, onError: (err) {
      _setLinkResultReceived(
          new LinkResult(succes: false, link:null));
      //_showTheDialog(false, "An error occured");
    });
  }

  Future<LinkResult> _fetchLink() async {

    String url = 'https://agile-reaches-36891.herokuapp.com/api/create_link/';
    Map<String, String> headers = {"Content-type": "application/json"};
    String username = await Storage.readValue("username");
    String password = await Storage.readValue("password");
    String nrOfHours = "3";
    String doorkey = widget.door.key;
    
    String jsonBody = '{"username": "' +
        username +
        '", "password": "' +
        password +
        '", "doorkey":"' +
        doorkey + '", "hours":"' +
        nrOfHours +
        '"}';
    
    http.Response response;
    try {
      response = await http.post(url, headers: headers, body: jsonBody);
    } catch (err) {
      throw Exception(err.toString());
    }

    if (response.statusCode == 200) {
      logger.i(response.body);
      // If server returns an OK response, parse the JSON.
      return LinkResult.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }


  @override
  Widget build(BuildContext context) {
    Widget widgetToShow;
    if (_tryingToFetchLink) {
      widgetToShow = Loading(
          backgroundColor: Colors.transparent,
          loadingColor: Theme.of(context).backgroundColor,
          text: "Trying to fetch a link to open your door"
          );
    } else if (_linkResult != null) {
      widgetToShow = Center(child:_linkResult.succes ? SelectableText(_linkResult.link,):Text("Failed..."));
    } else {
      widgetToShow = Column(children: <Widget>[
        Expanded(child:Text("Create a link which will make it possible for someone to open the door during 3 hours")),
        RaisedButton(
        onPressed: () => _getLink(),
        child: Text('Get a link'),
      ),
           
      ]);
    }
    return 
      Container(
              //height:240,
              //width: 240,
                decoration: new BoxDecoration(
                  color: widget.backgroundColor,
                  //borderRadius: new BorderRadius.all(Radius.circular(40.0)),
                ),
                //child:AnimatedSwitcher(
            child: widgetToShow,
            //duration: const Duration(milliseconds: 500))
            
    
    
  );
  }
}

class LinkResult {
  final bool succes;
  final String link;

  LinkResult({this.succes, this.link});

  factory LinkResult.fromJson(Map<String, dynamic> json) {
    return LinkResult(succes: json['succes'], link: json['result']);
  }
}
