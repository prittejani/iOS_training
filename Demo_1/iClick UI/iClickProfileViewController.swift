//
//  ProfileViewController.swift
//  Demo_1
//
//  Created by iMac on 22/05/24.
//

import UIKit
import LGSegmentedControl
import CHTCollectionViewWaterfallLayout

class iClickProfileViewController: UIViewController,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    var ImageArray:[UIImage] = [UIImage(named: "w1")!,UIImage(named: "w2")!,UIImage(named: "w3")!,UIImage(named: "w4")!]
    


    @IBOutlet weak var profileTabView: LGSegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileFollowView: UIView!
   

    @IBOutlet weak var profilePic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.collectionViewLayout = CHTCollectionViewWaterfallLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        navigationController?.navigationBar.isHidden = true
        
        

        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        
        profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.layer.borderWidth = 4.0
        
        profileTabView.segmentsCornerRadius = 10.0
        profileFollowView.layer.cornerRadius = 10.0
        profileFollowView.clipsToBounds = true
//        
//        profileTabView.selectedTextFont = UIFont.systemFont(ofSize: 17,weight: .bold)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ImageArray[indexPath.row].size
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! iClickWaterfallCollectionViewCell
        cell.imageView.image = ImageArray[indexPath.row]
        return cell
    }
    
}
