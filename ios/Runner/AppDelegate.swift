import UIKit
import Flutter
import WebEngage
import webengage_flutter
import UserNotifications
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // Add local var to maintain bridge object
    //Value of type 'WebEngage' has no member 'pushNotificationDelegate'
    var bridge: WebEngagePlugin?
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        // Set AppDelegate instance as delegate for notificationCenter
        if #available(iOS 10.0, *) {
            //iOS 10.0 and greater
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    else {
                        //Do stuff if unsuccessful...
                    }
                }
           })
        }
        else {
            //iOS 9
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
      //  UNUserNotificationCenter.current().delegate = self
        // Init bridge
        bridge = WebEngagePlugin()
        // Bridge instance is required to pass as parameter if you're using In-Apps or push notifications
        WebEngage.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions, notificationDelegate: bridge)
        WebEngage.sharedInstance()?.pushNotificationDelegate = bridge
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    // Override below class if you're using deeplink
    override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool{
        guard let deepLinkUrl = userActivity.webpageURL else {
            return true
        }
        WebEngage.sharedInstance()?.deeplinkManager.getAndTrackDeeplink(deepLinkUrl, callbackBlock: { (location) in
            self.bridge?.trackDeeplinkURLCallback(location)
        })
        return true
    }
}

