import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:open_csb_door/util/constants.dart';
import 'package:open_csb_door/services/webservice.dart';

class Door{
  final String name;
  final String key;
  final String image;

  Door({this.name, this.key, this.image});

  factory Door.fromJson(Map<String, dynamic> json) {
    return Door(name: json['name'], key: json['key'], image:json['image']);
  }

  static Resource<List<Door>> get all {
    
    return Resource(
      url: Constants.GET_DOORS_URL,
      parse: (response) {
        final result = json.decode(response.body); 
        Iterable list = result['data']['doors'];
        return list.map((model) => Door.fromJson(model)).toList();
      }
    );

  }
}