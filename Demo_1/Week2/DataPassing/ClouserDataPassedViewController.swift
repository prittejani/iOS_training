//
//  ClouserDataPassedViewController.swift
//  datapassing
//
//  Created by iMac on 22/02/24.
//

import UIKit

class ClouserDataPassedViewController: UIViewController {

    @IBOutlet weak var lblmobileno: UILabel!
    @IBOutlet weak var lblname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBack(_ sender: Any) {
       
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "ClouserDataViewController") as! ClouserDataViewController

        vc.clousers = {
            (text) in
            self.lblname.text = "Name : \(text)"

        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
