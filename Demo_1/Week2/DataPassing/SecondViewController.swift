//
//  SecondViewController.swift
//  datapassing
//
//  Created by iMac on 22/02/24.
//

import UIKit

class SecondViewController: UIViewController {

   
    @IBOutlet weak var lbl: UILabel!
    
    
    @IBOutlet weak var mail: UILabel!

   
    
    var name:String?
    var umail:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        if let name1 = name, let umail = umail{
            lbl.text = "Name : " + name1
            mail.text = "Email : " + umail
        }
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
