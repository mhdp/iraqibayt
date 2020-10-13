import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DatabaseHelper {

  String serverUrl = "https://iraqibayt.com/api";
  Map<String, dynamic> posts_list ;

  Future<List> get_posts() async {
    String myUrl = "$serverUrl/allposts";
    http.Response response = await http.get(myUrl);
    if(response.body.length > 0){
      posts_list = json.decode(response.body);
    }
  }
}