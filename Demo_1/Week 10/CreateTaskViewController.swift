//
//  CreateTaskViewController.swift
//  Demo_1
//
//  Created by USER on 14/06/24.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import Foundation

let db = Firestore.firestore()
class CreateTaskViewController: UIViewController,UITextViewDelegate{

    @IBOutlet var titleField: UITextField!
    var createDate:Date!
    var doneDate:Date!
    @IBOutlet var btnSaveOrSaveChanges: UIButton!
    @IBOutlet var createDateField: UITextField!
    @IBOutlet var doneDateField: UITextField!
    @IBOutlet var descriptionView: UITextView!
    var index:Int!
    var isFromCell:Bool!
    
    var fDoneDate:AnyObject!
    var dTimestamp:AnyObject!
    let firebaseFireStore = Firestore.firestore()
    let datePicker = UIDatePicker()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        descriptionView.delegate = self
        descriptionView.text = "Add Description here.."
        
        descriptionView.textColor = UIColor.gray
        descriptionView.layer.cornerRadius = 15.0
    }
   
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add Description here.." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Add Description here.."
            textView.textColor = UIColor.gray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFromCell == true {
            
            self.createDate = todosRecord[index].createDate
            self.doneDate = todosRecord[index].doneDate
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            titleField.text = todosRecord[index].taskTitle
            descriptionView.text = todosRecord[index].taskDescription
            createDateField.text = "\( dateFormatter.string(from: todosRecord[index].createDate))"
            doneDateField.text = todosRecord[index].doneDate == nil ? "" : "\(dateFormatter.string(from: todosRecord[index].doneDate!))"
            
        }
    }


    @IBAction func onSaveTapped(_ sender: UIButton) {

        if  titleField.text == "" {
            self.customAlert(title: "Alert!", message: "Enter title")
        }else if  descriptionView.text == "Add Description here.." {
            self.customAlert(title: "Alert!", message: "Enter description")
        }else if createDateField.text == "" {
            self.customAlert(title: "Alert!", message: "Enter create date")
        }else {
            
            guard let currentUserId = Auth.auth().currentUser?.uid else { return }
            var docId = ""
            if isFromCell == true {
                docId = todosRecord[index].id
            }else{
                docId = db.collection("users").document(currentUserId).collection("todos").document().documentID
            }
            
            var dTimestamp: Timestamp? = nil
            var status = false
            
            if doneDate != nil {
                if createDate < doneDate {
                    dTimestamp = Timestamp(date: doneDate)
                    status = true
                }else {
                    self.customAlert(title: "Alert!", message: "Enter valid create and done date")
                   return
                }
                
            }
            db.collection("users").document(currentUserId).collection("todos").document(docId).setData(Todo(id: docId, taskTitle: titleField.text!, taskDescription: descriptionView.text, createDate: createDate!,doneDate: dTimestamp?.dateValue() ,status: status).toDictionary())
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func createToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donepressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelpressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneButton,space,cancelButton], animated: true)
       
        return toolbar
    }
    func doneToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(ddonepressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelpressed))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneButton,space,cancelButton], animated: true)
       
        return toolbar
    }
    
    func createDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date.now
      
        createDateField.inputView = datePicker
        doneDateField.inputView = datePicker
        createDateField.inputAccessoryView = createToolbar()
        doneDateField.inputAccessoryView = doneToolbar()
    
    }
    @objc func cancelpressed (){
        
        self.resignFirstResponder()
    }
    
    @objc func  donepressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        self.createDateField.text = dateFormatter.string(from: datePicker.date)
        self.createDate = datePicker.date
        self.view.endEditing(true)
    }
    @objc func  ddonepressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        self.doneDateField.text = dateFormatter.string(from: datePicker.date)
        self.doneDate = datePicker.date
        self.view.endEditing(true)
    }
    

}
//struct Todo: Codable {
//    var id: String
//    var taskTitle: String
//    var taskDescription: String
//    var createDate: Date
//    var doneDate: Date?
//    var status: String
//}
struct Todo: Codable {
    var id: String
    var taskTitle: String
    var taskDescription: String
    var createDate: Date
    var doneDate: Date?
    var status: Bool
    
    // Enum to specify custom keys for encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case taskTitle
        case taskDescription
        case createDate
        case doneDate
        case status
    }
}

extension Todo {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let taskTitle = dictionary["taskTitle"] as? String,
              let taskDescription = dictionary["taskDescription"] as? String,
              let createDateTimestamp = dictionary["createDate"] as? Timestamp,
              let status = dictionary["status"] as? Bool else {
            return nil
        }
        
        self.id = id
        self.taskTitle = taskTitle
        self.taskDescription = taskDescription
        self.createDate = createDateTimestamp.dateValue()
        self.doneDate = (dictionary["doneDate"] as? Timestamp)?.dateValue()
        self.status = status
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [
            "id": id,
            "taskTitle": taskTitle,
            "taskDescription": taskDescription,
            "createDate": Timestamp(date: createDate),
            "status": status
        ]
        
        if let doneDate = doneDate {
            dictionary["doneDate"] = Timestamp(date: doneDate)
        }
        
        return dictionary
    }
}
