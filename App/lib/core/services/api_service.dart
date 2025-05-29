import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as https;
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/core/config/config.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class MyApi {
  static String baseUrl = AppConfig.baseUrl;
  static DefaultCacheManager cacheManager = DefaultCacheManager();

  // Add this static method to check internet connectivity
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<dynamic> getRequest({
    bool refresh = false,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? params, // Add params parameter
    BuildContext? context,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    // First check internet connection
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    }

    // Build URI with parameters
    final Uri url = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters:
          params?.map((key, value) => MapEntry(key, value.toString())),
    );

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
              .timeout(const Duration(seconds: 2));

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
        if (context != null) {
          MyScaffold(text: 'Request timed out. Please try again.')
              .show(context);
        }
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
        if (context != null) {
          MyScaffold(text: 'Server error. Please try again later.')
              .show(context);
        }
        throw HttpException(
            'Server responded with status code ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      return _handleTimeoutError(cacheKey, e.toString(), context);
    } on SocketException catch (e) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return _handleNetworkError(cacheKey, e.toString(), context);
    } on HttpException catch (e) {
      if (context != null) {
        MyScaffold(
                text: 'Server is not working. Please try again after sometime.')
            .show(context);
      }
      return _handleHttpError(cacheKey, e.toString(), context);
    } catch (e, stackTrace) {
      return _handleGenericError(cacheKey, e, stackTrace, endpoint, context);
    }
  }

  // Updated helper methods with context parameter
  static Future<Map<String, dynamic>> _handleTimeoutError(
      String cacheKey, String error, BuildContext? context) async {
    try {
      final cachedFile = await cacheManager.getSingleFile(cacheKey);
      if (await cachedFile.exists()) {
        final fallbackData = await cachedFile.readAsString();
        if (context != null) {
          MyScaffold(text: 'Request timed out. Showing cached data.')
              .show(context);
        }
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
      String cacheKey, String error, BuildContext? context) async {
    try {
      final cachedFile = await cacheManager.getSingleFile(cacheKey);
      if (await cachedFile.exists()) {
        final fallbackData = await cachedFile.readAsString();
        if (context != null) {
          MyScaffold(text: 'Network unavailable. Showing cached data.')
              .show(context);
        }
        return {
          ...jsonDecode(fallbackData),
          'cache': true,
          'warning': 'Network unavailable. Showing cached data.',
        };
      }
    } catch (_) {}

    if (context != null) {
      context.pushNamedTransition(
          routeName: '/NoInternet',
          type: PageTransitionType.rightToLeftWithFade,
          duration: Duration(milliseconds: 300));
    }

    return {
      "status": "error",
      "message": "Network unavailable. Please check your connection.",
      "error": error,
    };
  }

  static Future<Map<String, dynamic>> _handleHttpError(
      String cacheKey, String error, BuildContext? context) async {
    try {
      final cachedFile = await cacheManager.getSingleFile(cacheKey);
      if (await cachedFile.exists()) {
        final fallbackData = await cachedFile.readAsString();
        if (context != null) {
          MyScaffold(text: 'Server error. Showing cached data.').show(context);
        }
        return {
          ...jsonDecode(fallbackData),
          'cache': true,
          'warning': 'Server error. Showing cached data.',
        };
      }
    } catch (_) {}

    if (context != null) {
      MyScaffold(
              text: 'Server is not working. Please try again after sometime.')
          .show(context);
    }

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
    BuildContext? context,
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
        if (context != null) {
          MyScaffold(text: 'Showing cached data due to an error.')
              .show(context);
        }
        return {
          ...jsonDecode(fallbackData),
          'cache': true,
          'warning': 'Showing cached data due to an error.',
        };
      }
    } catch (_) {}

    if (context != null) {
      MyScaffold(text: 'Something went wrong. Please try again.').show(context);
    }

    return {
      "status": "error",
      "message": "Something went wrong. Please try again.",
      "error": error.toString(),
    };
  }

  // Update all other methods similarly with context parameter and error handling
  static Future<dynamic> postRequest({
    required String endpoint,
    Map<String, String>? headers,
    required dynamic body,
    BuildContext? context,
  }) async {
    // Check internet first
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    }

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
      response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 20), onTimeout: () {
        if (context != null) {
          MyScaffold(text: 'Request timed out. Please try again.')
              .show(context);
        }
        throw TimeoutException('Request timed out');
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        if (context != null) {
          MyScaffold(text: 'Server error. Please try again later.')
              .show(context);
        }
        return {
          "status": "error",
          "message": "Server error: ${response.statusCode}"
        };
      }
    } on SocketException catch (_) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    } catch (e) {
      if (context != null) {
        MyScaffold(text: 'Something went wrong. Please try again.')
            .show(context);
      }
      unawaited(MyApi.postRequest(
          context: context,
          endpoint: 'error/application',
          body: {'error': 'Error: $e'}));
      return {
        "status": "error",
        "message": "Something went wrong",
        "error": e.toString(),
      };
    }
  }

  static Future<dynamic> postMultipartRequest({
    required String endpoint,
    bool token = true,
    Map<String, String>? headers,
    required dynamic body,
    required Map<String, dynamic> files,
    BuildContext? context,
  }) async {
    // Check internet first
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    }

    final request =
        https.MultipartRequest('POST', Uri.parse(MyApi.baseUrl + endpoint));
    try {
      // Handle files - updated to support both single files and lists of files
      for (final entry in files.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is List) {
          // Handle list of files (like your 'pictures' case)
          for (final filePath in value) {
            if (filePath is String) {
              request.files.add(await https.MultipartFile.fromPath(
                key,
                filePath,
              ));
            }
          }
        } else if (value is String) {
          // Handle single file
          request.files.add(await https.MultipartFile.fromPath(
            key,
            value,
          ));
        }
      }

      if (token) {
        final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
        request.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }

      if (body is Map) {
        for (final entry in body.entries) {
          request.fields[entry.key] = entry.value;
        }
      }

      final response = await request.send().timeout(const Duration(seconds: 30),
          onTimeout: () {
        if (context != null) {
          MyScaffold(text: 'Request timed out. Please try again.')
              .show(context);
        }
        throw TimeoutException('Request timed out');
      });

      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse;
      } else {
        if (context != null) {
          MyScaffold(text: 'Server error. Please try again later.')
              .show(context);
        }
        return {
          "status": "error",
          "message": "Server error: ${response.statusCode}"
        };
      }
    } on SocketException catch (_) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    } catch (e) {
      if (context != null) {
        MyScaffold(text: 'Something went wrong. Please try again.')
            .show(context);
      }
      unawaited(MyApi.postRequest(
          context: context,
          endpoint: 'error/application',
          body: {'error': 'Error: $e'}));
      return {
        "status": "error",
        "message": "Something went wrong",
        "error": e.toString(),
      };
    }
  }


  static Future<dynamic> deleteRequest({
    required String endpoint,
    Map<String, String>? headers,
    BuildContext? context,
  }) async {
    // Check internet first
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    }

    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final requestHeaders = headers ?? {};
      requestHeaders['Content-Type'] = 'application/json';

      final response = await http
          .delete(
        url,
        headers: requestHeaders,
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        if (context != null) {
          MyScaffold(text: 'Request timed out. Please try again.')
              .show(context);
        }
        throw TimeoutException('Request timed out');
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {"status": "success", "message": "Item deleted successfully"};
      } else {
        if (context != null) {
          MyScaffold(text: 'Server error. Please try again later.')
              .show(context);
        }
        return {
          "status": "error",
          "message": "Server error: ${response.statusCode}",
          "error": response.body,
        };
      }
    } on SocketException catch (_) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    } catch (e, stackTrace) {
      if (context != null) {
        MyScaffold(text: 'Something went wrong. Please try again.')
            .show(context);
      }
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
    BuildContext? context,
  }) async {
    // Check internet first
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    }

    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      final requestHeaders = headers ?? {};
      requestHeaders['Content-Type'] = 'application/json';

      final response = await http
          .put(
        url,
        headers: requestHeaders,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 10), onTimeout: () {
        if (context != null) {
          MyScaffold(text: 'Request timed out. Please try again.')
              .show(context);
        }
        throw TimeoutException('Request timed out');
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        if (context != null) {
          MyScaffold(text: 'Server error. Please try again later.')
              .show(context);
        }
        return {
          "status": "error",
          "message": "Server error: ${response.statusCode}",
          "error": response.body,
        };
      }
    } on SocketException catch (_) {
      if (context != null) {
        context.pushNamedTransition(
            routeName: '/NoInternet',
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 300));
      }
      return {
        "status": "error",
        "message": "No internet connection",
      };
    } catch (e, stackTrace) {
      if (context != null) {
        MyScaffold(text: 'Something went wrong. Please try again.')
            .show(context);
      }
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
    } catch (_) {}
  }

  static Future<Map<String, dynamic>> sendChatbotMessage({
    required String userId,
    required String message,
    BuildContext? context,
  }) async {
    return await postRequest(
      endpoint: 'chatbot/',
      body: {
        'user_id': userId,
        'message': message,
      },
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
      },
      context: context,
    );
  }

  static Future<void> deleteCache(String url) async {
    await DefaultCacheManager().removeFile(baseUrl + url);
  }
}
