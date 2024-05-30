//
//  Orientation Manager.swift
//  Demo_1
//
//  Created by iMac on 27/05/24.
//

import Foundation
import UIKit

class OrientationManager {
    static var shouldLockOrientation = false
    static var preferredOrientation: UIInterfaceOrientationMask = .portrait

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        self.shouldLockOrientation = true
        self.preferredOrientation = orientation
        UIDevice.current.setValue(orientation.toUIInterfaceOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }

    static func unlockOrientation() {
        self.shouldLockOrientation = false
    }
}

extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return OrientationManager.shouldLockOrientation ? OrientationManager.preferredOrientation : .all
    }
}
