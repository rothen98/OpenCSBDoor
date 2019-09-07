import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  Loading({@required this.loadingColor, @required this.backgroundColor});
  final Color loadingColor;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: new BoxDecoration(
      color: this.backgroundColor,
    ),
    child: SpinKitChasingDots(
                  color: this.loadingColor,
                  size: 100.0,
                ),
    );
  }
}