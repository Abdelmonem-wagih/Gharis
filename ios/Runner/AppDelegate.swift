import UIKit
import Flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, UNUserNotificationCenterDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register plugins
    GeneratedPluginRegistrant.register(with: self)

    // Set UNUserNotificationCenter delegate
    UNUserNotificationCenter.current().delegate = self

    // Optionally request permission natively (you already request in Dart; this is redundant but safe)
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      if granted {
        print("iOS Notification permission granted")
      } else {
        print("iOS Notification permission denied: \(error?.localizedDescription ?? "Unknown error")")
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Show notifications even when app in foreground
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert, .badge, .sound])
  }

  // Handle taps
  override func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    completionHandler()
  }
}
