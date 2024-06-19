//
//  week9ViewController.swift
//  Demo_1
//
//  Created by USER on 04/06/24.
//

import UIKit

class week9ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func onGalleryTapped(_ sender: UIButton) {
        
        let vc = week9.instantiateViewController(withIdentifier: "GalleryViewViewController") as! GalleryViewViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func onMvcMvvmTapped(_ sender: UIButton) {
        let vc = mvvm.instantiateViewController(withIdentifier: "MVVMViewController") as! MVVMViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onWaterfallTapped(_ sender: UIButton) {
       let vc = week9.instantiateViewController(withIdentifier: "WaterfallLayoutViewController") as! WaterfallLayoutViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func onexpandableTableviewTapped(_ sender: UIButton) {
        let vc = week9.instantiateViewController(withIdentifier: "ExpandableTableViewViewController") as! ExpandableTableViewViewController
         navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onGeneratepdfTapped(_ sender: UIButton) {
        let vc = week9.instantiateViewController(withIdentifier: "Week9PDFViewController") as! Week9PDFViewController
         navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onCollectionViewInsideTableviewTapped(_ sender: UIButton) {
        
        let vc = week9.instantiateViewController(withIdentifier: "CollectionviewInsideTableviewViewController") as! CollectionviewInsideTableviewViewController
         navigationController?.pushViewController(vc, animated: true)
    }
}
