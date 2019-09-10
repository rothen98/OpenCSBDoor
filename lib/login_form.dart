import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'button_color.dart';

typedef BackFromLogin(LoginResult result);
final logger = Logger.Logger();

class LoginForm extends StatefulWidget {
  final BackFromLogin onDone;
  final String buttonText;
  final Color backgroundColor;

  LoginForm({@required this.onDone, @required this.buttonText, this.backgroundColor=Colors.white});

  @override
  LoginFormState createState() => new LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _password;
  

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType
                        .number, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: '10 digit Person number',
                        labelText: 'Person number',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your person number';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      this._username = value;
                    },
                  ),
                  SizedBox(
                  height: 15,
                ),
                  TextFormField(
                    
                    obscureText: true,
                    decoration: new InputDecoration(
                        hintText: 'Password', 
                        labelText: 'Enter your password',
                        border: OutlineInputBorder(),),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (String value) {
                      this._password = value;
                    },
                  ),
                  SizedBox(
                  height: 15,
                ),
                  ChangeRaisedButtonColor(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        widget.onDone(new LoginResult(
                            username: this._username,
                            password: this._password));
                            return true;
                      }
                      return false;
                    },
                  fromColor: Colors.blue,
                  toColor: Colors.green,
                  
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                  
                ],
              ),
            ));
  }
}

class LoginResult {
  String username;
  String password;
  LoginResult({this.username, this.password});
}
