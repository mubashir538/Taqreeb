import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/core/models/business_data_model.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class BusinessAccountInfoViewModel with ChangeNotifier {
  BusinessData businessData;
  Map<String, dynamic> _userInfo = {};
  bool _isLoading = false; // Initialize as false
  List<String> _items = [];
  String _type = "";
  bool _hasData = false; // Add this flag

  BusinessAccountInfoViewModel(this.businessData);

  bool get isLoading => _isLoading;
  List<String> get items => _items;
  String get type => _type;
  Map<String, dynamic> get userInfo => _userInfo;

// In BusinessAccountInfoViewModel
  Future<void> fetch(BuildContext context) async {
    // Only fetch if we don't have data already
    if (_hasData) return;

    _isLoading = true;
    notifyListeners();

    try {
      final userid = await MyStorage.getToken(MyTokens.userId) ?? "";
      _type = await MyTokens.getBusinessType();

      await ApiCall.fetchAPI(
        'businessowner/accountInfo/$userid/$_type',
        onSuccess: (token, data) {
          _userInfo = data['userinfo'] ?? {};
          print('$data');
          businessData.updateBusinessInfo(
              data['businessInfo'], data['listingCount'],
              imageUrl:
                  "${MyApi.baseUrl.substring(0, MyApi.baseUrl.length - 1)}${data['businessInfo']["profilepic"]}");
          _items = data['categories']?.cast<String>()?.toList() ?? [];
          _isLoading = false;
          _hasData = true; // Set flag to true
          notifyListeners();
        },
        onError: () {
          _isLoading = false;
          notifyListeners();
          MyScaffold(text: 'Failed to load data').show(context);
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      MyScaffold(text: 'Error: ${e.toString()}').show(context);
    }
  }
}
