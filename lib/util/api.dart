import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
// import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:laundry/util/session.dart';

class Api {
  Client client = new Client();
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };

  Future<Response> post(String endpoint, {bool auth = false, Map<String, dynamic> body}) async {
    var auth_data = await sessions.loadAuth();
    if (auth == true && auth_data != null) requestHeaders['Authorization'] = "Bearer ${auth_data}";
    return client.post("http://laundry.sinudtech.web.id/api/v1/$endpoint", headers: requestHeaders, body: jsonEncode(body));
  }
  
  Future<Response> oAuth({Map<String, dynamic> body}) async {
    return client.post("http://laundry.sinudtech.web.id/api/user/login", headers: requestHeaders, body: jsonEncode(body));
  }
  
  String getContent(String data) {
    var result = jsonDecode(data)['data'];
    return result.runtimeType == String ? result : jsonEncode(result);
  }
  
  String getError(String data) {
    var result = jsonDecode(data)['error'];
    return result;
  }

  close() {
    client.close();
    client = new Client();
  }
  
}
final api = new Api();