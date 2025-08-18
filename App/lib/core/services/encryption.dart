import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();

  factory EncryptionService() => _instance;

  final Encrypter _aesEncrypter;
  final IV _iv;

  EncryptionService._internal()
      : _aesEncrypter = Encrypter(
          AES(Key.fromUtf8('kZ2T74ufNlVmjPe9B8K2vQ==')),
        ),
        _iv = IV.fromLength(16); // You can customize the IV if needed

  String encryptMessage(String plainText) {
    try {
      return _aesEncrypter.encrypt(plainText, iv: _iv).base64;
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  String decryptMessage(String encryptedText) {
    try {
      return _aesEncrypter.decrypt64(encryptedText, iv: _iv);
    } catch (e) {
      throw Exception('Decryption failed: $e');
    }
  }
}
