//
//  WaterfallLayoutViewController.swift
//  test
//
//  Created by USER on 31/05/24.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class WaterfallLayoutViewController: UIViewController {

    var waterImage:[UIImage] = [
        UIImage(named: "w1")!,UIImage(named: "w2")!,UIImage(named: "w3")!,UIImage(named: "w4")!,UIImage(named: "r5")!,UIImage(named: "r6")!,
        UIImage(named: "r7")!,UIImage(named: "r8")!,UIImage(named: "r9")!,UIImage(named: "r10")!,UIImage(named: "r11")!,UIImage(named: "r12")!
    ]
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Waterfall Layout"
        
        collectionView.collectionViewLayout = CHTCollectionViewWaterfallLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        let layout = CHTCollectionViewWaterfallLayout()
        layout.itemRenderDirection = .leftToRight
        layout.columnCount = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
  
    }

}
extension WaterfallLayoutViewController:UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout{
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return waterImage[indexPath.row].size
            
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WaterfallCollectionViewCell
        cell.imageView.image = waterImage[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return waterImage.count
    }
    
}
