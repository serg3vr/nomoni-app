import 'package:http/http.dart' as http;

final String serverURI = 'http://192.168.0.254:8000/';

Future<http.Response> get(String url, dynamic body) async {
  http.Response response = await http.get(serverURI + url);  // check the status code for the result
  return response;
}

Future<http.Response> post(String url, dynamic body) {

  Map<String, String> headers = {
    // 'Accept': 'application/json, text/plain, */*',    
    // 'Accept-Encoding': 'gzip, deflate',
    // 'Accept-Language': 'es-MX,es;q=0.8,en-US;q=0.5,en;q=0.3',
    // 'Cache-Control': 'no-cache'
    // 'Connection': 'keep-alive',
    // 'Content-Type': 'application/x-www-form-urlencoded',
    // 'Host': 'api.nomoni.localhost',
    // 'Pragma': 'no-cache',
  };
  return http.post(serverURI + url, headers: headers, body: body);
}
