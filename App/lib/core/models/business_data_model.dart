import 'package:flutter/material.dart';

class BusinessData with ChangeNotifier {
  Map<String, dynamic> _businessInfo = {};
  String? _profileImageUrl;
  
  Map<String, dynamic> get businessInfo => _businessInfo;
  String? get profileImageUrl => _profileImageUrl;
  
  void updateBusinessInfo(Map<String, dynamic> newInfo, {String? imageUrl}) {
    _businessInfo = newInfo;
    if (imageUrl != null) {
      _profileImageUrl = imageUrl;
    }
    notifyListeners();
  }

  void updateProfileImage(String imageUrl) {
    _profileImageUrl = imageUrl;
    notifyListeners();
  }
}