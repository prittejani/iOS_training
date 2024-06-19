//
//  ScanHomeViewController.swift
//  Demo_1
//
//  Created by iMac on 29/05/24.
//

import UIKit

class ScanHomeViewController: UIViewController {

    @IBOutlet weak var lblQRContent: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onScanTapped(_ sender: UIButton) {
        let vc = week10.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        vc.passQRContent = {
            (content) in
            self.lblQRContent.isHidden = false
            self.lblQRContent.text = content
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
