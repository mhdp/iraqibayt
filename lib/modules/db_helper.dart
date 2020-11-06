import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DatabaseHelper {

  String serverUrl = "https://iraqibayt.com/api";
  Map<String, dynamic> posts_list ;
  Map<String, dynamic> get_post_by_id_list ;

  Future<List> get_posts() async {
    String myUrl = "$serverUrl/allposts_api";
    http.Response response = await http.post(myUrl);
    if(response.body.length > 0){
      posts_list = json.decode(response.body);
      //print(posts_list.toString());
    }
  }

  Future<List> get_post_by_id(String id) async {
    String myUrl = "$serverUrl/get_post_by_id";
    http.Response response = await http.post(myUrl,
        body: {
      "id": "$id",
    });


    if(response.body.length > 0){
      //print(response.body.toString());
      get_post_by_id_list = json.decode(response.body);
      //print(posts_list.toString());
    }
  }
}