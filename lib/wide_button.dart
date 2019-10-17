import 'dart:async';
import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_csb_door/linkview.dart';
import 'storage.dart';
import 'dart:convert';

import 'loading.dart';
import 'result.dart';
import 'openview.dart';
import 'door.dart';
import 'link_sharer.dart';
import 'package:flip_card/flip_card.dart';

final logger = Logger.Logger();

class WideButton extends StatefulWidget {
  final Door door;
  final Color backgroundColor;

  WideButton({@required this.door, this.backgroundColor = Colors.white});

  @override
  WideButtonState createState() => new WideButtonState();
}

class WideButtonState extends State<WideButton> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  void switchView() {
    cardKey.currentState.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5,bottom: 5),
      child:
        FlipCard(
        key: cardKey,
        flipOnTouch: false,
        front:Container(child:OpenView(door: this.widget.door, switchView: this.switchView)),
        back: LinkView(door: this.widget.door, switchView: this.switchView),
      ),
      decoration: new BoxDecoration(
          
          color:  this.widget.backgroundColor,
          borderRadius: new BorderRadius.all(const Radius.circular(20.0))
      ),
    );
  }
}
