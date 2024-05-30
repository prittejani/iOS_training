//
//  EmailViewController.swift
//  Demo_1
//
//  Created by iMac on 05/04/24.
//

import UIKit
import MessageUI
import SendGrid

class EmailViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    var email:String!
    var subjectOfMail:String!
    var bodyOfMail:String!
    @IBOutlet weak var sendMail: UIButton!
    @IBOutlet weak var sendMail2: UIButton!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var toMail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        toMail.delegate = self
        subject.delegate = self
        
        toMail.keyboardType = .emailAddress
        
        body.delegate = self
        body.text = "Compose Mail"
        
        body.textColor = UIColor.gray
        body.layer.cornerRadius = 15.0
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.toMail.center.x = self.view.frame.width + 50
        UIView.animate(withDuration: 2.0,delay: 0,usingSpringWithDamping: 1.0,initialSpringVelocity: 1.0,options: .allowAnimatedContent,animations: {
            self.toMail.center.x = self.view.frame.width/2
        },completion: nil)
        self.subject.center.x = self.view.frame.width + 100
        UIView.animate(withDuration: 2.0,delay: 0,usingSpringWithDamping: 1.0,initialSpringVelocity: 1.0,options: .allowAnimatedContent,animations: {
            self.subject.center.x = self.view.frame.width/2
        },completion: nil)
      
        UIView.animate(withDuration: 1.2,animations: {
            self.body.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        },completion: {(finish) in
            UIView.animate(withDuration: 0.40, animations: {
                self.body.transform = CGAffineTransform.identity
            })
            
        })
        UIView.animate(withDuration: 1.2,animations: {
            self.sendMail.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        },completion: {(finish) in
            UIView.animate(withDuration: 0.40, animations: {
                self.sendMail.transform = CGAffineTransform.identity
            })
            
        })
        UIView.animate(withDuration: 1.2,animations: {
            self.sendMail2.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        },completion: {(finish) in
            UIView.animate(withDuration: 0.40, animations: {
                self.sendMail2.transform = CGAffineTransform.identity
            })
            
        })
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if body.text == "Compose Mail" {
            body.text = ""
            body.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if body.text == "" {
            body.text = "Compose Mail"
            body.textColor = UIColor.gray
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        if toMail.hasText == true && subject.hasText == true && body.hasText == true {
             email = toMail.text
            subjectOfMail = subject.text
            bodyOfMail = body.text
            if isValidEmail(email: email) == false {
                customAlert(title: "Alert!!", message: "Email is not valid")
            }else{
                if MFMailComposeViewController.canSendMail(){
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([email])
                    mail.setMessageBody("<p>\(bodyOfMail!)</p>", isHTML: true)
                    mail.setSubject("\(subjectOfMail!)")
                    present(mail, animated: true)
                    print("send mail successfully")
                }else{
                    print(Error.self)
                }
            }
        }else{
            customAlert(title: "Alert!!", message: "All Field is required")
        }
    }
    
    @IBAction func sendViaThirdParty(_ sender: UIButton) {
        
        let sendGrid = SendGridService()
        if toMail.hasText == true && subject.hasText == true && body.hasText == true {
             email = toMail.text
            subjectOfMail = subject.text
            bodyOfMail = body.text
            if isValidEmail(email: email) == false {
                customAlert(title: "Alert!!", message: "Email is not valid")
            }else{
                sendGrid.sendEmail(to: email, subject: subjectOfMail, body: "\(bodyOfMail!)")
                customAlert(title: "Done", message: "Mail Sent Successfully to \(email!)")
            }
        }else{
            customAlert(title: "Alert!!", message: "All Field is required")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func customAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
}
