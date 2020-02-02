import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'button_color.dart';

typedef BackFromLogin(LoginResult result);
final logger = Logger.Logger();

class LoginForm extends StatefulWidget {
  final BackFromLogin onDone;
  final String buttonText;
  final Color backgroundColor;
  final bool disabled;

  LoginForm(
      {@required this.onDone,
      @required this.buttonText,
      this.backgroundColor = Colors.white,
      this.disabled = false});

  @override
  LoginFormState createState() => new LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                keyboardType:
                    TextInputType.number, // Use email input type for emails.
                decoration: new InputDecoration(
                  focusColor: Theme.of(context).colorScheme.onSurface,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                    /*hintText: '10 digit Person number',
                    hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),*/
                    labelText: 'Social Security Number',
                    labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your social security number';
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
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                obscureText: true,
                decoration: new InputDecoration(
                  focusColor: Theme.of(context).colorScheme.onSurface,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 2.0),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  /*hintText: 'Password',
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.onSurface),*/
                  labelText: 'Enter your password',
                  labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface)),
                ),
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
              FlatButton(
                color: Theme.of(context).colorScheme.onSurface,
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if(widget.disabled){return null;}
                  else if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.onDone(new LoginResult(
                        username: this._username, password: this._password));
                    return true;
                  }
                  return false;
                },
                child: Text(
                  widget.buttonText,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Theme.of(context).colorScheme.surface),
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
