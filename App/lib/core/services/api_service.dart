import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as https;
import 'package:http/http.dart' as http;
import 'package:taqreeb/core/config/config.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class MyApi {
  static String baseUrl = AppConfig.baseUrl;
  static DefaultCacheManager cacheManager = DefaultCacheManager();
  static Future<dynamic> getRequest({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    Uri url = Uri.parse('$baseUrl$endpoint');

    http.Response response;
    final cache = await cacheManager.getFileFromCache(url.toString());
    if (cache == null) {
      try {
        if (headers != null) {
          response = await http.get(url, headers: headers);
        } else {
          response = await http.get(url);
        }
        await cacheManager.putFile(url.toString(), response.bodyBytes,
            fileExtension: 'json', maxAge: const Duration(hours: 1));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return jsonDecode(response.body);
        } else {
          return {"status": "error", "message": "Something went wrong"};
        }
      } catch (e) {
        MyApi.postRequest(
            endpoint: 'error/application', body: {'error': 'Error: $e'});
      }
    } else {
      final cachedData = await cacheManager.getSingleFile(
        url.toString(),
        headers: headers,
      );
      final data = jsonDecode(await cachedData.readAsString());
      return data;
    }
  }

  static Future<void> deleteCache(String url) async {
    await DefaultCacheManager().removeFile(baseUrl + url);
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
      MyApi.postRequest(
          endpoint: 'error/application', body: {'error': 'Error: $e'});
    }
  }

  static Future<dynamic> postMultipartRequest(
      {required String endpoint,
      bool token = true,
      Map<String, String>? headers,
      required dynamic body,
      required Map<String, dynamic> files}) async {
    final request =
        https.MultipartRequest('POST', Uri.parse(MyApi.baseUrl + endpoint));

    for (int i = 0; i < files.length; i++) {
      request.files.add(await https.MultipartFile.fromPath(
        files.keys.toList()[i],
        files.values.toList()[i],
      ));
    }
    if (token) {
      final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });
    }

    for (int i = 0; i < body.length; i++) {
      request.fields[body.keys.toList()[i]] = body.values.toList()[i];
    }
    final response = await request.send();
    print('executed');
    try {
      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse;
      } else {
        return {"status": "error", "message": "Something went wrong"};
      }
    } catch (e) {
      MyApi.postRequest(
          endpoint: 'error/application', body: {'error': 'Error: $e'});
    }
  }
}
