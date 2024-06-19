//
//  CreateEmployeeViewController.swift
//  Demo_1
//
//  Created by USER on 13/06/24.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD

class CreateEmployeeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet var btnSaveOrchanges: UIButton!
    var realtimeFirebase:DatabaseReference!
    var firebaseStorage = Storage.storage().reference()
    var imageUrl:URL!
    var isFromCell:Bool!
    var index:Int!
    var isPickedImage:Bool!
    var currentEmployee: EmployeeModel?
    let gender = [
        "Male",
        "Female",
        "Transgender",
        "Prefer Not to Say"
    ]

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var salaryField: UITextField!
    @IBOutlet var mobileField: UITextField!
    @IBOutlet var genderField: UITextField!
    @IBOutlet var designationField: UITextField!
    @IBOutlet var nameField: UITextField!
    var genderPicker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        realtimeFirebase = Database.database().reference()
        genderField.inputView = genderPicker

        genderPicker.delegate = self
        genderPicker.dataSource = self
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectImage(_:))))
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return gender[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            genderField.text = gender[row]
        if isFromCell == true{
            let isGenderChanged = genderField.text != employeeArray[index].gender
            btnSaveOrchanges.isEnabled = isGenderChanged
        }
            genderField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isFromCell == true{
            let url = URL(string: employeeArray[index].profileImage)
            if url != nil {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async { [self] in
                        if data != nil {
                            profileImage.image = UIImage(data:data!)
                        }
                    }
                }
            }
            btnSaveOrchanges.isEnabled = false
            emailField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            salaryField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            mobileField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            genderField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            designationField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            nameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            emailField.text = employeeArray[index].email
            salaryField.text = String(employeeArray[index].salary)
            mobileField.text = employeeArray[index].mobileno
            genderField.text = employeeArray[index].gender
            designationField.text = employeeArray[index].designation
            nameField.text = employeeArray[index].name
            btnSaveOrchanges.setTitle("Save Changes", for: .normal)
        }
    }
    @objc func textFieldDidChange(_ sender:UITextField) {
    
        let isNameChanged = nameField.text != employeeArray[index].name
        let isEmailChanged = emailField.text != employeeArray[index].email
        let isDesignationChanged = designationField.text != employeeArray[index].designation
        let isSalaryChanged = salaryField.text != String(employeeArray[index].salary)
        let isGenderChanged = genderField.text != employeeArray[index].gender
        let isMobilenoChanged = mobileField.text != employeeArray[index].mobileno
        let selectedImgUrl = imageUrl == nil ? false : true
        
        btnSaveOrchanges.isEnabled = isNameChanged || isEmailChanged || isDesignationChanged || isSalaryChanged || isGenderChanged || isMobilenoChanged || selectedImgUrl
    }
    @objc func selectImage(_ sender:UITapGestureRecognizer){
        print("tapped")
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picCameraImage = UIImagePickerController()
            picCameraImage.delegate = self
            picCameraImage.sourceType = .photoLibrary
            picCameraImage.allowsEditing = false
            self.present(picCameraImage, animated: true)
        }
    }
    
    @IBAction func onSaveTapped(_ sender: UIButton) {
        guard let name = nameField.text else { return }
        guard let designation = designationField.text else { return }
        guard let gender = genderField.text else { return }
        guard let mobileno = mobileField.text else { return }
        guard let salary = salaryField.text else { return }
        guard let email = emailField.text else { return }
        if isValidEmail(email: email) == false {
            self.customAlert(title: "Alert!", message: "Enter valid email")
            return
        }
        if validateMobileno(mobileno) == false {
            customAlert(title: "Alert!!", message: "Mobile number is not valid")
            return
        }
        if isFromCell == true {
            if isPickedImage == true {
                if (name != "")&&(designation != "")&&(gender != "")&&(mobileno != "")&&(salary != "")&&(email != "")&&(imageUrl != nil) {
                   
                    SVProgressHUD.show()
                    let storageRef = Storage.storage().reference().child("EmployeeImages/\(imageUrl.lastPathComponent)")
                    
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    
                    storageRef.putFile(from: imageUrl, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("Error uploading image: \(error.localizedDescription)")
                            return
                        }
                        storageRef.downloadURL { [self] (url, error) in
                            if let error = error {
                                print("Error getting download URL: \(error.localizedDescription)")
                                return
                            }
                            
                            guard let downloadURL = url else { return }
                            
                            
                            self.realtimeFirebase.child("employees").child(employeeArray[index].id).updateChildValues(EmployeeModel(id: employeeArray[index].id, name: name,profileImage: downloadURL.absoluteString, designation: designation, email: email, gender: gender, mobileno: mobileno, salary: Int(salary)!).toDictionary()){
                                error,reference in
                                if let error = error {
                                    self.customAlert(title: "\(error.localizedDescription)", message: "")
                                    print("Error updating employee: \(error.localizedDescription)")
                                } else {
                                    SVProgressHUD.dismiss()
                                    self.CustomAlert(title: "Employee updated successfully", message: "")
                                    print("Employee updated successfully")
                                }
                            }
                            print("Image uploaded successfully. Download URL: \(downloadURL.absoluteString)")
                        }
                        //self.navigationController?.popViewController(animated: true)
                        
                    }
                }else{
                    
                        self.customAlert(title: "Alert!", message: "All field required")
                }
                
            }else{
                if (name != "")&&(designation != "")&&(gender != "")&&(mobileno != "")&&(salary != "")&&(email != "") {
                  
                    btnSaveOrchanges.isEnabled = true
                    self.realtimeFirebase.child("employees").child(employeeArray[index].id).updateChildValues(EmployeeModel(id: employeeArray[index].id, name: name,profileImage: employeeArray[index].profileImage, designation: designation, email: email, gender: gender, mobileno: mobileno, salary: Int(salary)!).toDictionary()){
                        error,reference in
                        if let error = error {
                            self.customAlert(title: "\(error.localizedDescription)", message: "")
                            print("Error updating employee: \(error.localizedDescription)")
                        } else {
                            self.CustomAlert(title: "Employee updated successfully", message: "")
                           // self.navigationController?.popViewController(animated: true)
                            print("Employee updated successfully")
                         
                        }
                    }
                }else{
                    self.customAlert(title: "Alert!", message: "All field required")
                }
            }
            
    }else{
        if (name != "")&&(designation != "")&&(gender != "")&&(mobileno != "")&&(salary != "")&&(email != "")&&(imageUrl != nil) {
            SVProgressHUD.show()
            let storageRef = Storage.storage().reference().child("EmployeeImages/\(imageUrl.lastPathComponent)")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            storageRef.putFile(from: imageUrl, metadata: metadata) { (metadata, error) in
                if let error = error {
                    self.customAlert(title: "\(error.localizedDescription)", message: "")
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        self.customAlert(title: "\(error.localizedDescription)", message: "")
                        print("Error getting download URL: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let downloadURL = url else { return }
                    
                    guard let key = self.realtimeFirebase.child("employees").childByAutoId().key else { return }
                    
                    self.realtimeFirebase.child("employees").child(key).setValue(EmployeeModel(id: key, name: name,profileImage: downloadURL.absoluteString, designation: designation, email: email, gender: gender, mobileno: mobileno, salary: Int(salary)!).toDictionary())
                    SVProgressHUD.dismiss()
                    self.CustomAlert(title: "Employee added successfully", message: "")
                    print("Image uploaded successfully. Download URL: \(downloadURL.absoluteString)")
                }
                
            }
          

        }else{
            self.customAlert(title: "Alert!", message: "All field required")
        }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage{
            profileImage.image = image
            isPickedImage = true
        }
         imageUrl = info[.imageURL] as? URL
        btnSaveOrchanges.isEnabled = true
        
      
    }
    func CustomAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default){
            _ in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(saveAction)
        
        self.present(alert, animated: true, completion: nil)
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


}
struct EmployeeModel {
    var id:String
    var name: String
    var profileImage:String
    var designation: String
    var email: String
    var gender: String
    var mobileno: String
    var salary: Int

    func toDictionary() -> [String: Any] {
        return [
            "id":id,
            "profileImage":profileImage,
            "name": name,
            "designation": designation,
            "gender": gender,
            "mobileno": mobileno,
            "salary": salary,
            "email": email,
        ]
    }
}
