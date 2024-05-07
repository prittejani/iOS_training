//
//  ViewController.swift
//  datapassing
//
//  Created by iMac on 22/02/24.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func validateName(_ name: String) -> Bool {
        let regex = "^[a-zA-Z\\_]{3,18}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let data = segue.destination as? SecondViewController {
        
            if let name = textfield.text, let umail = emailTextfield.text{
                if (textfield.text == "") || (emailTextfield.text == ""){
                    customAlert(title: "Alert!!", message: "All field required")
                }
                else if !isValidEmail(email: umail){
                    customAlert(title: "Alert!!", message: "Enter valid email")
                }else if !validateName(name){
                    customAlert(title: "Alert!!", message: "Enter valid name")
                }else{
                    data.name = name
                    data.umail = umail
                }
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

