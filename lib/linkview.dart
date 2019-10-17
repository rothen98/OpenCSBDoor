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

class LinkView extends StatefulWidget {
  final Door door;
  final CallBack switchView;
  final Color backgroundColor;

  LinkView(
      {@required this.door,
      @required this.switchView,
      this.backgroundColor = Colors.white});

  @override
  LinkViewState createState() => new LinkViewState();
}

class LinkViewState extends State<LinkView> {
  bool _tryingToFetchLink = false;
  LinkResult _linkResult;

  void _setTryingToFetchLink(bool status) {
    setState(() {
      _tryingToFetchLink = status;
    });
  }

  void _resetLinkResult(){
    setState(() {
      _linkResult = null;
    });
    
  }

  void _setLinkResultReceived(LinkResult result) {
    setState(() {
      _linkResult = result;
      _tryingToFetchLink = false;
    });
  }

  

  _getLink() async {
    _setTryingToFetchLink(true);

    _fetchLink().then((result) {
      _setLinkResultReceived(result);
      //_showTheDialog(result.succes, result.text);
    }, onError: (err) {
      _setLinkResultReceived(new LinkResult(succes: false, link: null));
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
        doorkey +
        '", "hours":"' +
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
    if (_tryingToFetchLink) {
      return Loading(
          backgroundColor: Colors.transparent,
          loadingColor: Theme.of(context).backgroundColor,
          text: "Trying to fetch a link to open your door");
    }else if (_linkResult != null) {
      return Row(
        children: <Widget>[
         Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: (){
                    this._resetLinkResult();
                    this.widget.switchView();
                  },
                  
                  child: new Text("Back"),
                )),
        Expanded(child:Center(child:_linkResult.succes ? SelectableText("https://opencsbdoor.com/key/"+_linkResult.link,):Text("Failed...")))]);
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: this.widget.switchView,
                  child: new Text("Back"),
                )),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text("active for "),
                    Text(" 3 "),
                    Text(" hours "),
                  ]),
                  Row(children: <Widget>[
                    Text("can be used "),
                    Text(" 1 "),
                    Text(" time"),
                  ]),
                ]),
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: this._getLink,
                  child: Text("Get Link",style:(Theme.of(context).textTheme.button).copyWith(color: Colors.blue)),
                ))
          ]);
    }
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
