//
//  NavigationViewController.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit

class NavigationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    @IBAction func onPopTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
