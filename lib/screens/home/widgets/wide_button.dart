import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';

import 'linkview.dart';

import 'openview.dart';
import '../../../models/door.dart';

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
    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: CardContainer(
          backgroundColor: this.widget.backgroundColor,
          child: OpenView(door: this.widget.door, switchView: this.switchView)),
      back: CardContainer(
        backgroundColor: Colors.blue[100],
        child: LinkView(door: this.widget.door, switchView: this.switchView),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  CardContainer({@required this.child, @required this.backgroundColor});

  Widget child;
  Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: this.child,
        decoration: new BoxDecoration(
            color: this.backgroundColor,
            borderRadius: new BorderRadius.all(const Radius.circular(20.0))));
  }
}
