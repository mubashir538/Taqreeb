import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taqreeb/firebase_options.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';

class FirebaseService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static String? _fcmToken;
  static bool _initialized = false;

  // Getter for FCM token
  static String? get fcmToken => _fcmToken;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await _initializeFirebaseCore();
      await _initializeNotifications();
      await _setupTokenHandling();
      _initialized = true;
    } catch (e) {
      print('FirebaseService initialization failed: $e');
      // Consider adding error reporting here
    }
  }

  static Future<void> _initializeFirebaseCore() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static Future<void> _initializeNotifications() async {
    await _setupLocalNotifications();
    await _requestPermissions();
    _registerMessageHandlers();
  }

  static Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap when app is in foreground
        _handleNotificationTap(response.payload);
      },
    );

    // Create notification channel for Android 8.0+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Important Notifications',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Notification permissions: ${settings.authorizationStatus}');
  }

  static Future<void> _setupTokenHandling() async {
    // Get initial token
    _fcmToken = await _messaging.getToken();
    print('Initial FCM Token: $_fcmToken');
    await _saveTokenToBackend(_fcmToken);

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      print('FCM Token refreshed: $newToken');
      _fcmToken = newToken;
      _saveTokenToBackend(newToken);
    });
  }

  static Future<void> _saveTokenToBackend(String? token) async {
    if (token == null) return;

    try {
      final userId = await MyStorage.getToken(MyTokens.userId);
      if (userId != null) {
        await MyApi.postRequest(
          endpoint: 'save_fcm_token',
          body: {
            'user_id': userId,
            'fcm_token': token,
          },
          headers: {
            'Authorization':
                'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
          },
        );
        print('FCM token saved to backend successfully');
      }
    } catch (e) {
      print('Error saving FCM token to backend: $e');
    }
  }

  static void _registerMessageHandlers() {
    // Background message handler (must be top-level or static)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received');
      _onMessageReceived(message);
    });

    // App opened from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _onMessageOpened(message);
      }
    });

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpened);
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Background Message: ${message.notification?.title}");
    // You might want to show a notification here as well
    await _showNotification(message);
  }

  static void _onMessageReceived(RemoteMessage message) {
    print("Message received: ${message.notification?.title}");
    _showNotification(message);
  }

  static void _onMessageOpened(RemoteMessage message) {
    print("Message opened: ${message.notification?.title}");
    _handleNotificationTap(message.data.toString());
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    final androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Important Notifications',
      channelDescription: 'This channel is used for important notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data.toString(), // Pass data for handling taps
    );
  }

  static void _handleNotificationTap(String? payload) {
    // Parse payload and navigate to appropriate screen
    print('Notification tapped with payload: $payload');
    // Example: Navigate to chat screen if payload contains chat data
    // You'll need to integrate with your navigation system
  }

  // Call this when user logs out
  static Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _fcmToken = null;
      print('FCM token deleted successfully');
    } catch (e) {
      print('Error deleting FCM token: $e');
    }
  }
}
