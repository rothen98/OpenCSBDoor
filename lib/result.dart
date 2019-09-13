import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  Result({@required this.success, @required this.text, this.size=50});
  final bool success;
  final String text;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
        
        decoration: new BoxDecoration(
          
          borderRadius: BorderRadius.all(
              Radius.circular(5.0) 
              ),
              
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: new EdgeInsets.only(bottom: 20.0),
                height: this.size,
                width: this.size,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage(this.success
                        ? 'images/success.png'
                        : 'images/error.png'),
                    fit: BoxFit.fill,
                  )
                ),
              ),
              Text(this.text, textAlign: TextAlign.center,)
            ]));
  }
}
