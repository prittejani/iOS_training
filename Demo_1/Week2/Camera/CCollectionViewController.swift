//
//  CollectionViewController.swift
//  Camera
//
//  Created by iMac on 08/03/24.
//

import UIKit
class CCustomFlow : UICollectionViewFlowLayout{
    override func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            let itemWidth = collectionView.bounds.width / 3
            _ = itemWidth
            
            itemSize = CGSize(width: itemWidth, height: itemWidth)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .vertical
        }
    }
}

class CCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var image:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CCustomFlow()
    }

}
extension CCollectionViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LargeImageViewController") as! LargeImageViewController
        vc.image = imageArray[indexPath.row]
        vc.getCurrentIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CCustomCollectionViewCell
        cell.imageView.image = UIImage(data: imageArray[indexPath.row])
        return cell
       
    }
}
