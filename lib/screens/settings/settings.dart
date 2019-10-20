import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'package:open_csb_door/services/theme_manager.dart';

import 'package:open_csb_door/util/app_themes.dart';
import 'package:provider/provider.dart';
import '../../services/storage.dart';
import '../../util/constants.dart';
import '../../widgets/login_form.dart';

final logger = Logger.Logger();

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              padding: EdgeInsets.all(10),
              child: Builder(builder: (context) {
                return LoginForm(
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
                );
              }),
              decoration: new BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              ),
            ),
            Container(height:300, child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: AppTheme.values.length,
                itemBuilder: (BuildContext context, int index) {
                  // Get theme enum for the current item index
                  final theme = AppTheme.values[index];
                  return Card(
                    // Style the item with corresponding theme color
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: appThemeData[theme].colorScheme.onBackground)
    ),
                    color: appThemeData[theme].colorScheme.background,
                    child: ListTile(
                      onTap: () {
                        // This will trigger notifyListeners and rebuild UI
                        // because of ChangeNotifierProvider in ThemeApp
                        Provider.of<ThemeManager>(context).setTheme(theme);
                      },
                      title: Text(
                        enumName(theme),
                        style: appThemeData[theme].textTheme.body1.copyWith(color:appThemeData[theme].colorScheme.onBackground),
                      ),
                    ),
                  );
                },
              ),
            )),
            /*FlatButton(
              onPressed: () {
                Provider.of<ThemeManager>(context).changeTheme();
              },
              child: Text("Change Theme"),
            ),*/
            Container(
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back)),
                decoration: new BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    borderRadius: new BorderRadius.all(
                      new Radius.circular(10.0),
                    ))),
          ],
        )));
  }
}
