import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Resource<T> {
  final String url; 
  T Function(Response response) parse;

  Resource({this.url,this.parse});
}

class PostResource<T>{
  final String url;
  T Function(Response response) parse;
  Map<String, String> headers;
  Map<String, String> body;
  PostResource({this.url,this.parse, this.headers, this.body});
}

class Webservice {

  Future<T> load<T>(Resource<T> resource) async {

      final response = await http.get(resource.url);
      if(response.statusCode == 200) {
        return resource.parse(response);
      } else {
        throw Exception('Failed to load data!');
      }
  }

  Future<T> post<T>(PostResource<T> resource) async{
      final response = await http.post(resource.url,body:resource.body,headers:resource.headers);
      if(response.statusCode == 200) {
        return resource.parse(response);
      } else {
        throw Exception('Failed to post data!');
      }
  }
  

  

}