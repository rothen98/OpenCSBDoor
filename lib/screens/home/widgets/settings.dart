import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import '../../../services/storage.dart';
import '../../../util/constants.dart';
import '../../../widgets/login_form.dart';
import '../../../widgets/circle_and_square.dart';

final logger = Logger.Logger();

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child: SquareInCircle(
            widgetChild: LoginForm(
      onDone: (result) async {
        await Storage.writeValue(Constants.STORAGE_KEY_USERNAME, result.username);
        await Storage.writeValue(Constants.STORAGE_KEY_PASSWORD, result.password);
      },
      buttonText: "Change CSB credentials",
    )));
  }
}
