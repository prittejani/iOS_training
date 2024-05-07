//
//  DrawerViewController.swift
//  Demo_1
//
//  Created by iMac on 02/04/24.
//

import UIKit

class DrawerViewController: UIViewController {
    
    @IBOutlet var background: UIView!
    
    @IBOutlet weak var infoBackground: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDesign()
    }
    private func setDesign (){
        self.infoBackground.roundSpecificCorners(corners: [.bottomRight,.topRight], radius: 20)
        self.infoBackground.clipsToBounds = true
        
        self.background.roundSpecificCorners(corners: [.bottomRight,.topRight], radius: 90)
        self.infoBackground.clipsToBounds = true
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width/2
        self.profileImage.clipsToBounds = true
        
    }
}
extension UIView {
    func roundSpecificCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
