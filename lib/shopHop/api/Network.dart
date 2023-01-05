import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  static Future<NetworkResponse> post(
    String url, {
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
  }) async {
    http.Response response = await http.post(
      Uri.parse(changeUrl(url)),
      headers: headers,
      body: body,
      encoding: encoding,
    );
    return NetworkResponse(response.body, response.statusCode);
  }

  static Future<NetworkResponse> get(
    String url, {
    Map<String, String> headers = const {},
  }) async {
    http.Response response = await http.get(
      Uri.parse(changeUrl(url)),
      headers: headers,
    );
    return NetworkResponse(response.body, response.statusCode);
  }

  static Future<NetworkResponse> delete(
    String url, {
    Map<String, String> headers = const {},
    Object? body,
    Encoding? encoding,
  }) async {
    http.Response response = await http.delete(
      Uri.parse(changeUrl(url)),
      headers: headers,
    );
    return NetworkResponse(response.body, response.statusCode);
  }

  static changeUrl(String url) {
    if (url[url.length - 1] == "/") return url.substring(0, url.length - 1);
    return url;
  }
}

class NetworkResponse {
  late String _body;
  late int _statusCode;
  // late http.Response _baseResponse;

  NetworkResponse(
    String body,
    int statusCode,
  ) {
    this._body = body;
    this._statusCode = statusCode;
    // this._baseResponse = baseResponse;
  }

  int get statusCode => _statusCode;

  String get body => _body;

  // http.Response get baseResponse => _baseResponse;

}
