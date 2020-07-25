import 'package:http/http.dart' as http;
import 'package:nomoni_app/utils/user_prefs.dart';

final String serverURI = 'http://192.168.0.254:8000/';

Map<String, String> getHeaders() {
  String jwt = UserPrefs.instance.jwt;

  bool emptyToken = ["", null, false, 0].contains(jwt);
  if (!emptyToken) {
    return {
      // 'Accept': 'application/json, text/plain, */*',    
      // 'Accept-Encoding': 'gzip, deflate',
      // 'Accept-Language': 'es-MX,es;q=0.8,en-US;q=0.5,en;q=0.3',
      // 'Cache-Control': 'no-cache'
      // 'Connection': 'keep-alive',
      // 'Content-Type': 'application/x-www-form-urlencoded',
      // 'Host': 'api.nomoni.localhost',
      // 'Pragma': 'no-cache',
      'Authorization': "Bearer $jwt"
    };
  }
  return {};
}

Future<http.Response> get(String url) {
  print('______________________________________________________GET: ' + serverURI + url);
  return http.get(serverURI + url, headers: getHeaders());
}

Future<http.Response> post(String url, dynamic body) {
  print('______________________________________________________POST: ' + serverURI + url);
  return http.post(serverURI + url, headers: getHeaders(), body: body);
}

Future<http.Response> delete(String url) {
  print('______________________________________________________DEL: ' + serverURI + url);
  return http.delete(serverURI + url, headers: getHeaders());
}
