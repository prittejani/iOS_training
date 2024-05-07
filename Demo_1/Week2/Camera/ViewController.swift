//
//  ViewController.swift
//  Camera
//
//  Created by iMac on 08/03/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }

    @IBAction func onCustomTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onDefaultTapped(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DefaultCameraViewController") as! DefaultCameraViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

