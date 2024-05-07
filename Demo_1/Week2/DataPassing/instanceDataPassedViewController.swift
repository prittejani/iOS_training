//
//  instanceDataPassedViewController.swift
//  Demo_1
//
//  Created by iMac on 20/03/24.
//

import UIKit

class instanceDataPassedViewController: UIViewController {

    @IBOutlet weak var namelbl: UILabel!
    var name:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = name{
            namelbl.text = "Your name is : \(data)"
        }
    }

    @IBAction func onBackTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
