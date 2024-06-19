//
//  PDFViewController.swift
//  test
//
//  Created by USER on 30/05/24.
//

import UIKit
import TPPDF

class Week9PDFViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate{
    
    @IBOutlet var pdfBodyView: UITextView!
    @IBOutlet var pdfTitleField: UITextField!
    
    @IBOutlet var lblSelectImage: UILabel!
    
    @IBOutlet var addPdfImage: UIImageView!
    let document = PDFDocument(format: .a4)
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "PDF Generator"
        pdfBodyView.delegate = self
        pdfBodyView.text = "Add Content here.."
        
        pdfBodyView.textColor = UIColor.gray
        pdfBodyView.layer.cornerRadius = 10.0
        
        addPdfImage.layer.cornerRadius = 10.0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        addPdfImage.isUserInteractionEnabled = true
        addPdfImage.addGestureRecognizer(tapGestureRecognizer)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblSelectImage.isHidden = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if pdfBodyView.text == "Add Content here.." {
            pdfBodyView.text = ""
            pdfBodyView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if pdfBodyView.text == "" {
            pdfBodyView.text = "Add Content here.."
            pdfBodyView.textColor = UIColor.gray
        }
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picCameraImage = UIImagePickerController()
            picCameraImage.delegate = self
            picCameraImage.sourceType = .photoLibrary
            picCameraImage.allowsEditing = false
            self.present(picCameraImage, animated: true)
        }
    }
    
    @IBAction func generatePDF(_ sender: UIButton) {
        
        if (pdfTitleField.hasText == true) && (pdfBodyView.hasText == true) && (addPdfImage.image != nil) {
            lblSelectImage.isHidden = true
            if let title = pdfTitleField.text,let body = pdfBodyView.text{
                
                //                let titleAttributes: [NSAttributedString.Key: Any] = [
                //                    .font: UIFont.boldSystemFont(ofSize: 24),
                //                    .foregroundColor: UIColor.black
                //                ]
                //  let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
                
                //   document.add(.contentCenter,attributedText: attributedTitle)
                
                document.add(space: 20.0)
                
                let generator = PDFGenerator(document: document)
                
                document.add(.contentLeft, text: "\(body)")
                
                document.add(image: PDFImage(image:addPdfImage.image!))
                let pdfNametitle = title + UUID().uuidString
                do{
                    let url = try generator.generateURL(filename: "\(pdfNametitle).pdf")
                    pdfTitleField.text = nil
                    pdfBodyView.text = nil
                    addPdfImage.image = nil
                    let vc = week9.instantiateViewController(withIdentifier: "ShowPDFViewController") as! ShowPDFViewController
                    vc.pdfUrl = url
                    vc.titlePDf = "\(title).pdf"
                    navigationController?.pushViewController(vc, animated: true)
                    print(url)
                }catch{
                    print("url error ")
                }
            }
        }else{
            customAlert(title: "Alert!!", message: "Required All Field")
        }
    }
    //    @IBAction func showAllPDF(_ sender: UIBarButtonItem) {
    //        let vc = storyboard?.instantiateViewController(withIdentifier: "ShowAllPDFViewController") as! ShowAllPDFViewController
    //        navigationController?.pushViewController(vc, animated: true)
    //    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            
            addPdfImage.image = image
            lblSelectImage.isHidden = true
        }
    }}
//    func customAlert(title:String,message:String){
//        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: .alert)
//
//        let saveAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(saveAction)
//        present(alert, animated: true)
//    }
//}
