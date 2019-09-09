import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart' as Logger;
import 'storage.dart';
final logger = Logger.Logger();
class Init extends StatefulWidget {
  final Widget homeWidget;

  Init({@required this.homeWidget});

  @override
  InitState createState() => new InitState();
}

class InitState extends State<Init> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _password;

  void _storeData() async {
    //if (this._formKey.currentState.validate()) {
    //_formKey.currentState.save(); // Save our form now.
    
    
    await Storage.writeValue("username", this._username);
    await Storage.writeValue("password", this._password);
    //}
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Center(
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
                this._storeData();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => widget.homeWidget));
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    )));
  }
}
