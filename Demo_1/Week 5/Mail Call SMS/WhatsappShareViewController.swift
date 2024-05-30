//
//  WhatsappShareViewController.swift
//  Demo_1
//
//  Created by iMac on 05/04/24.
//

import UIKit

class WhatsappShareViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var shareMsg:String!
    @IBOutlet weak var message: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    @IBAction func shareOnWhatsapp(_ sender: UIButton) {
        
        if message.hasText == true{
            shareMsg = message.text
            guard let image = imageView.image else {
                customAlert(title: "Alert", message: "Please Select Image")
                return
            }
            
            let activityViewController = UIActivityViewController(activityItems: [image,shareMsg!], applicationActivities: [])
            if let popoverPresentationController = activityViewController.popoverPresentationController{
                popoverPresentationController.sourceView = self.view
                popoverPresentationController.sourceRect = self.view.bounds
            }
            activityViewController.excludedActivityTypes = [
                .addToReadingList,
                .openInIBooks
            ]
            
            present(activityViewController, animated: true, completion: nil)
            //            let urlWhats = "whatsapp://send?text=\("\(shareMsg!)")"
            //            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            //                  if let whatsappURL = NSURL(string: urlString) {
            //                        if UIApplication.shared.canOpenURL(whatsappURL as URL) {
            //                             UIApplication.shared.open(whatsappURL as URL)
            //                         }
            //                         else {
            //                             customAlert(title: "Alert!!", message: "Please install whatsapp")
            //                         }
            //                  }
            //            }
            //        }else{
            //            customAlert(title: "Alert!!", message: "Message is required")
            //        }
        }
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picCameraImage = UIImagePickerController()
            picCameraImage.delegate = self
            picCameraImage.sourceType = .photoLibrary
            picCameraImage.allowsEditing = false
            self.present(picCameraImage, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
        }
    }
    
    func customAlert(title:String,message:String){
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
}
