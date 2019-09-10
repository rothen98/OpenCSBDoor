import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'storage.dart';
import 'login_form.dart';
import 'circle_and_square.dart';

final logger = Logger.Logger();

class Init extends StatelessWidget {
  final Route homeWidgetRoute;

  Init({@required this.homeWidgetRoute});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: new Center(
            child: SquareInCircle(widgetChild: LoginForm(
                          onDone: (result) async {
                            await Storage.writeValue(
                                "username", result.username);
                            await Storage.writeValue(
                                "password", result.password);
                            Navigator.of(context).pushReplacement(
                               this.homeWidgetRoute);
                          },
                          buttonText: "Done",
                        ))));
  }
}
