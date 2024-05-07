//
//  week3wiseViewController.swift
//  Demo_1
//
//  Created by iMac on 20/03/24.
//

import UIKit

class week3wiseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    @IBAction func onSqlTapped(_ sender: UIButton) {
        let vc = sqlStoryBoard.instantiateViewController(withIdentifier: "TableDataViewController") as! TableDataViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onFileManagerTapped(_ sender: UIButton) {
        
        let vc = fileManagerStoryboard.instantiateViewController(withIdentifier: "ViewController5") as! ViewController5
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ongestureTapped(_ sender: UIButton) {
        
        let vc = gestureStoryBoard.instantiateViewController(withIdentifier: "ViewController6") as! ViewController6
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
