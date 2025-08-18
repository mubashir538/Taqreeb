import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taqreeb/core/services/api_service.dart';
import 'package:taqreeb/core/services/flutter_storage.dart';
import 'package:taqreeb/core/services/tokens.dart';
import 'package:taqreeb/firebase_options.dart';

class FirebaseService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> setup() async {
    if (_initialized) return;

    try {
      // 1. Setup notifications channel
      await _setupNotificationChannel();

      // 2. Initialize local notifications
      await _initLocalNotifications();

      // 3. Request permissions
      await _requestPermissions();

      // 4. Setup message handlers
      await _setupMessageHandlers();

      // 5. Get and handle initial token
      await _handleInitialToken();

      _initialized = true;
      print('✅ FirebaseService initialized');
    } catch (e, stack) {
      print('🔥 FirebaseService error: $e\n$stack');
    }
  }

  static Future<void> _setupNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Important Notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationTap(response.payload);
      },
    );
  }

  static Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission status: ${settings.authorizationStatus}');
  }

  static Future<void> _setupMessageHandlers() async {
    // Background handler
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    // Foreground handler
    FirebaseMessaging.onMessage.listen(_foregroundHandler);

    // Opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpened(initialMessage);
    }

    // Opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    print('Background message: ${message.messageId}');
    await _showNotification(message);
  }

  static Future<void> _foregroundHandler(RemoteMessage message) async {
    print('Foreground message: ${message.messageId}');
    await _showNotification(message);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    try {
      print('a1');
      final notification = message.notification;
      final android = message.notification?.android;
      print('a2');
      if (notification == null && android == null) return;
      print('a3');
      final androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'Important Notifications',
        channelDescription: 'Channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: android?.smallIcon ?? '@mipmap/ic_launcher',
        // largeIcon: android?.largeIcon != null
        //     ? FilePathAndroidBitmap(android!.largeIcon!)
        //     : null,
      );
      print('a4');

      if (message.data.length == 0) {
        print('returned...');
        return;
      }
      await _notifications.show(
        message.hashCode,
        notification?.title ?? 'New Notification',
        notification?.body ?? 'Notification body',
        NotificationDetails(android: androidDetails),
        payload: message.data.toString(),
      );
      print('a5');
    } catch (e, stack) {
      print('Error showing notification: $e\n$stack');
    }
  }

  static Future<void> _handleInitialToken() async {
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _sendTokenToServer(token);
      }

      _messaging.onTokenRefresh.listen(_sendTokenToServer);
    } catch (e) {
      print('Error handling token: $e');
    }
  }

  static Future<void> _sendTokenToServer(String token) async {
    try {
      await MyApi.postRequest(
        endpoint: 'notification/saveFCM',
        body: {
          'token': token,
          'userId': await MyStorage.getToken(MyTokens.userId),
        },
        headers: {
          'Authorization':
              'Bearer ${await MyStorage.getToken(MyTokens.accessToken)}',
        },
      );
    } catch (e) {
      print('Error sending token: $e');
    }
  }

  static void _handleMessageOpened(RemoteMessage message) {
    print('Message opened: ${message.messageId}');
    // Handle navigation based on message data
  }

  static void _handleNotificationTap(String? payload) {
    print('Notification tapped: $payload');
    // Handle notification tap
  }
}
