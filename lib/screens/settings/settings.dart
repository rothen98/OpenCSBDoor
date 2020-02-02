import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'package:open_csb_door/models/credentialsResult.dart';
import 'package:open_csb_door/services/theme_manager.dart';
import 'package:open_csb_door/services/webservice.dart';

import 'package:open_csb_door/util/app_themes.dart';
import 'package:provider/provider.dart';
import '../../services/storage.dart';
import '../../util/constants.dart';
import '../../widgets/login_form.dart';

final logger = Logger.Logger();

class SettingsPage extends StatefulWidget {
  SettingsPage() : super();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _validating = false;
  bool _invalid = false;
  bool _connectionError = false;

  void _setValidating(bool status) {
    if(mounted){
    setState(() {
      _validating = status;
    });
  }
  }

  void _setInvalid(bool status) {
    if(mounted){
    setState(() {
      _invalid = status;
    });}
  }

  void _setConnectionError(bool status) {
    if(mounted){
    setState(() {
      _connectionError = status;
    });}
  }

  Future<bool> _validatingCredentials(String username, String password) async {
    _setValidating(true);
    _setInvalid(false);
    _setConnectionError(false);
    try {
      CredentialsResult result = await Webservice()
          .post(CredentialsResult.validate(username, password));
      if (result.succes) {
        _setValidating(false);
        return true;
      } else {
        _setValidating(false);
        _setInvalid(true);
        return false;
      }
    } catch (err) {
      logger.i("Catch: " + err);
      _setValidating(false);
      _setConnectionError(true);
      return false;
    }
  }

  
  _buildErrorMessage(){
      return _createInfoMessage("Connection error :( ");
  }
  _buildInvalidMessage(){
    return _createInfoMessage("Invalid credentials :( ");
  }
  _buildValidating(){
    return _createInfoMessage("Validating the credentials...");
  }

  Widget _createInfoMessage(String s){
    return Text(s, style:Theme.of(context).textTheme.display1.copyWith(color:Theme.of(context).colorScheme.onBackground));
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
            child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      padding: EdgeInsets.all(10),
                      child: Builder(builder: (context) {
                        return LoginForm(disabled: _validating,
                          onDone: (result) async {
                            bool val = await _validatingCredentials(
                                result.username, result.password);
                            if (val && mounted) {
                              await Storage.writeValue(
                                  Constants.STORAGE_KEY_USERNAME,
                                  result.username);
                              await Storage.writeValue(
                                  Constants.STORAGE_KEY_PASSWORD,
                                  result.password);

                              Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text("Saved"),
                              ));
                            }
                          },
                          buttonText: "Change CSB credentials",
                        );
                      }),
                      decoration: new BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(10.0)),
                      ),
                    ),
                    if (_validating) _buildValidating(),
                    if (_invalid) _buildInvalidMessage(),
                    if (_connectionError) _buildErrorMessage(),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: AppTheme.values.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Get theme enum for the current item index
                          final theme = AppTheme.values[index];
                          return Card(
                            // Style the item with corresponding theme color
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: appThemeData[theme]
                                        .colorScheme
                                        .onBackground)),
                            color: appThemeData[theme].colorScheme.background,
                            child: ListTile(
                              onTap: () {
                                // This will trigger notifyListeners and rebuild UI
                                // because of ChangeNotifierProvider in ThemeApp
                                Provider.of<ThemeManager>(context)
                                    .setTheme(theme);
                              },
                              title: Text(
                                enumName(theme),
                                style: appThemeData[theme]
                                    .textTheme
                                    .body1
                                    .copyWith(
                                        color: appThemeData[theme]
                                            .colorScheme
                                            .onBackground),
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
                ))));
  }
}
