import 'package:flutter/material.dart';

class InheritedToken extends InheritedWidget {
  final String token;
  

  InheritedToken(this.token, child): super(child:child);
  
  @override
  bool updateShouldNotify(InheritedToken old) =>
    token != old.token;

  static InheritedToken of(BuildContext context) =>
    context.dependOnInheritedWidgetOfExactType<InheritedToken>();
}