//
//  DateField.swift
//  Demo_1
//
//  Created by USER on 14/06/24.
//

import Foundation
import UIKit

class DateTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
    
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
    
        leftView = button
        leftViewMode = .always
     
    }
    
}
