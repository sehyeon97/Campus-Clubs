import Flutter
import UIKit

// The lines of code below the comments a, b, c are provided in the 
// flutter_local_notifications package documentation in order to
// implement notifications in our app using an iOS device
// For Android, nothing is required
// a
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // b
    FlutterNotificationsPlugin.setPluginRegistrantCallback { (registry) in GeneratedPluginRegistrant.register(with: registry)}

    GeneratedPluginRegistrant.register(with: self)

    // c
    if #available (iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
