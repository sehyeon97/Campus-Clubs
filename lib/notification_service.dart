import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    // prepare android init settings
    // An icon parameter is required
    // here, we give it the default icon under:
    // android -> src -> main -> res -> mipmap-hdpi -> ic_launcher
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // prepare iOS init settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // initialize settings by grouping the android and iOS settings together
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // finish initialization
    await _flutterLocalNotificationsPlugin.initialize(settings);
    _isInitialized = true;
  }

  // Notification detail setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'my_channel_id',
        'my_channel_name',
        channelDescription: 'My channel notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

// most important method in class
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    try {
      return _flutterLocalNotificationsPlugin.show(
        0,
        "Test Title",
        "Test Body",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_channel_id',
            'my_channel_name',
            channelDescription: 'My channel notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }
}
