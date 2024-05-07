//
//  ConstraintHelper.swift
//  Demo_1
//
//  Created by iMac on 07/05/24.
//

import Foundation
import UIKit

class ConstraintHelper {
    
    static func applyLandscapeConstraints(view: UIView, view1: UIView, view2: UIView, view3: UIView) -> [NSLayoutConstraint] {
           var landscapeConstraints = [NSLayoutConstraint]()
           
           view1.translatesAutoresizingMaskIntoConstraints = false
           view2.translatesAutoresizingMaskIntoConstraints = false
           view3.translatesAutoresizingMaskIntoConstraints = false
           
           let view3PinToBottom = NSLayoutConstraint(item: view3, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: -SafeAreaValues.getBottomConstant())
           let view3PinToLeft = NSLayoutConstraint(item: view3, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: SafeAreaValues.getLeftConstant())
           let view3PinToRight = NSLayoutConstraint(item: view3, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -SafeAreaValues.getRightConstant())
           let view3Height = NSLayoutConstraint(item: view3, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 60.0)
           view.addConstraint(view3PinToBottom)
           landscapeConstraints.append(view3PinToBottom)
           view.addConstraint(view3PinToLeft)
           landscapeConstraints.append(view3PinToLeft)
           view.addConstraint(view3PinToRight)
           landscapeConstraints.append(view3PinToRight)
           view.addConstraint(view3Height)
           landscapeConstraints.append(view3Height)
           
           let view1PinToTop = NSLayoutConstraint(item: view1, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 8.0)
           let view1PinToLeft = NSLayoutConstraint(item: view1, attribute: .left, relatedBy: .equal, toItem: view3, attribute: .left, multiplier: 1.0, constant: 0.0)
           let view1Width = NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: view3, attribute: .width, multiplier: 0.5, constant: -4.0)
           let view1PinToBottom = NSLayoutConstraint(item: view1, attribute: .bottom, relatedBy: .equal, toItem: view3, attribute: .top, multiplier: 1.0, constant: -8.0)
           view.addConstraint(view1PinToTop)
           landscapeConstraints.append(view1PinToTop)
           view.addConstraint(view1PinToLeft)
           landscapeConstraints.append(view1PinToLeft)
           view.addConstraint(view1Width)
           landscapeConstraints.append(view1Width)
           view.addConstraint(view1PinToBottom)
           landscapeConstraints.append(view1PinToBottom)

           let view2PinToTop = NSLayoutConstraint(item: view2, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 8.0)
           let view2Width = NSLayoutConstraint(item: view2, attribute: .width, relatedBy: .equal, toItem: view3, attribute: .width, multiplier: 0.5, constant: -4.0)
           let view2PinToRight = NSLayoutConstraint(item: view2, attribute: .right, relatedBy: .equal, toItem: view3, attribute: .right, multiplier: 1.0, constant: 0.0)
           let view2PinToBottom = NSLayoutConstraint(item: view2, attribute: .bottom, relatedBy: .equal, toItem: view3, attribute: .top, multiplier: 1.0, constant: -8.0)
           view.addConstraint(view2PinToTop)
           landscapeConstraints.append(view2PinToTop)
           view.addConstraint(view2Width)
           landscapeConstraints.append(view2Width)
           view.addConstraint(view2PinToRight)
           landscapeConstraints.append(view2PinToRight)
           view.addConstraint(view2PinToBottom)
           landscapeConstraints.append(view2PinToBottom)
           
           
           return landscapeConstraints
       }
    
}
