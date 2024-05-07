//
//  DelegetDataViewController.swift
//  datapassing
//
//  Created by iMac on 23/02/24.
//

import UIKit


class DelegetDataViewController: UIViewController, DataPass{
  
    @IBOutlet weak var lblName: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func sendData(name: String) {
        lblName.text = "Name : \(name)"
    }   
    @IBAction func btnEdit(_ sender: Any) {
        let vc = dataPassStoryBoard.instantiateViewController(identifier: "DelegetDataPassedViewController") as! DelegetDataPassedViewController
        
         vc.deleget = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
