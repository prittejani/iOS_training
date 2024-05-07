//
//  PopupViewController.swift
//  Demo_1
//
//  Created by iMac on 30/04/24.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        popupView.layer.cornerRadius = 20.0
        popupView.clipsToBounds = true
    }
    


    @IBAction func onOKtapped(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
        
    }
    
}
