//
//  iOS_19ViewController.swift
//  Demo_1
//
//  Created by iMac on 05/04/24.
//

import UIKit
import SideMenu

class iOS_19ViewController: UIViewController, UINavigationControllerDelegate{
    var menu:SideMenuNavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
                menu = SideMenuNavigationController(rootViewController: sideMenubar())
                menu.leftSide = true
                SideMenuManager.default.leftMenuNavigationController = menu
    }
    
    @IBAction func openSideBar(_ sender: UIBarButtonItem) {
        
        self.present(menu, animated: true,completion: nil)
    }
    @IBAction func onBackTapped(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}
