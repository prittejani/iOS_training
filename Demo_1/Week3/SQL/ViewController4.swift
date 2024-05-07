//
//  ViewController.swift
//  sql
//
//  Created by iMac on 28/02/24.
//

import UIKit

class ViewController4: UIViewController{
    
    
    var database = SqlHelper()
   
    
    @IBOutlet weak var nameField: UITextField!
    

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var mobilenoField: UITextField!
    var user:UserModel!
    var fromTableView:Bool?
    var id:Int!
    var email:String!
    var mobileNo:String!
    var name:String!
    var date:String!
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        if fromTableView == true
        {    nameField.text = user.name
            mobilenoField.text = user.mobileno
         
            emailField.text = user.email
          
      
            id = user.id
        }
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func validateMobileno(_ input: String) -> Bool {
        let regex = "^[0-9]{10}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
  
    func validateDate(_ dateString: String, format: String = "dd-MM-yyyy") -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let _ = dateFormatter.date(from: dateString) {
            return true // Valid date
        } else {
            return false // Invalid date
        }
    }
    @IBAction func saveData(_ sender: UIButton) {
        email = emailField.text
        mobileNo = mobilenoField.text
        name = nameField.text
       
        if fromTableView == true {
            if (nameField.hasText == false) || (mobilenoField.hasText == false) || (emailField.hasText == false) {
                let alert = UIAlertController(title: "Alert", message: "Required All Field", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default,handler: {
                    (action) -> Void in self.dismiss(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true)
            }else if validateMobileno(mobileNo) == false{
                let alert = UIAlertController(title: "Alert!!", message: "Mobile no is not valid format in 10 digits", preferredStyle: .alert)
                    
                let done = UIAlertAction(title: "Done", style: .default,handler: {(action) -> Void in self.dismiss(animated: true)
                })
                alert.addAction(done)
                self.present(alert, animated: true)
            }
            else if isValidEmail(email: email) == false {
            let alert = UIAlertController(title: "Alert!!", message: "Email is not valid format", preferredStyle: .alert)
                
            let done = UIAlertAction(title: "Done", style: .default,handler: {(action) -> Void in self.dismiss(animated: true)
            })
            alert.addAction(done)
            self.present(alert, animated: true)
            }
            else{
                database.update(id: id, name: nameField.text ?? "", mobileno: mobilenoField.text ?? "", email: emailField.text ?? "")
                navigationController?.popViewController(animated: true)
                print("data updated")}
              
        }else{
            if (nameField.hasText == false) || (mobilenoField.hasText == false) ||  (emailField.hasText == false){
                let alert = UIAlertController(title: "Alert", message: "Required All Field", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default,handler: {
                    (action) -> Void in self.dismiss(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true)
            }else if validateMobileno(mobileNo) == false{
                    let alert = UIAlertController(title: "Alert!!", message: "Mobile no is not valid format", preferredStyle: .alert)
                        
                    let done = UIAlertAction(title: "Done", style: .default,handler: {(action) -> Void in self.dismiss(animated: true)
                    })
                    alert.addAction(done)
                    self.present(alert, animated: true)
                }    else if isValidEmail(email: email) == false {
                    let alert = UIAlertController(title: "Alert!!", message: "Email is not valid format", preferredStyle: .alert)
                        
                    let done = UIAlertAction(title: "Done", style: .default,handler: {(action) -> Void in self.dismiss(animated: true)
                    })
                    alert.addAction(done)
                    self.present(alert, animated: true)
                    }
            else{
                database.insert(name: nameField.text ?? "", mobileno: mobilenoField.text ?? "", email: emailField.text ?? "")
                
                navigationController?.popViewController(animated: true)
                print("data inserted")
            }
            
        }
    }
}
