import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';
import 'package:open_csb_door/widgets/token_inherited.dart';
import '../../../util/constants.dart';
import '../../../services/webservice.dart';
import '../../../services/storage.dart';

import '../../../models/door.dart';
import 'dart:convert';

import 'loading.dart';

import 'package:flutter_picker/flutter_picker.dart';

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
  int _nrOfHours = 1;
  int _nrOfUses = 1;
  //Rfinal GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _setTryingToFetchLink(bool status) {
    setState(() {
      _tryingToFetchLink = status;
    });
  }

  void _setNrOfHours(int hours) {
    setState(() {
      _nrOfHours = hours;
    });
  }

  void _setNrOfUses(int uses) {
    setState(() {
      _nrOfUses = uses;
    });
  }

  void _resetLinkResult() {
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

  showPickerNumber(BuildContext context) {
    Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 1, end: 10),
          NumberPickerColumn(begin: 1, end: 10),
        ]),
        delimiter: [
          PickerDelimiter(
              child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ))
        ],
        // confirm: Text("Confirm", style: Theme.of(context).textTheme.display2,),
        confirmTextStyle: TextStyle(color: Colors.black),
        cancelTextStyle: TextStyle(color: Colors.black),
        hideHeader: true,
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text("Uses"), Text("Hours")],
        ),
        //confirm: GestureDetector(child:Text("Confirm"),onTap:(){

        //}),
        onConfirm: (Picker picker, List value) {
          int uses = picker.getSelectedValues()[0];
          int hours = picker.getSelectedValues()[1];
          if (uses != null) {
            this._setNrOfUses(uses);
          }
          if (hours != null) {
            this._setNrOfHours(hours);
          }

          //logger.i(picker.getSelectedValues()[0]);
        }).showDialog(context);
  }

  _getLink() async {
    _setTryingToFetchLink(true);
    Webservice()
        .post(LinkResult.createLink(
            await Storage.readValue("username"),
            await Storage.readValue("password"),
            widget.door.key,
            _nrOfHours.toString(),
            _nrOfUses.toString(),
            InheritedToken.of(context).token))
        .then((result) {
      _setLinkResultReceived(result);
    }).catchError((err) {
      logger.i(err);
      _setLinkResultReceived(new LinkResult(succes: false, link: null));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_tryingToFetchLink) {
      return Loading(
          backgroundColor: Colors.transparent,
          loadingColor: Theme.of(context).colorScheme.onSurface,
          text: "Trying to fetch a link to open your door");
    } else if (_linkResult != null) {
      return Row(children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: IconButton(
              onPressed: () {
                this.widget.switchView();
                this._resetLinkResult();
                
              },
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.onSurface),
            ) /*GestureDetector(
                  onTap: this.widget.switchView,
                  child: new Text("Back"),
                )*/
            ),
        Expanded(
            child: Center(
                child: _linkResult.succes
                    ? SelectableText(
                        Constants.LINK_OPENER_URL + _linkResult.link,
                        style: Theme.of(context).textTheme.body1.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      )
                    : Text("Failed...",
                        style: Theme.of(context).textTheme.body1.copyWith(
                            color: Theme.of(context).colorScheme.onSurface))))
      ]);
    } else {
      String use = (this._nrOfUses <= 1 ? " use " : " uses ");
      String hour = (this._nrOfHours <= 1 ? " hour" : " hours");
      String usesAndHours =
          this._nrOfUses.toString() + use + this._nrOfHours.toString() + hour;

      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: IconButton(
                  onPressed: this.widget.switchView,
                  icon: Icon(Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onSurface),
                ) /*GestureDetector(
                  onTap: this.widget.switchView,
                  child: new Text("Back"),
                )*/
                ),
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text(usesAndHours,
                        style: Theme.of(context).textTheme.subhead.copyWith(
                            color: Theme.of(context).colorScheme.onSurface))
                  ]),
                  GestureDetector(
                      child: Text("Change",
                          style: Theme.of(context).textTheme.button.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryVariant)),
                      onTap: () {
                        this.showPickerNumber(context);
                      }),
                ]),
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: this._getLink,
                  child: Text("Get Link",
                      style: (Theme.of(context).textTheme.button).copyWith(
                          color: Theme.of(context).colorScheme.secondary)),
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
    return LinkResult(succes: json['status']=="success", link: json['data']['result']);
  }
  static PostResource<LinkResult> createLink(
      String username, String password, String key, String hours, String uses, String device) {
    return PostResource(
        url: Constants.POST_CREATE_LINK_URL,
        parse: (response) {
          final result = json.decode(response.body);
          return LinkResult.fromJson(result);
        },
        //headers: {"Content-type": "application/json"},
        body: {
          "username": username,
          "password": password,
          "doorkey": key,
          "hours": hours,
          "uses": uses,
          "device":device
        });
  }
}
