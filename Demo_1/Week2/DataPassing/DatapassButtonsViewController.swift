//
//  DatapassButtonsViewController.swift
//  Demo_1
//
//  Created by iMac on 19/03/24.
//

import UIKit
let dataPassStoryBoard = UIStoryboard(name: "datapass", bundle: nil)
class DatapassButtonsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSegueTapped(_ sender: UIButton) {
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClouserTapped(_ sender: UIButton) {
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "ClouserDataPassedViewController") as! ClouserDataPassedViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onDelegetTapped(_ sender: UIButton) {
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "DelegetDataViewController") as! DelegetDataViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onNotificationCenterTapped(_ sender: UIButton) {
        
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "NotificationcenterDataViewController") as! NotificationcenterDataViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onInstanceTapped(_ sender: UIButton) {
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "instanceDataPassViewController") as! instanceDataPassViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onInitTapped(_ sender: UIButton) {
        let vc = dataPassStoryBoard.instantiateViewController(withIdentifier: "")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
}
