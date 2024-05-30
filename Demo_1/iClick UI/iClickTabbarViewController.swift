//
//  iClickTabbarViewController.swift
//  Demo_1
//
//  Created by iMac on 28/05/24.
//

import UIKit

class iClickTabbarViewController: UITabBarController {
    let middleButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
     setupMiddleButton()
    }
    override func viewWillLayoutSubviews() {
         super.viewWillLayoutSubviews()
         updateMiddleButtonFrame()
     }

     func updateMiddleButtonFrame() {
         let buttonSize: CGFloat = 50
         middleButton.frame = CGRect(x: (self.tabBar.frame.width / 2) - (buttonSize / 2), y: -20, width: buttonSize, height: buttonSize)
     }

    func setupMiddleButton() {
        
         middleButton.frame = CGRect(x: (self.tabBar.frame.width / 2) - 25 , y: -20, width: 50, height: 50)
       
        middleButton.backgroundColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
             middleButton.layer.cornerRadius = 25
             middleButton.setImage(UIImage(systemName: "plus"), for: .normal)
             middleButton.tintColor = .white
             
             // Add the button to the tab bar
             self.tabBar.addSubview(middleButton)
             
             // Bring the button to the front
             self.tabBar.bringSubviewToFront(middleButton)
             
           self.view.layoutIfNeeded()
   }
   
}
