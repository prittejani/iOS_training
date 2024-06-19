//
//  CustomDelegetsViewController.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit

class CustomDelegetsViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate{

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        textView.delegate = self
        textView.text = "Add Content here.."
        textView.textColor = UIColor.gray
        textView.layer.cornerRadius = 15.0
        
        nameField.delegate = self
     //   nameField.text = "Hello"
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add Content here.." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Add Content here.."
            textView.textColor = UIColor.gray
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    @IBAction func onOkTapped(_ sender: UIButton) {
        if textView.text == "Add Content here.." || nameField.text == ""{
           customAlert(title: "Alert!!", message: "Enter Value")
        }else{
            let val = textView.text
            let name =  nameField.text

            customAlert(title: "Name is \(name!) and Value is \(val!)", message: "")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameField.placeholder = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameField.placeholder = "Name"
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
//    func customAlert(title:String,message:String){
//        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
}
