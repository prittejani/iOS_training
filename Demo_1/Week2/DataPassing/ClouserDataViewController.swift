//
//  ClouserDataViewController.swift
//  datapassing
//
//  Created by iMac on 22/02/24.
//

import UIKit


class ClouserDataViewController: UIViewController {

    var clousers: ((String) -> Void)?
  
    @IBOutlet weak var name: UITextField!
  

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    func validateName(_ name: String) -> Bool {
        let regex = "^[a-zA-Z\\_]{3,18}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }

    @IBAction func btnSave(_ sender: Any) {
        if let text = name.text {
            if name.text == ""{
                customAlert(title: "Alert", message: "Please enter name")
            }else if !validateName(text){
                customAlert(title: "Alert", message: "Please enter valid name")
            }
            else{
                clousers?(text)
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
