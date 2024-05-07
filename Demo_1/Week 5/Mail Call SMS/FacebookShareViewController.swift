//
//  FacebookShareViewController.swift
//  Demo_1
//
//  Created by iMac on 05/04/24.
//

import UIKit

class FacebookShareViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var message: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func addImage(_ sender: UIButton) {
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
    @IBAction func shareFacebook(_ sender: UIButton) {
        
    }
    
    
}
