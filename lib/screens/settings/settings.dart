import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import '../../services/storage.dart';
import '../../util/constants.dart';
import '../../widgets/login_form.dart';
import '../../widgets/circle_and_square.dart';

final logger = Logger.Logger();

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.all(10),
              child: Builder(builder:(context){return LoginForm(
                onDone: (result) async {
                  await Storage.writeValue(
                      Constants.STORAGE_KEY_USERNAME, result.username);
                  await Storage.writeValue(
                      Constants.STORAGE_KEY_PASSWORD, result.password);
                  
                  Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text("Saved"),
    ));
                },
                buttonText: "Change CSB credentials",
              );}),
              decoration: new BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              ),
            ),
            Container(child:IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
                decoration: new BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0),
              ))),
          ],
        )));
  }
}
