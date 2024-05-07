//
//  iOS_19ViewController.swift
//  Demo_1
//
//  Created by iMac on 05/04/24.
//

import UIKit
import MessageUI

class iOS_19ViewController: UIViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        let vc = services.instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sendSMS(_ sender: UIButton) {
        let vc = services.instantiateViewController(withIdentifier: "SMSViewController") as! SMSViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func makeCall(_ sender: UIButton) {
        let vc = services.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareOnWhatsapp(_ sender: UIButton) {
        
        let vc = services.instantiateViewController(withIdentifier: "WhatsappShareViewController") as! WhatsappShareViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func googleMap(_ sender: UIButton) {
        let vc = Demo_1.googleMap.instantiateViewController(withIdentifier: "GoogleMapViewController") as! GoogleMapViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
