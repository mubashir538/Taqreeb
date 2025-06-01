import 'package:http/http.dart' as http;

class AppConfig {
  //static const String ngrok = 'https://c1f8-202-47-47-248.ngrok-free.app';
  static String ipFromGoogle =
      'https://docs.google.com/document/d/1Mhizi_P-xZyllsPCWAGjkmtWK9FC_IVM54GqO5Ifefg/export?format=txt';

  static Future<String> fetchIp() async {
    // final response = await MyApi.getRequest(endpoint: ipFromGoogle);
    final response = await http.get(Uri.parse(ipFromGoogle));

    if (response.statusCode == 200) {
      return response.body.toString().trim();
    }
    return '';
  }

  static String ngrok = 'https://9e57-202-47-47-248.ngrok-free.app';
  static String baseUrl = "${AppConfig.ngrok}/app/";
  static const String appName = "Taqreeb App";
  static const String version = "1.0.0";
}
