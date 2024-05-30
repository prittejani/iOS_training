//
//  CallViewController.swift
//  Demo_1
//
//  Created by iMac on 05/04/24.
//

import UIKit


class CallViewController: UIViewController {
    var mobile:String!
    @IBOutlet weak var calButtonl: UIButton!
    @IBOutlet weak var mobileNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumber.keyboardType = .phonePad
        
    }  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mobileNumber.center.x = self.view.frame.width + 50
        UIView.animate(withDuration: 3.0,delay: 0,usingSpringWithDamping: 1.0,initialSpringVelocity: 1.0,options: .allowAnimatedContent,animations: {
            self.mobileNumber.center.x = self.view.frame.width/2
        },completion: nil)
    
      
        UIView.animate(withDuration: 1.5,animations: {
            self.calButtonl.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        },completion: {(finish) in
            UIView.animate(withDuration: 0.40, animations: {
                self.calButtonl.transform = CGAffineTransform.identity
            })
            
        })
    }
    
    @IBAction func makeCall(_ sender: UIButton) {
        if mobileNumber.hasText == true{
             mobile = mobileNumber.text
            if validateMobileno(mobile) == false {
                self.customAlert(title: "Alert!!", message: "Mobile number is not valid")
            }else{
                if let url = URL(string: "tel://\(mobile!)"),UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url)
                }else{
                    print(Error.self)
                }
            }
        }else{
            self.customAlert(title: "Alert!!", message: "Mobile number is required")
        }

    }
    func validateMobileno(_ input: String) -> Bool {
        let regex = "^[0-9]{10}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
    func customAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
}
