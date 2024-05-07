//
//  NotificationcenterDataViewController.swift
//  datapassing
//
//  Created by iMac on 23/02/24.
//

import UIKit

class NotificationcenterDataViewController: UIViewController {
    @IBOutlet weak var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("PassData"), object: nil)
    }
 
    @objc func handleNotification(_ notification: Notification){
        if let data = notification.userInfo?["data"] as? String{
            lblName.text = "Name : \(data)"
        }
    }

    @IBAction func btnedit(_ sender: Any) {
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "NotificationcenetrDataPassedViewController")as! NotificationcenetrDataPassedViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
