//
//  AppDelegate.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import IQKeyboardManagerSwift
import FacebookCore
import AuthenticationServices
import Stripe
import FirebaseCore
import Firebase
import FirebaseAuth
import FirebaseDynamicLinks
import FirebaseAnalytics
import UserNotifications
import FirebaseMessaging



@main
class AppDelegate: UIResponder, UIApplicationDelegate{

    
    
    let googleClientId = "15140116916-fkpegehbq1nge5c4cosho97nrufi7dtu.apps.googleusercontent.com"
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        application.registerForRemoteNotifications()
        StripeAPI.defaultPublishableKey = "pk_test_51PE3n1EDo3VmufhKdnPe1c9D8xZtZ0GCPjInAbJ5ZC0P5Tf114MMLXoe568Jo2Jw6KGkDdfBBMMJUhTrhk1P1zNc00dXqnS8PF"
        
        IQKeyboardManager.shared.enable = true
        let appleIDData = KeychainHelper.standard.read(service: "com.app.pocketcoach", account: "appleID")
        GIDSignIn.sharedInstance.restorePreviousSignIn{
            user, error in
            if error == nil || user != nil || AccessToken.current != nil || appleIDData != nil || Auth.auth().currentUser != nil {
                Switcher.updateRootVC(status: true)
            }else{
                Switcher.updateRootVC(status: false)
            }
        }
        ApplicationDelegate.shared.application(
                  application,
                  didFinishLaunchingWithOptions: launchOptions
              )
 
        GMSServices.provideAPIKey("AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM")
        GMSPlacesClient.provideAPIKey("AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM")
  
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        if let navigationController = window?.rootViewController as? UINavigationController {

            if navigationController.visibleViewController is CameraViewController {
                return UIInterfaceOrientationMask.portrait
            }
            if navigationController.visibleViewController is CVideoViewController{
                return UIInterfaceOrientationMask.portrait
            }

            else {
                return UIInterfaceOrientationMask.all
            }
        }

        return UIInterfaceOrientationMask.portrait
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {  ApplicationDelegate.shared.application(
        app,
        open: url,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
          return true
        }
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let queryItems = components.queryItems else { return false}
            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~>>\(components.path   )")
            if components.path == "/items"{
                if let itemsIdQueryItem = queryItems.first(where: {$0.name == "itemId"}){
                  //guard let itemId = itemsIdQueryItem.value else { return false}
                     let itemDetailsController = week11.instantiateViewController(withIdentifier: "DynamicLinksViewController") as! DynamicLinksViewController
                 //   itemDetailsController.index = Int(itemId)
                    (self.window?.rootViewController as! UINavigationController).pushViewController(itemDetailsController, animated: true)
               }
            }
            return true
        }
        
        return false
    }
    func handleIncomingDynamicLink(_ dynamicLink:DynamicLink){
        guard let url = dynamicLink.url else {
            return
        }
        print("Links Parameter is \(url.absoluteString)")
//        guard (dynamicLink.matchType == .unique || dynamicLink.matchType == .default) else{
//            print("not strong enough")
//            return
//        }
      
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingUrl = userActivity.webpageURL {
            print("~~>> \(incomingUrl)")
            
            let linkHandeled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingUrl){
                (dynamicLink, error) in
                
                guard error == nil else {
                    print("Dynamic Link error \(String(describing: error?.localizedDescription))")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandeled {
                return true
            }else{
                return false
            }
            
        }
        return false
    }
}
extension AppDelegate:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions{
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        return [[.alert,.sound,.banner]]
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        print(userInfo)
        return UIBackgroundFetchResult.newData
    }

}

extension AppDelegate:MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

}



