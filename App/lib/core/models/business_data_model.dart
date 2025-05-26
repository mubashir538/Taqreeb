import 'package:flutter/material.dart';

class BusinessData with ChangeNotifier {
  Map<String, dynamic> _businessInfo = {};
  String? _profileImageUrl;
  int _listings = 0;

  Map<String, dynamic> get businessInfo => _businessInfo;
  String? get profileImageUrl => _profileImageUrl;
  int get listings => _listings;

  void updateBusinessInfo(Map<String, dynamic> newInfo, int listingInfo,
      {String? imageUrl}) {
    _businessInfo = newInfo;
    _listings = listingInfo;
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
