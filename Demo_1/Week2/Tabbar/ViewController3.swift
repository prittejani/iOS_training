//
//  ViewController.swift
//  tabbar
//
//  Created by iMac on 23/02/24.
//

import UIKit
import WebKit

class ViewController3: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let url = URL(string: "https://www.google.com")else{return}
//        webView.load(URLRequest(url: url))
       

        
    }
    

    @IBAction func onTapped(_ sender: UIButton) {
        let vc = week2StoryBoard.instantiateViewController(withIdentifier: "InsideHomeViewController") as! InsideHomeViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

