//
//  ColorPelletViewController.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit

@available(iOS 14.0, *)
class ColorPelletViewController: UIViewController {

    @IBOutlet weak var colorWell: UIColorWell!
    override func viewDidLoad() {
        super.viewDidLoad()
        colorWell.selectedColor = .yellow
        colorWell.title = "Color Well"
        colorWell.frame.size = CGSize(width: 50, height: 50)
    }
    
}
