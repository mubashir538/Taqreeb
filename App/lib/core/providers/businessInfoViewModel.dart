import 'package:flutter/material.dart';
import 'package:taqreeb/core/services/api_calls.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/Scaffold.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class BusinessAccountInfoViewModel with ChangeNotifier {
  String _token = '';
  Map<String, dynamic> _user = {};
  bool _isLoading = true;
  List<String> _items = [];
  String _type = "";

  String get token => _token;
  Map<String, dynamic> get user => _user;
  bool get isLoading => _isLoading;
  List<String> get items => _items;
  String get type => _type;

  Future<void> fetch(BuildContext context) async {
    final userid = await MyStorage.getToken(MyTokens.userId) ?? "";
    _type = await MyTokens.getBusinessType();
    ApiCall.fetchAPI(
      'businessowner/accountInfo/$userid/$_type',
      onError: () {
        if (Navigator.of(context).mounted) {
          MyScaffold(text: 'Something Went Wrong!').show(context);
        }
      },
      onSuccess: (token, data) {
        if (Navigator.of(context).mounted) {
          _token = token;
          _user = data;
          _items = _user['categories'].cast<String>().toList() ?? [];
          _isLoading = false;
          notifyListeners();
        }
      },
    );
  }
}
