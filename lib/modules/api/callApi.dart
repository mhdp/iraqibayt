import 'package:http/http.dart' as http;
import 'dart:convert';

class CallApi {
  final String base_url = 'https://iraqibayt.com/';

  postData(data, apiUrl) async {
    var fullUrl = base_url + apiUrl;
    return await http.post(
      fullUrl,
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  getData(apiUrl) async {
    var fullUrl = base_url + apiUrl;
    return await http.get(
      fullUrl,
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
