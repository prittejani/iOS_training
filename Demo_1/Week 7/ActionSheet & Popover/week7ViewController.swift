//
//  week7ViewController.swift
//  Demo_1
//
//  Created by iMac on 29/04/24.
//

import UIKit

class week7ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onActionsheetTapped(_ sender: UIButton) {
        let vc = actionSheet.instantiateViewController(withIdentifier: "ActionSheetViewController") as! ActionSheetViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func localization(_ sender: UIButton) {
        let vc = actionSheet.instantiateViewController(withIdentifier: "LocalizationViewController") as! LocalizationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func oriantation(_ sender: UIButton) {
        let vc = actionSheet.instantiateViewController(withIdentifier: "OrientationViewController") as! OrientationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
