//
//  Week10ViewController.swift
//  Demo_1
//
//  Created by USER on 18/06/24.
//

import UIKit

class Week10ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onQrCodeTapped(_ sender: UIButton) {
        let vc = week10.instantiateViewController(withIdentifier: "ScanHomeViewController") as! ScanHomeViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onFirestoreTapped(_ sender: UIButton) {
        let vc = week10.instantiateViewController(withIdentifier: "TodoListViewController") as! TodoListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onRealtimeTapped(_ sender: UIButton) {
        let vc = week10.instantiateViewController(withIdentifier: "EmployeeListViewController") as! EmployeeListViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onSpeechToTextTapepd(_ sender: UIButton) {
        let vc = week9.instantiateViewController(withIdentifier: "SpeechToTextViewController") as! SpeechToTextViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onTextToSpeechTapped(_ sender: UIButton) {
        let vc = week9.instantiateViewController(withIdentifier: "TextToSpeechViewController") as! TextToSpeechViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
