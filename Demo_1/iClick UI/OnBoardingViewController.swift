//
//  OnBoardingViewController.swift
//  Demo_1
//
//  Created by iMac on 20/05/24.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var GetStartedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        GetStartedButton.layer.cornerRadius = GetStartedButton.frame.size.height/2
        GetStartedButton.clipsToBounds = true
    }
    

}

