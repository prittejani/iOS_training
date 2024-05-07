//
//  InsideHomeViewController.swift
//  Demo_1
//
//  Created by USER on 12/04/24.
//

import UIKit

class InsideHomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func onTapped(_ sender: UIButton) {
        let vc = week2StoryBoard.instantiateViewController(withIdentifier: "newViewController") as! newViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
