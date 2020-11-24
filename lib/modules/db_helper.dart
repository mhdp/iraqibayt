import 'dart:convert';

import 'package:http/http.dart' as http;


class DatabaseHelper {
  String default_post_image = "";
  String serverUrl = "https://iraqibayt.com/api";
  Map<String, dynamic> posts_list;
  var spicial_posts_list;
  var all_spicial_posts_list;
  var latest_posts_list;
  Map<String, dynamic> my_posts_list;
  Map<String, dynamic> my_posts_favorits_list;
  List<dynamic> get_post_by_id_list;

  var login_status = false;
  var register_status = false;
  String user_name = "";
  int user_id = 0;
  String userToken = ' ';

  Future<List> get_posts() async {
    String myUrl = "$serverUrl/allposts_api";
    http.Response response = await http.post(myUrl);
    if (response.body.length > 0) {
      posts_list = json.decode(response.body);
      //print(posts_list.toString());
    }
  }

  Future<List> get_spicial_posts() async {
    String myUrl = "$serverUrl/get_spical_posts_api";
    http.Response response = await http.post(myUrl);
    if (response.body.length > 0) {
      //print(response.body.toString());
      spicial_posts_list = json.decode(response.body);
      //print(posts_list.toString());
    }
  }

  Future<List> get_all_spicial_posts() async {
    String myUrl = "$serverUrl/get_all_spical_posts_api";
    http.Response response = await http.post(myUrl);
    if (response.body.length > 0) {
      //print(response.body.toString());
      all_spicial_posts_list = json.decode(response.body);
      //print(posts_list.toString());
    }
  }

  Future<List> get_latest_posts() async {
    String myUrl = "$serverUrl/get_latest_posts_api";
    http.Response response = await http.post(myUrl);
    if (response.body.length > 0) {
      //print(response.body.toString());
      latest_posts_list = json.decode(response.body);
      //print(posts_list.toString());
    }
  }

  Future<List> get_my_posts(String email, String pass) async {
    String myUrl = "$serverUrl/get_my_posts_api";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
      'password': pass,
    });
    if (response.body.length > 0) {
      my_posts_list = json.decode(response.body);
      //print(posts_list.toString());
    }
  }

  Future<List> get_my_posts_favorits(String email, String pass) async {
    String myUrl = "$serverUrl/users/favorit";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
      'password': pass,
    });
    if (response.body.length > 0) {
      print(response.body.toString());
      my_posts_favorits_list = json.decode(response.body);
      //print(posts_list.toString());
    }
  }

  Future<List> getAdvSearchResults(
    int categoryId,
    List<int> subCategories,
    int cityId,
    List<int> regions,
    int sortBy,
  ) async {
    String myUrl = "$serverUrl/posts_search_adv";

    //Define post request body
    Map<String, String> postBody = new Map<String, String>();
    //Add static entries
    postBody.putIfAbsent('category', () => categoryId.toString());
    postBody.putIfAbsent('city', () => cityId.toString());
    postBody.putIfAbsent('sortBy', () => sortBy.toString());
    //Add dynamic entries
    subCategories.forEach((element) {
      postBody.putIfAbsent('subCats%5B%5D', () => element.toString());
      print('subCats[]=' + element.toString());
    });
    regions.forEach((element) {
      postBody.putIfAbsent('regions%5B%5D', () => element.toString());
      print('regions[]=' + element.toString());
    });

    http.Response response = await http.post(myUrl, body: postBody);
    if (response.body.length > 0) {
      posts_list = json.decode(response.body);
      print(posts_list.toString());
    }
  }

  Future<List> get_post_by_id(String id) async {
    String myUrl = "$serverUrl/get_post_by_id";
    http.Response response = await http.post(myUrl, body: {
      "id": "$id",
    });

    if (response.body.length > 0) {
      //print(response.body.toString());
      get_post_by_id_list = json.decode(response.body);
      //print(posts_list.toString());

      print("response ${get_post_by_id_list.length.toString()}");
    }
  }

  Future<List> get_default_post_image() async {
    String myUrl = "$serverUrl/get_default_post_image";
    http.Response response = await http.post(myUrl);
    if (response.body.length > 0) {
      default_post_image = response.body;
      //print(posts_list.toString());
    }
  }

  loginData(
    String pass,
    String email,
  ) async {
    String myUrl = "$serverUrl/login";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
      'password': pass,
    });

    /*var data = {
      'email': email,
      'password': pass,
    };*/

    //var res = await CallApi().postData(data, '/login');
    //var body = json.decode(res.body);
    print("reuselt: ${response.body}");

    if (response.body.toString().contains("true")) {
      login_status = true;
      var data = json.decode(response.body);
      user_name = data["user"]["name"];
      user_id = data["user"]["id"];
      userToken = data["user"]["customToken"];
    } else {
      login_status = false;
    }
  }

  registerData(String pass, String name, String email) async {
    print('ok');
    String myUrl = "$serverUrl/register";
    http.Response response = await http.post(myUrl, body: {
      'email': email,
      'password': pass,
      'name': name,
      'password_confirmation': pass,
    });

    /*var data = {
      'email': email,
      'password': pass,
    };*/

    //var res = await CallApi().postData(data, '/login');
    //var body = json.decode(res.body);
    print("reuselt: ${response.body}");

    if (response.body.toString().contains("true")) {
      register_status = true;
      var data = json.decode(response.body);
      user_id = data["user"]["id"];
    } else {
      register_status = false;
    }
  }
}
