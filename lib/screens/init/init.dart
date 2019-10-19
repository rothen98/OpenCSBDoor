import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import '../../services/storage.dart';
import '../../widgets/circle_and_square.dart';
import '../../widgets/login_form.dart';
import '../../util/constants.dart';


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
                                Constants.STORAGE_KEY_USERNAME, result.username);
                            await Storage.writeValue(
                                Constants.STORAGE_KEY_PASSWORD, result.password);
                            Navigator.of(context).pushReplacement(
                               this.homeWidgetRoute);
                          },
                          buttonText: "Done",
                        ))));
  }
}
