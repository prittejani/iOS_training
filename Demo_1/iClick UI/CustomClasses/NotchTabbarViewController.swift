//
//  NotchTabbarViewController.swift
//  Demo_1
//
//  Created by iMac on 24/05/24.
//

import UIKit
import STTabbar
class NotchTabbarViewController: UITabBarController{

    required init(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)!
       }
       override func viewDidLoad() {
           super.viewDidLoad()
           
        setupMiddleButton()
       }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if selectedIndex == 0 {
            print(selectedIndex)
            self.tabBarController?.tabBar.items?[0].image = UIImage(systemName: "Home")
        }else if selectedIndex == 1 {
            print(selectedIndex)
            self.tabBarController?.tabBar.items?[1].image = UIImage(named: "Category")
        }else if selectedIndex == 2 {
            print(selectedIndex)
            self.tabBarController?.tabBar.items?[2].image = UIImage(named: "Notification")
        }else if selectedIndex == 3 {
            print(selectedIndex)
            self.tabBarController?.tabBar.items?[3].image = UIImage(named: "Profile")
        }
    }
    
    
    private func setupMiddleButton() {
        self.tabBar.frame.size.height = 20
        guard let items = self.tabBar.items else { return }
               if items.count >= 1 {
                   let thirdItem = items[2]
                   let secondItem = items[1]
                   thirdItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -50)
                   secondItem.imageInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0)
               }
         let middleButton = GradientButtons()
        
        middleButton.frame.size = CGSize(width: 58, height: 58)
        middleButton.layer.cornerRadius = (middleButton.layer.frame.width / 2)
        middleButton.setImage(UIImage(named: "addButton"), for: .normal)
        middleButton.tintColor = .white
        self.tabBar.addSubview(middleButton)
        self.tabBar.bringSubviewToFront(middleButton)
        middleButton.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
           middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0),
           middleButton.widthAnchor.constraint(equalToConstant: 58),
           middleButton.heightAnchor.constraint(equalToConstant: 58)
       ])
        middleButton.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)
        self.view.layoutIfNeeded()
    }
    
    @objc func menuButtonAction(sender: UIButton) {
        print("tapped")
    }

   }


extension CGFloat {
    var degreesToRadians: CGFloat {return self * .pi / 10 }
    var radiansToDegrees: CGFloat {return self * 10 / .pi }
}
