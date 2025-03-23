import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class Logs {
  static Future<void> logUserActivity(
      String action, Map<String, dynamic> metadata) async {
    String? userId =
        await MyStorage.getToken(MyTokens.userId); // Get user ID dynamically

    if (userId == null) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': 'User ID not found. Skipping activity log'});
      return;
    }

    final response = await MyApi.postRequest(
      endpoint: 'log-user-activity/',
      headers: {
        'Authorization':
            'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}'
      },
      body: {
        "user_id": int.parse(userId), // Ensure user ID is an integer
        "action": action,
        "metadata": metadata,
      },
    );

    if (!(response['status'] == 'success')) {
      MyApi.postRequest(
          endpoint: 'error/application',
          body: {'error': ' Failed to log activity: ${response?['message']}'});
    }
  }
}
