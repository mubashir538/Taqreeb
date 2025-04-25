import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
    bool refresh = false,
    required String endpoint,
    Map<String, String>? headers,
    Duration timeout =
        const Duration(seconds: 10), // Default timeout of 10 seconds
  }) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');
    final String cacheKey = url.toString();

    try {
      if (headers != null) {
        headers['Content-Type'] = 'application/json';
      } else {
        headers = {'Content-Type': 'application/json'};
      }

      // Try loading from cache first (if not refresh)
      if (!refresh) {
        try {
          final cachedFile = await cacheManager
              .getSingleFile(cacheKey, headers: headers)
              .timeout(
                  const Duration(seconds: 2)); // Short timeout for cache access

          if (await cachedFile.exists()) {
            final cachedData = await cachedFile.readAsString();
            return jsonDecode(cachedData);
          }
        } catch (_) {
          // Cache access failed or timed out, proceed to network request
        }
      }

      // Network request with timeout
      final response =
          await http.get(url, headers: headers).timeout(timeout, onTimeout: () {
        throw TimeoutException(
            'The request timed out after ${timeout.inSeconds} seconds');
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Save to cache (non-blocking)
        unawaited(cacheManager.putFile(
          cacheKey,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 1),
        ));
        return jsonDecode(response.body);
      } else {
        // Server returned an error status code
        throw HttpException(
            'Server responded with status code ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // Handle timeout specifically
      return _handleTimeoutError(cacheKey, e.toString());
    } on SocketException catch (e) {
      // Handle network connectivity issues
      return _handleNetworkError(cacheKey, e.toString());
    } on HttpException catch (e) {
      // Handle HTTP errors
      return _handleHttpError(cacheKey, e.toString());
    } catch (e, stackTrace) {
      // Generic error handling
      return _handleGenericError(cacheKey, e, stackTrace, endpoint);
    }
  }

// Helper methods for different error scenarios
  static Future<Map<String, dynamic>> _handleTimeoutError(
      String cacheKey, String error) async {
    try {
      final cachedFile = await cacheManager.getSingleFile(cacheKey);
      if (await cachedFile.exists()) {
        final fallbackData = await cachedFile.readAsString();
        return {
          ...jsonDecode(fallbackData),
          'cache': true,
          'warning': 'Request timed out. Showing cached data.',
        };
      }
    } catch (_) {}

    return {
      "status": "error",
      "message":
          "Request timed out. Please check your connection and try again.",
      "error": error,
    };
  }

  static Future<Map<String, dynamic>> _handleNetworkError(
      String cacheKey, String error) async {
    try {
      final cachedFile = await cacheManager.getSingleFile(cacheKey);
      if (await cachedFile.exists()) {
        final fallbackData = await cachedFile.readAsString();
        return {
          ...jsonDecode(fallbackData),
          'cache': true,
          'warning': 'Network unavailable. Showing cached data.',
        };
      }
    } catch (_) {}

    return {
      "status": "error",
      "message": "Network unavailable. Please check your connection.",
      "error": error,
    };
  }

  static Future<Map<String, dynamic>> _handleHttpError(
      String cacheKey, String error) async {
    try {
      final cachedFile = await cacheManager.getSingleFile(cacheKey);
      if (await cachedFile.exists()) {
        final fallbackData = await cachedFile.readAsString();
        return {
          ...jsonDecode(fallbackData),
          'cache': true,
          'warning': 'Server error. Showing cached data.',
        };
      }
    } catch (_) {}

    return {
      "status": "error",
      "message": "Server error occurred.",
      "error": error,
    };
  }

  static Future<Map<String, dynamic>> _handleGenericError(
    String cacheKey,
    dynamic error,
    StackTrace stackTrace,
    String endpoint,
  ) async {
    // Log the error to your backend (non-blocking)
    unawaited(MyApi.postRequest(
      endpoint: 'error/application',
      body: {
        'error': error.toString(),
        'stack': stackTrace.toString(),
        'endpoint': endpoint,
      },
    ));

    // Try to load from cache as a fallback
    try {
      final cachedFile = await cacheManager.getSingleFile(cacheKey);
      if (await cachedFile.exists()) {
        final fallbackData = await cachedFile.readAsString();
        return {
          ...jsonDecode(fallbackData),
          'cache': true,
          'warning': 'Showing cached data due to an error.',
        };
      }
    } catch (_) {}

    return {
      "status": "error",
      "message": "Something went wrong. Please try again.",
      "error": error.toString(),
    };
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

  static Future<dynamic> deleteRequest({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      // Add default headers if needed
      final requestHeaders = headers ?? {};
      requestHeaders['Content-Type'] = 'application/json';

      final response = await http
          .delete(
            url,
            headers: requestHeaders,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // For DELETE, often the response body is empty on success
        return response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {"status": "success", "message": "Item deleted successfully"};
      } else {
        return {
          "status": "error",
          "message": "Server error: ${response.statusCode}",
          "error": response.body,
        };
      }
    } catch (e, stackTrace) {
      // Log the error (non-blocking)
      unawaited(_logError(e, stackTrace, endpoint, 'DELETE'));

      return {
        "status": "error",
        "message": "Failed to delete item. Please try again.",
        "error": e.toString(),
      };
    }
  }

  static Future<dynamic> putRequest({
    required String endpoint,
    Map<String, String>? headers,
    required Map<String, dynamic> body,
  }) async {
    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      // Add default headers if needed
      final requestHeaders = headers ?? {};
      requestHeaders['Content-Type'] = 'application/json';

      final response = await http
          .put(
            url,
            headers: requestHeaders,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        return {
          "status": "error",
          "message": "Server error: ${response.statusCode}",
          "error": response.body,
        };
      }
    } catch (e, stackTrace) {
      // Log the error (non-blocking)
      unawaited(_logError(e, stackTrace, endpoint, 'PUT'));

      return {
        "status": "error",
        "message": "Failed to update item. Please try again.",
        "error": e.toString(),
      };
    }
  }

  static Future<void> _logError(
    dynamic error,
    StackTrace stackTrace,
    String endpoint,
    String method,
  ) async {
    try {
      // You can implement your error logging mechanism here
      // For example, send to your backend error tracking system
      await MyApi.postRequest(
        endpoint: 'error/log',
        body: {
          'error': error.toString(),
          'stack': stackTrace.toString(),
          'endpoint': endpoint,
          'method': method,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (_) {
      // Silently fail if error logging fails
    }
  }
}
