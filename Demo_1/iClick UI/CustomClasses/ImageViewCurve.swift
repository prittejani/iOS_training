//
//  ImageViewCurve.swift
//  Demo_1
//
//  Created by iMac on 20/05/24.
//

import Foundation
import UIKit

class CurvedImageView: UIImageView {

    var curvedPercent: CGFloat = 0.4 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }
    
    private func updateMask() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = pathCurvedForView(curvedPercent: curvedPercent).cgPath
        self.layer.mask = maskLayer
    }
    
    private func pathCurvedForView(curvedPercent: CGFloat) -> UIBezierPath {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: 0, y: 0))
        arrowPath.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        arrowPath.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - (self.bounds.size.height * curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x: 0, y: self.bounds.size.height - (self.bounds.size.height * curvedPercent)), controlPoint: CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x: 0, y: 0))
        arrowPath.close()
        
        return arrowPath
    }
}

