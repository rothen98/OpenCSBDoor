import 'package:logger/logger.dart' as Logger;
import 'package:flutter/material.dart';

import 'linkview.dart';

import 'openview.dart';
import '../../../models/door.dart';

import 'package:flip_card/flip_card.dart';

final logger = Logger.Logger();

class DoorButton extends StatefulWidget {
  final Door door;
  final Color backgroundColor;

  DoorButton({@required this.door, this.backgroundColor = Colors.white});

  @override
  DoorButtonState createState() => new DoorButtonState();
}

class DoorButtonState extends State<DoorButton> {
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: LinkView(door: this.widget.door, switchView: this.switchView),
      ),
    );
  }
}

class CardContainer extends StatelessWidget {
  CardContainer({@required this.child, @required this.backgroundColor});

  final Widget child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: this.child,
        decoration: new BoxDecoration(
          color: this.backgroundColor,
          borderRadius: new BorderRadius.all(const Radius.circular(20.0)),
          boxShadow: [
            new BoxShadow(
              color: Color(0x55000000),
              offset: new Offset(3.0, 5.0),
            )
          ],
        ));
  }
}
