import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import '../../services/storage.dart';
import '../../widgets/login_form.dart';
import '../../util/constants.dart';

final logger = Logger.Logger();

class Init extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: new Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Please enter your CSB credentials", style:Theme.of(context).textTheme.title.copyWith(color:Theme.of(context).colorScheme.onBackground)),
                  SizedBox(height:30),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                padding: EdgeInsets.all(10),
                child: LoginForm(
                  onDone: (result) async {
                    await Storage.writeValue(
                        Constants.STORAGE_KEY_USERNAME, result.username);
                    await Storage.writeValue(
                        Constants.STORAGE_KEY_PASSWORD, result.password);
                    Navigator.pushReplacementNamed(
                        context, Constants.HOME_ROUTE);
                  },
                  buttonText: "Done",
                ),
                decoration: new BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                ),
              )
            ])));
  }
}
