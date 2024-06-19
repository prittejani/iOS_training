//
//  SplashViewController.swift
//  Demo_1
//
//  Created by iMac on 17/05/24.
//

import UIKit


class SplashViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onViewTapped(_ :))))
        
    }
    @objc func onViewTapped(_ sender:UIGestureRecognizer){
        let vc = iClick.instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
        navigationController?.pushViewController(vc, animated: true)
     print("view Tapped")
    }
}
