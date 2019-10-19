import 'package:flutter/material.dart';
class CustomDialog extends StatelessWidget {
  final Widget widgetChild;

  CustomDialog({
    @required this.widgetChild
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }


dialogContent(BuildContext context) {
  return Stack(
    alignment: AlignmentDirectional.center,
    children: <Widget>[
      Container(
  padding: EdgeInsets.only(
    top: Consts.avatarRadius + Consts.padding,
    bottom: Consts.padding,
    left: Consts.padding,
    right: Consts.padding,
  ),
  margin: EdgeInsets.only(top: Consts.avatarRadius),
  decoration: new BoxDecoration(
    color: Colors.white,
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(Consts.padding),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10.0,
        offset: const Offset(0.0, 10.0),
      ),
    ],
  ),
  child: this.widgetChild
),
    ],
  );
}
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}