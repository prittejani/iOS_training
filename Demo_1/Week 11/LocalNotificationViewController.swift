//
//  LocalNotificationViewController.swift
//  Demo_1
//
//  Created by USER on 15/06/24.
//

import UIKit
import UserNotifications
import FirebaseAnalytics
import FirebaseAnalyticsSwift
import Firebase

let week11 = UIStoryboard(name: "week11", bundle: .main)

class LocalNotificationViewController: UIViewController,UNUserNotificationCenterDelegate{

    let  notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.delegate = self
        notificationCenter.requestAuthorization(options: [.alert,.badge,.sound]){
            (success, error) in
        }
        logScreenView(screenName: "LocalNotificationViewController", screenClass: "LocalNotificationViewController")
     }
     
     func logScreenView(screenName: String, screenClass: String) {
         Analytics.logEvent(AnalyticsEventScreenView,parameters: [AnalyticsParameterScreenName: screenName,AnalyticsParameterScreenClass: screenClass])
     }
    
    
    @IBAction func onDynamicLinksTapped(_ sender: UIButton) {
        let vc = week11.instantiateViewController(withIdentifier: "DynamicLinksViewController") as! DynamicLinksViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onCrashTapped(_ sender: UIButton) {
        fatalError("App Crashed")
    }
    
    @IBAction func onAnalyticsTapped(_ sender: UIButton) {
        Analytics.logEvent("press_button", parameters: ["Button":"AnalyticsButton"])
        
    
    }
    
    
    @IBAction func onNotificationButtonTapped(_ sender: UIButton) {
        
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "My Category Identifier"
        content.title = "Local Notification"
        content.subtitle = "From Demo1"
        content.body = "This is create example"
        content.badge = 1
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let identifier = "Main identifier"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request){
            error in
            print(error?.localizedDescription)
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
}
