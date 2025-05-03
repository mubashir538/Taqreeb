import 'package:flutter/material.dart';
import 'package:taqreeb/Components/Dialogs%20&%20Toasts/my_scaffold.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class ApiCall {
  static Future<void> fetchAPI(
    String endpoint, {
    required Function(String token, Map<String, dynamic> data) onSuccess,
    Function()? onError,
    BuildContext? context,
    bool refresh = false,
    String type = 'get',
    Map<String, dynamic>? body = const {},
    Map<String, dynamic>? params, // Add params parameter
  }) async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final data;
    if (type == 'get') {
      data = await MyApi.getRequest(
        endpoint: endpoint,
        context: context,
        refresh: refresh,
        headers: {'Authorization': 'Bearer $token'},
        params: params, // Pass params to getRequest
      );
    } else {
      data = await MyApi.postRequest(
        endpoint: endpoint,
        body: body,
        headers: {'Authorization': 'Bearer $token'},
      );
    }
    if (data == null || data['status'] == 'error') {
      if (token.isEmpty) {
        if (onError != null) {
          onError();
        } else if (context?.mounted == true) {
          MyScaffold(text: 'You are not logged in!').show(context!);
        }
        return;
      }
    } else {
      onSuccess(token, data);
    }
  }

  static void updateListingDetails(
      {required Map<String, dynamic> listing,
      required Function(bool isLoading, bool ischange) updateState,
      required List<String> imageUrls,
      required List<String> addonsheadings,
      required List<String> addonsvalues,
      required List<String> values,
      required List<String> starsvalue,
      List<String> searchValues = const []}) {
    // Clear existing data
    imageUrls.clear();
    addonsheadings.clear();
    addonsvalues.clear();
    values.clear();
    starsvalue.clear();

    // Update listing details
    for (var i = 0; i < listing['pictures'].length; i++) {
      imageUrls.add(listing['pictures'][i]['picturePath']);
    }

    for (var i = 0; i < listing['Addons'].length; i++) {
      addonsheadings.add(listing['Addons'][i]['name']);
      if (listing['Addons'][i]['isPer']) {
        addonsvalues.add(
            '${listing['Addons'][i]['price'].toString()}/${listing['Addons'][i]['perType'].toString()}');
      } else {
        addonsvalues.add(listing['Addons'][i]['price'].toString());
      }
    }

    for (int i = 0; i < searchValues.length; i++) {
      if (searchValues[i] == 'guestminAllowed') {
        values.add(
            '${listing['View'][searchValues[i]].toString()}-${listing['View'][searchValues[i + 1]].toString()}');
        break;
      }
      values.add(listing['View'][searchValues[i]].toString());
    }
    starsvalue.add('(${listing['reviewData']['s5'].toString()})');
    starsvalue.add('(${listing['reviewData']['s4'].toString()})');
    starsvalue.add('(${listing['reviewData']['s3'].toString()})');
    starsvalue.add('(${listing['reviewData']['s2'].toString()})');
    starsvalue.add('(${listing['reviewData']['s1'].toString()})');

    // Update state
    updateState(false, true); // Set isLoading = false, ischange = true
  }
}
