//
//  OnBoardingViewController.swift
//  Demo_1
//
//  Created by iMac on 20/05/24.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var GetStartedButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GetStartedButton.layer.cornerRadius = GetStartedButton.frame.size.height/2
        GetStartedButton.layer.masksToBounds = true
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [self] _ in
            if UIDevice.current.orientation.isLandscape {
                
                print("landscape")
               
                NSLayoutConstraint.deactivate(self.view.constraints.filter { $0.firstItem === self.stackView && $0.firstAttribute == .height })
                NSLayoutConstraint.activate([
                    self.stackView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.540845)
                ])
            
            } else {
                print("portrait")
                
       
                NSLayoutConstraint.deactivate(self.view.constraints.filter { $0.firstItem === self.stackView && $0.firstAttribute == .height })
                NSLayoutConstraint.activate([
                    self.stackView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.680845)
                ])
             
            }

            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    @IBAction func onGetStartedTapped(_ sender: UIButton) {
        let vc = iClick.instantiateViewController(withIdentifier: "SelectCategoryViewController") as! SelectCategoryViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

