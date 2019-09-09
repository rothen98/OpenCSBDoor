import 'package:flutter/material.dart';

import 'package:logger/logger.dart' as Logger;
import 'storage.dart';
import 'login_form.dart';
final logger = Logger.Logger();
class Settings extends StatefulWidget {
  

  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return new Center(
            child: 
            LoginForm(
              onDone: (result) async {
                await Storage.writeValue("username", result.username);
                await Storage.writeValue("password", result.password);
                
              },
              buttonText: "Change CSB credentials",
            )/*Form(
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
                this._storeData();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => widget.homeWidget));
              }
            },
            child: Text('Submit'),
          ),
        ],*/
    );
  }
}
