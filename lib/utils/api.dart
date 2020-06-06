import 'package:http/http.dart' as http;

final String serverURI = 'http://192.168.0.16:8000/';

Future<http.Response> get(String url, dynamic body) async {
  http.Response response = await http.get(serverURI + url);  // check the status code for the result
  return response;
}

Future<http.Response> post(String url, dynamic body) async {
  // Await the http get response, then decode the json-formatted response.
  // print ('Mostrar algo');
  // var response = await http.get(url);
  // print (response.runtimeType);
  // var jsonResponse = convert.jsonDecode(response.body);
  // print (jsonResponse);

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
  // int statusCode = response.statusCode;
  // String body = response.body;
  http.Response response = await http.post(serverURI + url, headers: headers, body: body);  // check the status code for the result
  return response;
}
