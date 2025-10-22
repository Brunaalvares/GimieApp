import UIKit
import Flutter
import SharedPreferences

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Read shared URL from App Group if present (needs proper App Group setup)
    if let defaults = UserDefaults(suiteName: "group.com.suaempresa.seuprojeto"),
       let sharedURL = defaults.string(forKey: "sharedURL"),
       !sharedURL.isEmpty {
        defaults.removeObject(forKey: "sharedURL")
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.gimieapp/share", binaryMessenger: controller.binaryMessenger)
        channel.invokeMethod("shared_text", arguments: sharedURL)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
