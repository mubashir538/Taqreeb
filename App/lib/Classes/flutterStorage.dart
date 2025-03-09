import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
}
