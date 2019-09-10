import 'package:flutter/material.dart';
class SquareInCircle extends StatelessWidget {
  final Widget widgetChild;

  SquareInCircle({
    @required this.widgetChild
  });

  @override
  Widget build(BuildContext context) {
    return Container(
                height: 380.0,
                width: 380.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).accentColor),
                child: Center(
                    child: Container(
                        height: 260.0,
                        width: 260.0,
                        child: this.widgetChild
                    ))
    );
  }}

