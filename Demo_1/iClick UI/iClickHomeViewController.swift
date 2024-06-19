//
//  iClickHomeViewController.swift
//  Demo_1
//
//  Created by iMac on 20/05/24.
//

import UIKit
import LGSegmentedControl


class iClickHomeViewController: UIViewController {

   
    @IBOutlet weak var TopViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var customSegmentView: LGSegmentedControl!
    @IBOutlet weak var sendImageView: UIImageView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        sendImageView.layer.cornerRadius = sendImageView.frame.width / 2

        searchView.layer.cornerRadius = searchView.frame.height / 2
        searchView.clipsToBounds = true
        customSegmentView.segmentsCornerRadius = 8.0
        collectionView.delegate = self
        collectionView.dataSource = self
        TopView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
 
   }
  

      

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            if UIDevice.current.orientation.isLandscape {
                print("landscape")
                NSLayoutConstraint.deactivate(self.view.constraints.filter { $0.firstItem === self.TopView && $0.firstAttribute == .height })
                NSLayoutConstraint.activate([
                    self.TopView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.224178)
                ])
            } else {
                print("portrait")
                NSLayoutConstraint.deactivate(self.view.constraints.filter { $0.firstItem === self.TopView && $0.firstAttribute == .height })
                NSLayoutConstraint.activate([
                    self.TopView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.224178)
                ])
            }
            
            // Force layout update
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
}

extension iClickHomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/1.09, height: collectionView.bounds.height/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
     }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! iClickPostCollectionViewCell

        return cell
    }
    
}
