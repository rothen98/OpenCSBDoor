import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Loading(
      {@required this.loadingColor, @required this.backgroundColor, this.text, this.size});
  final Color loadingColor;
  final Color backgroundColor;
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: this.size,
        width:this.size,
        decoration: new BoxDecoration(
          color: this.backgroundColor,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: SpinKitChasingDots(
                    color: this.loadingColor,
                    size: this.size-60,
                  )),
              Text(this.text)
            ]));
  }
}
