//
//  newViewController.swift
//  Demo_1
//
//  Created by iMac on 29/04/24.
//

import UIKit

class newViewController: UIViewController {

 
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func backToRoot(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
