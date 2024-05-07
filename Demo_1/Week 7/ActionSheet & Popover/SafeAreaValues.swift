//
//  SafeAreaValues.swift
//  Demo_1
//
//  Created by iMac on 07/05/24.
//

import Foundation
import UIKit

class SafeAreaValues {
    static func getLeftConstant() -> CGFloat {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0)
        } else {
         
            return 0
        }
    }
    
    static func getRightConstant() -> CGFloat {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.keyWindow?.safeAreaInsets.right ?? 0)
        } else {
      
            return 0
        }
    }
    
    static func getBottomConstant() -> CGFloat {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        } else {

            return 0
        }
    }
}
