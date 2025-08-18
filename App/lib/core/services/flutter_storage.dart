import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class MyStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String value, String key) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getToken(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> deleteToken(String key) async {
    await _storage.delete(key: key);
  }

  static Future<bool> exists(String key) async {
    if (await _storage.containsKey(key: key)) {
      return true;
    }
    return false;
  }

  static Future<String?> yourFCM() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $token");
      return token;
    } catch (e) {
      print("Error fetching FCM token: $e");
      return null;
    }
  }

  static Future<void> saveChatHistory(String key, String history) async {
    await _storage.write(key: key, value: history);
  }

  static Future<String?> getChatHistory(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> clearChatHistory(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> savePendingEventPlan(
      String key, Map<String, dynamic> plan) async {
    await _storage.write(key: '${key}_plan', value: jsonEncode(plan));
  }

  static Future<Map<String, dynamic>?> getPendingEventPlan(String key) async {
    final plan = await _storage.read(key: '${key}_plan');
    return plan != null ? Map<String, dynamic>.from(jsonDecode(plan)) : null;
  }

  static Future<void> clearPendingEventPlan(String key) async {
    await _storage.delete(key: '${key}_plan');
  }
}
