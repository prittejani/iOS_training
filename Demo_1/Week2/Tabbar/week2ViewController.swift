//
//  week2ViewController.swift
//  Demo_1
//
//  Created by iMac on 19/03/24.
//

import UIKit

class week2ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func tabTapped(_ sender: UIButton) {
        let vc = week2StoryBoard.instantiateViewController(withIdentifier: "tabbarOptionsViewController") as! tabbarOptionsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func onDataPassTapped(_ sender: UIButton) {
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "DatapassButtonsViewController") as! DatapassButtonsViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onCameraTapped(_ sender: UIButton) {
        let vc = cameraVideo.instantiateViewController(withIdentifier: "CViewController") as! CViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
