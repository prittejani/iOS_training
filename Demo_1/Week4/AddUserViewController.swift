//
//  AddUserViewController.swift
//  Webservices
//
//  Created by iMac on 04/03/24.
//

import UIKit
import Alamofire
import SVProgressHUD


class AddUserViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var isImage:Bool!
  
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userName: UITextField!
    var user:[Datum] = []
    var fromCell:Bool!
    var index:Int!
    var userId:Int!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        
        super.viewDidLoad()
               let picImage = UITapGestureRecognizer(target: self, action: #selector(getImagePhotoLibrary))
               imageView.addGestureRecognizer(picImage)
       
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if fromCell == true {
            let url = URL(string: user[index].profilePic)
                if url != nil {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async { [self] in
                            if data != nil {
                            imageView.image = UIImage(data:data!)
                        }
                    }
                }
            }
            userName.text = user[index].name
            userEmail.text = user[index].email
            userId = user[index].userID
        }
    }
    
    func validateEmail(enteredEmail:String) -> Bool {

        let emailFormat = "[a-zA-Z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
 
    @objc func getImagePhotoLibrary(){
       if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary
           imagePicker.allowsEditing = false
           self.present(imagePicker,animated: true,completion: nil)
       }
   }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let img = info[.originalImage] as? UIImage
        {
            imageView.image = img
            isImage = true
        }else{
            isImage = false
        }
    }
    @IBAction func onSubmitTapped(_ sender: UIButton) {
        
        
        if fromCell==true{
            if  let name = userName.text, let email = userEmail.text{
                if (userName.text == ""){
                    customAlert(title: "Alert!!", message: "Plase enter name")
                }else if (userEmail.text == ""){
                    customAlert(title: "Alert!!", message: "Plase enter email")
                }else if imageView.image == nil{
                    customAlert(title: "Alert!!", message: "Please select image")
                }
                else if !validateEmail(enteredEmail: email){
                    customAlert(title: "Alert!!", message: "Please enter valid email")
                }
                else{
                    
                    let imageData = imageView.image?.jpegData(compressionQuality: 1)
                    updateData(name: name, email: email, imageData: imageData!){
                        response in
                        self.user = response
                        DispatchQueue.main.async {
                         
                        }
                    }
                  
                }
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            if  let name = userName.text, let email = userEmail.text{
                if (userName.text == ""){
                    customAlert(title: "Alert!!", message: "Plase enter name")
                }else if (userEmail.text == ""){
                    customAlert(title: "Alert!!", message: "Plase enter email")
                }
                else if imageView.image == nil{
                    customAlert(title: "Alert!!", message: "Please select image")
                }
                else if !validateEmail(enteredEmail: email){
                    customAlert(title: "Alert!!", message: "Enter valid email")
                }
                else{
                    let imageData = imageView.image?.jpegData(compressionQuality: 1)
                    
                    addData(name: name, email: email, imageData: imageData!){
                        response in
                        self.user = response
                        DispatchQueue.main.async {
                           
                        }
                    }
                    
                    navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func addData(name: String,email: String,imageData: Data,completionHandler: @escaping ([Datum]) -> Void){
        let parameter = ["name":name,"email":email]
        let url = URL(string: "http://192.168.29.72/blog/api/add_user")!
        
        AF.upload(multipartFormData: {multipartFormData in
            for(key,value) in parameter {
                if let data = "\(value)".data(using: .utf8){
                    multipartFormData.append(data, withName: key)
                }
            }
            multipartFormData.append(imageData, withName: "profile_pic",fileName: "image.jpg",mimeType: "image/jpeg")
            
        }, to: url).responseDecodable(of:User.self){ response in
            switch response.result {
            case .success(let data):
                print("data : \(data)")
                completionHandler(self.user)
        
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    func updateData(name: String,email: String,imageData: Data,completionHandler: @escaping ([Datum]) -> Void){

        let parameter = ["name":name,"email":email,"user_id":String(userId)]
        let url = URL(string: "http://192.168.29.72/blog/api/edit_user_details")!
        
        AF.upload(multipartFormData: { multipartFormData in
            for(key,value) in parameter
            {
                if let data = "\(value)".data(using: .utf8){
                    multipartFormData.append(data, withName: key)
                }
            }
            multipartFormData.append(imageData, withName: "profile_pic",fileName: "image.jpg",mimeType: "image/jpeg")
            
        }, to: url).responseDecodable(of:User.self){ response in
            switch response.result {
            case .success(let data):
                print("data : \(data)")
                completionHandler(self.user)
                //self.customAlert(title: "Alert", message: "user updated")
        
            case .failure(let error):
                print("error: \(error)")
                //self.customAlert(title: "Alert", message: "\(error)")
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

