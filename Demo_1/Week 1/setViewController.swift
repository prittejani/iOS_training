//
//  setViewController.swift
//  
//
//  Created by iMac on 02/04/24.
//

import Foundation
import UIKit

class Switcher {
    static func updateRootVC(status:Bool){
        var rootVC : UIViewController?
        
        if (status == false) {
            print(status)
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoogleSigninViewController") as! GoogleSigninViewController
        }else{
            print(status)
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rootNavigationVC")
        }
        let window = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).window
        window?.rootViewController = rootVC
    }
}
