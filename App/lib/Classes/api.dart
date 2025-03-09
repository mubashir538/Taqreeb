import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taqreeb/config/config.dart';

class MyApi {
  static String baseUrl = AppConfig.baseUrl;
  static Future<dynamic> getRequest({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    Uri url = Uri.parse('$baseUrl$endpoint');

    http.Response response;

    try {
      if (headers != null) {
        response = await http.get(url, headers: headers);
      } else {
        response = await http.get(url);
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Something went wrong"};
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  static Future<dynamic> postRequest(
      {required String endpoint,
      Map<String, String>? headers,
      required dynamic body}) async {
    Uri url = Uri.parse('$baseUrl$endpoint');

    if (headers == null) {
      headers = {
        "Content-Type": "application/json",
      };
    } else {
      headers["Content-Type"] = "application/json";
    }

    http.Response response;
    try {
      response = await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Something went wrong"};
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
