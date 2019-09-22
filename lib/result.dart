import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  Result({@required this.success, @required this.text});
  final bool success;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: new BoxDecoration(
          
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) 
              ),
              
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child:
              Container(
                //margin: new EdgeInsets.only(bottom: 20.0),
                //height: this.size,
                //width: this.size,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage(this.success
                        ? 'images/success.png'
                        : 'images/error.png'),
                    fit: BoxFit.fitHeight,
                  )
                ),
              )),
              Text(this.text, textAlign: TextAlign.center,)
            ]));
  }
}
