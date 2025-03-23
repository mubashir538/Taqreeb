import 'dart:async';

import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class ApiCall {
  static void fetchAPI(
    String endpoint, {
    required Function(String token, Map<String, dynamic> listing) onSuccess,
    required Function() onError,
  }) async {
    final token = await MyStorage.getToken(MyTokens.accessToken) ?? "";
    final listing = await MyApi.getRequest(
      endpoint: endpoint,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (listing == null || listing['status'] == 'error') {
      onError();
    }
    else{
      onSuccess(token, listing);
    }
  }

  static void updateListingDetails({
    required Map<String, dynamic> listing,
    required Function(bool isLoading, bool ischange) updateState,
    required List<String> imageUrls,
    required List<String> addonsheadings,
    required List<String> addonsvalues,
    required List<String> values,
    required List<String> starsvalue,
  }) {
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

    values.add(listing['View']['serviceType']);
    values.add(listing['View']['cateringOptions']);
    values.add(listing['View']['staff']);
    values.add(listing['View']['expertise']);

    starsvalue.add('(${listing['reveiewData']['5'].toString()})');
    starsvalue.add('(${listing['reveiewData']['4'].toString()})');
    starsvalue.add('(${listing['reveiewData']['3'].toString()})');
    starsvalue.add('(${listing['reveiewData']['2'].toString()})');
    starsvalue.add('(${listing['reveiewData']['1'].toString()})');

    // Update state
    updateState(false, true); // Set isLoading = false, ischange = true
  }
}
