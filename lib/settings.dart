import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'storage.dart';
import 'login_form.dart';
import 'circle_and_square.dart';

final logger = Logger.Logger();

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: SquareInCircle(
            widgetChild: LoginForm(
      onDone: (result) async {
        await Storage.writeValue("username", result.username);
        await Storage.writeValue("password", result.password);
      },
      buttonText: "Change CSB credentials",
    )));
  }
}
