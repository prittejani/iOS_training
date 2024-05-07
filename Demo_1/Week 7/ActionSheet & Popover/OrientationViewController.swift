//
//  OrientationViewController.swift
//  Pods
//
//  Created by iMac on 06/05/24.
//

import UIKit

class OrientationViewController: UIViewController {
    
    @IBOutlet var IBConstraints:[NSLayoutConstraint]!
    var  landscapeConstraints:[NSLayoutConstraint] = []
    
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view3: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(getOriantation), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    @objc func getOriantation(notification:NSNotification){
        let deviceOrientation = UIApplication.shared.statusBarOrientation
        
        switch deviceOrientation {
        case .portrait:
            self.applyPotraitConstraints()
        case .landscapeLeft:
            self.applyLandscapeConstraints()
        case .landscapeRight:
            self.applyLandscapeConstraints()
            print("landscape right")
        case .unknown:
            print("unknown orientation")
        case .portraitUpsideDown:
            self.applyPotraitConstraints()
            print("potrait upside down")
        @unknown default:
            print("unknown case in orientation change")
        }
    }
    func applyLandscapeConstraints(){
        NSLayoutConstraint.deactivate(IBConstraints)
        landscapeConstraints = ConstraintHelper.applyLandscapeConstraints(view: self.view, view1: view1, view2: view2, view3: view3)
    }
    func applyPotraitConstraints(){
        NSLayoutConstraint.deactivate(landscapeConstraints)
        view.addConstraints(IBConstraints)
    }
}
