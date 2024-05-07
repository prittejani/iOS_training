//
//  instanceDataPassViewController.swift
//  Demo_1
//
//  Created by iMac on 19/03/24.
//

import UIKit

class instanceDataPassViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func validateName(_ name: String) -> Bool {
        let regex = "^[a-zA-Z\\_]{3,18}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: name)
    }
    @IBAction func onOkTapped(_ sender: UIButton) {
      
        if let name:String = nameField.text {
            if nameField.text == "" {
                customAlert(title: "Alert!!", message: "Name required")
            }else if !validateName(name){
                customAlert(title: "Alert!!", message: "Enter valid name")
            }
            else{
                let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "instanceDataPassedViewController") as! instanceDataPassedViewController
                vc.name = nameField.text
                navigationController?.pushViewController(vc, animated: true)
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
