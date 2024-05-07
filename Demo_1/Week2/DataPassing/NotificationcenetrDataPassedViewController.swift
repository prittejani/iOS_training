//
//  NotificationcenetrDataPassedViewController.swift
//  datapassing
//
//  Created by iMac on 23/02/24.
//

import UIKit

class NotificationcenetrDataPassedViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    let notificationName = Notification.Name("PassData")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    func validateName(_ name: String) -> Bool {
        let regex = "^[a-zA-Z\\_]{3,18}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }
    @IBAction func btnSave(_ sender: Any) {
        if let name:String = nameTextfield.text{
            if nameTextfield.text == ""{
                customAlert(title: "Alert", message: "Please enter name")
            }else if !validateName(name){
                customAlert(title: "Alert", message: "Please enter valid name")
            }else{
                NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["data":name])
                navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    func customAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

}
