//
//  iClickTabbarViewController.swift
//  Demo_1
//
//  Created by iMac on 28/05/24.
//

import UIKit

class iClickTabbarViewController: UITabBarController {
    let middleButton = GradientButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
     //setupMiddleButton()
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
        middleButton.layer.cornerRadius = 25
        middleButton.setImage(UIImage(systemName: "plus"), for: .normal)
        middleButton.tintColor = .white
        self.tabBar.addSubview(middleButton)
        self.tabBar.bringSubviewToFront(middleButton)
        self.view.layoutIfNeeded()
   }
   
}


extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
