import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
typedef BackFromLogin(LoginResult result); 
final logger = Logger.Logger();
class  LoginForm extends StatefulWidget {
  
  final BackFromLogin onDone;
  final String buttonText;

  LoginForm({@required this.onDone, @required this.buttonText});

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
            keyboardType: TextInputType.number, // Use email input type for emails.
                decoration: new InputDecoration(
                  hintText: '10 digit Person number',
                  labelText: 'Person number'
                ),
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
          TextFormField(
            obscureText: true, // Use email input type for emails.
                decoration: new InputDecoration(
                  hintText: 'Password',
                  labelText: 'Enter your password'
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
          RaisedButton(
            onPressed: () {
              // Validate will return true if the form is valid, or false if
              // the form is invalid.
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onDone(new LoginResult(username:this._username, password:this._password));
              }
            },
            child: Text(widget.buttonText),
          ),
        ],
      ),
    ));
  }
}

class LoginResult{
  String username;
  String password;
  LoginResult({this.username,this.password});
}
