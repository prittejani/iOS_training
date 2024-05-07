//
//  ViewController.swift
//  Gestures
//
//  Created by iMac on 04/03/24.
//

import UIKit
let gestureStoryBoard = UIStoryboard(name: "gestures", bundle: nil)
class ViewController6: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }


    @IBAction func onGesturesButtonTapped(_ sender: UIButton) {
        
            let vc = gestureStoryBoard.instantiateViewController(withIdentifier: "GesturesViewController") as! GesturesViewController
        vc.tag = sender.tag
            navigationController?.pushViewController(vc, animated: true)
        
    }
}

