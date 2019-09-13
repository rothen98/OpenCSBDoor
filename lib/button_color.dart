import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as Logger;

final logger = Logger.Logger();
typedef bool ButtonPressed();

class ChangeRaisedButtonColor extends StatefulWidget {
  final Color fromColor;
  final Color toColor;
  final Widget child;
  final ButtonPressed onPressed;

  ChangeRaisedButtonColor(
      {this.fromColor: Colors.blue,
      this.toColor: Colors.green,
      @required this.child,
      @required this.onPressed});

  @override
  ChangeRaisedButtonColorState createState() => ChangeRaisedButtonColorState();
}

class ChangeRaisedButtonColorState extends State<ChangeRaisedButtonColor>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _colorTween;

  
  @override
void dispose() {
  _animationController.dispose();
  super.dispose();
}
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _colorTween = ColorTween(begin: widget.fromColor, end: widget.toColor)
        .animate(_animationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => RaisedButton(
        child: widget.child,
        color: _colorTween.value,
        onPressed: () async {
          if (_animationController.status == AnimationStatus.dismissed) {
            logger.i("Pressed!");
            if (widget.onPressed()) {
              
              await _animationController.forward();
              await Future.delayed(Duration(milliseconds: 500), () async {
                await _animationController.reverse();
              });
            }

            
          }
        },
      ),
    );
  }
}
