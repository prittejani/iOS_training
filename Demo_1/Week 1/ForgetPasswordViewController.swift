//
//  ForgetPasswordViewController.swift
//  Demo_1
//
//  Created by USER on 13/06/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore


class ForgetPasswordViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onResetButtonTapped(_ sender: UIButton) {
        guard let email = emailField.text else { return }
        
        if email != "" {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.customAlert(title: "Alert!", message: error.localizedDescription)
                    return
                }else{
                    self.customAlert(title: "Reset password link has been sent to your email", message: "")
                    print("success link")
                }
                
            }
        }else{
            self.customAlert(title: "Please enter email", message: "")
        }
        
    }
    
}
