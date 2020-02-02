/*import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'package:open_csb_door/models/credentialsResult.dart';
import 'package:open_csb_door/services/webservice.dart';
import '../../services/storage.dart';
import '../../widgets/login_form.dart';
import '../../util/constants.dart';

final logger = Logger.Logger();
typedef void OnDone();
class InitPage extends StatefulWidget {
  final OnDone onDone;
  InitPage(this.onDone);

  

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool _validating = false;
  bool _invalid = false;
  bool _connectionError = false;

  void _setValidating(bool status) {
    setState(() {
      _validating = status;
    });
  }
  void _setInvalid(bool status) {
    setState(() {
      _invalid = status;
    });
  }
  void _setConnectionError(bool status) {
    setState(() {
      _connectionError = status;
    });
  }

  Future<bool> _validatingCredentials(String username, String password) async {
    _setValidating(true);
    _setInvalid(false);
    _setConnectionError(false);
    try{
      CredentialsResult result = await Webservice().post(CredentialsResult.validate(username,
     password));
     if(result.succes){
       _setValidating(false);
         return true;
     }else{
       _setValidating(false);
         _setInvalid(true);
         return false;
     }
    }catch (err){
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
        body: new Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Please enter your CSB credentials", textAlign: TextAlign.center, style:Theme.of(context).textTheme.headline.copyWith(color:Theme.of(context).colorScheme.onBackground)),
                  SizedBox(height:30),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                padding: EdgeInsets.all(10),
                child: LoginForm(disabled: this._validating,
                  onDone: (result) async {
                    bool val = await _validatingCredentials(result.username, result.password);
                    if (val){
                      await Storage.writeValue(
                          Constants.STORAGE_KEY_USERNAME, result.username);
                      await Storage.writeValue(
                          Constants.STORAGE_KEY_PASSWORD, result.password);
                      Navigator.pushReplacementNamed(
                          context, Constants.HOME_ROUTE);
                    }
                  },
                  buttonText: "Done",
                ),
                decoration: new BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                ),
              ),
              SizedBox(height:30),
              if(_validating) _buildValidating(),
              if(_invalid) _buildInvalidMessage(),
              if(_connectionError) _buildErrorMessage()
            ])));
  }
}
*/

