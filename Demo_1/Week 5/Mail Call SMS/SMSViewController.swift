//
//  SMSViewController.swift
//  Demo_1
//
//  Created by iMac on 05/04/24.
//

import UIKit
import MessageUI




class SMSViewController: UIViewController,MFMessageComposeViewControllerDelegate{
   
    

    @IBOutlet weak var mobileNumber: UITextField!
    var mobile:String!
    var sendMSG:String!
    
    @IBOutlet weak var message: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
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
        self.message.center.x = self.view.frame.width + 100
        UIView.animate(withDuration: 3.0,delay: 0,usingSpringWithDamping: 1.0,initialSpringVelocity: 1.0,options: .allowAnimatedContent,animations: {
            self.message.center.x = self.view.frame.width/2
        },completion: nil)
      
        UIView.animate(withDuration: 1.5,animations: {
            self.sendButton.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
        },completion: {(finish) in
            UIView.animate(withDuration: 0.40, animations: {
                self.sendButton.transform = CGAffineTransform.identity
            })
            
        })
    }

    @IBAction func sendMessage(_ sender: UIButton) {
    
        if mobileNumber.hasText == true && message.hasText == true{
             mobile = mobileNumber.text
            sendMSG = message.text
          
            if validateMobileno(mobile) == false {
                customAlert(title: "Alert!!", message: "Mobile number is not valid")
            }else{
                if MFMessageComposeViewController.canSendText(){
                    let msg = MFMessageComposeViewController()
                    msg.messageComposeDelegate = self
                    msg.body = "\(sendMSG!)"
                    msg.recipients = [mobile]
                    present(msg, animated: true)
                    print("send message successfully")
                }else{
                    print(Error.self)
                }
            }
        }else{
            customAlert(title: "Alert!!", message: "All Field is required")
        }
    }
    func validateMobileno(_ input: String) -> Bool {
        let regex = "^[0-9]{10}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: input)
    }
//    func customAlert(title:String,message:String){
//        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
        mobileNumber.text = nil
        message.text = nil
    }
}
