import 'dart:convert';
import 'package:http/http.dart' as http;

class InternetController{
  final String baseUrl = "http://192.168.6.128:8888";

  Future<http.Response> startRegistration(String rCode) {
    return http.post(
      baseUrl + "/preregistration",
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'registrationCode': rCode,
      }),
    );
  }

}