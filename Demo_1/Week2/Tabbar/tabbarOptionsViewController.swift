//
//  tabbarOptionsViewController.swift
//  Demo_1
//
//  Created by iMac on 19/03/24.
//

import UIKit

class tabbarOptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func defaultTapped(_ sender: UIButton) {
        let vc = week2StoryBoard.instantiateViewController(withIdentifier: "defaultTabbarController") as! defaultTabbarController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func customTapped(_ sender: UIButton) {
        let vc = week2StoryBoard.instantiateViewController(withIdentifier: "CustomTabBarViewController") as! CustomTabBarViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
