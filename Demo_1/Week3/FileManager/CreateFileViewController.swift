//
//  CreateFileViewController.swift
//  FileManager
//
//  Created by iMac on 29/02/24.
//

import UIKit
import Foundation

class CreateFileViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate{
    
    
    
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var textFileContent: UITextView!
    @IBOutlet weak var fileNameField: UITextField!
    
    var isUpdate:Bool = false
    var fileName:String!
    var fileContent:String!
    var fileIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileNameField.delegate = self
        textFileContent.delegate = self
        textFileContent.text = "Add Content here.."
        
        textFileContent.textColor = UIColor.gray
        textFileContent.layer.cornerRadius = 15.0
        
        btnCreate.layer.cornerRadius = 5.0
        btnCreate.clipsToBounds = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancelTapped))
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textFileContent.text == "Add Content here.." {
            textFileContent.text = ""
            textFileContent.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textFileContent.text == "" {
            textFileContent.text = "Add Content here.."
            textFileContent.textColor = UIColor.gray
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isUpdate == true{
            if let fname = fileName{
                fileNameField.text = fname.components(separatedBy: ["."]).first
                
            }
            textFileContent.text = fileContent
            btnCreate.setTitle("Save Changes", for: .normal)
        }
    }
    @objc func onCancelTapped(){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func onCreateTapped(_ sender: UIButton) {
        
        // MARK: - create file in  local
        if isUpdate == false {
            
            if (fileNameField.hasText == true) && (textFileContent.hasText == true){
                if let fileName = fileNameField.text {
                    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                        
                        let fileUrl = dir.appendingPathComponent("\(fileName).txt")
                        if FileManager.default.fileExists(atPath: "\(fileUrl)"){
                            do{
                                try FileManager.default.removeItem(at: fileUrl)
                                print("already exist file deleted")
                                navigationController?.popViewController(animated: true)
                                if let index = fileNameArray.firstIndex(of: "\(fileName).txt"){
                                    fileNameArray.remove(at: index)
                                }
                                if let content = textFileContent.text {
                                    do{
                                        try content.write(to: fileUrl, atomically: false, encoding: .utf8)
                                        print("~~>> file created at \(fileUrl)")
                                        navigationController?.popViewController(animated: true)
                                        fileNameArray.append("\(fileName).txt")
                                      
                                    }catch{
                                        print("file creation error")
                                    }
                                }
                                
                            }catch{
                                print("already existed file not deleted")
                            }
                        }else{
                            if let content = textFileContent.text {
                                do{
                                    try content.write(to: fileUrl, atomically: false, encoding: .utf8)
                                    print("~~>> file created at \(fileUrl)")
                                    navigationController?.popViewController(animated: true)
                                    fileNameArray.append("\(fileName).txt")
                                }catch{
                                    print("file creation error")
                                }
                            }
                        }
                    }
                }
            }else{
               customAlert(title: "Alert!!", message: "Please enter content")
            }
            
        }else {
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                btnCreate.setTitle("Save Changes", for: .normal)
                let fileManager = FileManager.default
                if let name = fileName{
                    
                    let fileUrl = dir.appendingPathComponent("\(name)")
                    do{
                        if let filename = fileNameField.text,let content = textFileContent.text{
                            try FileManager.default.removeItem(at: fileUrl)
                            fileNameArray.remove(at: fileIndex)
                            let newFileUrl = dir.appendingPathComponent("\(filename).txt")
                            try content.write(to: newFileUrl, atomically: false, encoding: .utf8)
                            print("~~>> file updated at \(fileUrl)")
                            fileNameArray.append("\(filename).txt")
                            navigationController?.popViewController(animated: true)
                        }

                    }catch{
                        print("\(error)")
                    }
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
