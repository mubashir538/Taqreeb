import 'package:http/http.dart' as http;

class AppConfig {
  //static const String ngrok = 'https://c1f8-202-47-47-248.ngrok-free.app';
  static String ipFromGoogle =
      'https://docs.google.com/document/d/18nsdmLEpSqVjxJu0dhtCKfB1282H1FAYuCpM7q8eFkM/export?format=txt';

  static void fetchIp() async {
    // final response = await MyApi.getRequest(endpoint: ipFromGoogle);
    final response = await http.get(Uri.parse(ipFromGoogle));

    if (response.statusCode == 200) {
      ngrok = response.body.toString().trim();
    }
  }

  static String ngrok = 'https://da35-119-155-186-192.ngrok-free.app';
  static String baseUrl = "${AppConfig.ngrok}/app/";
  static const String appName = "Taqreeb App";
  static const String version = "1.0.0";
}
