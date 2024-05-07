//
//  CViewController.swift
//  Demo_1
//
//  Created by iMac on 02/05/24.
//

import UIKit

class CViewController: UIViewController {

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
