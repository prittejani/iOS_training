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

@main
class AppDelegate: UIResponder, UIApplicationDelegate{

    let googleClientId = "362758248474-4damkmmk73er303861i2ffr0djp4ptnq.apps.googleusercontent.com"
                          
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let appLanguageCode = UserDefaults.standard.string(forKey: "appLanguage") {
                    UserDefaults.standard.set([appLanguageCode], forKey: "AppleLanguages")
            }
        
        IQKeyboardManager.shared.enable = true
        GIDSignIn.sharedInstance.restorePreviousSignIn{
            user, error in
            if error == nil || user != nil {
                Switcher.updateRootVC(status: true)
            }else{
                Switcher.updateRootVC(status: false)
            }
        }
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(
                  application,
                  didFinishLaunchingWithOptions: launchOptions
              )
 
        GMSServices.provideAPIKey("AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM")
        GMSPlacesClient.provideAPIKey("AIzaSyDuCz_PnycWVP2kZMgMwB5SSSc77iABQOM")
    
       
        return true
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
        return false
        
      
        
      
    }

}

