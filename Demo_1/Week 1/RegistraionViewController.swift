//
//  RegistraionViewController.swift
//  Demo_1
//
//  Created by USER on 12/06/24.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics

class RegistraionViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    @IBOutlet var confirmPasswordField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    var  firebaseFireStore = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func onCreateAccountTapped(_ sender: UIButton) {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        guard let confirmPassword = confirmPasswordField.text else { return }
        guard let name = nameField.text else { return }
        
        if (email != "") && (password != "") && (confirmPassword != "") && (name != ""){
            if type(of: password) == String.self && type(of: confirmPassword) == String.self {
                if password == confirmPassword {
                    Auth.auth().createUser(withEmail: email, password: password){
                        authResult,error in
                        if let error = error {
                            self.customAlert(title: "\(error.localizedDescription)", message: "")
                            return
                        }
                        if let authResult = authResult{
                            self.firebaseFireStore.collection("users").document(authResult.user.uid).setData([
                                "name": name,
                                "email": email,
                                "uid": authResult.user.uid,
                            ])
                            Analytics.logEvent(AnalyticsEventSignUp, parameters: nil)
                            self.customAlert(title: "Account created successfully", message: "")
                        }
                    }
                } else{
                    self.customAlert(title: "Alert!", message: "Password and confirm password must be same")
                    print("password and confirm password must be same")
                }
            }
        }else{
            self.customAlert(title: "Alert!", message: "All field required")
            print("required all field")
        }
        
    }
    
}
