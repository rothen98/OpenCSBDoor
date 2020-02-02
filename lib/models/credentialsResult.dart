import 'dart:convert';

import 'package:open_csb_door/services/webservice.dart';
import 'package:open_csb_door/util/constants.dart';

class CredentialsResult {
  final bool succes;
  final String text;

  CredentialsResult({this.succes, this.text});

  factory CredentialsResult.fromJson(Map<String, dynamic> json) {
    return CredentialsResult(succes: json['status']=="success", text: json['data']['text']);
  }

  static PostResource<CredentialsResult> validate (String username, String password){
    
    return PostResource(
      url: Constants.POST_VALID_URL,
      parse: (response) {
        final result = json.decode(response.body); 
        return CredentialsResult.fromJson(result);
      },
      //headers: {"Content-type": "application/json"},
      body: {"username":username, "password":password}
    );

  }
}