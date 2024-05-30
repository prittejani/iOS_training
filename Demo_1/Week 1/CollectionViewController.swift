//
//  CollectionViewController.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit
class CustomFlow : UICollectionViewFlowLayout{

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
class CollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

   

    @IBOutlet weak var collectionView: UICollectionView!
    var array = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomFlow()
        array = ["r1","r2","r3","r4","r5","r6","r7","r8","r15","r14","r3","r12","r11","r10","r9","r1","r2","r3","r4","r5","r6","r7","r8","r15","r14","r3","r12","r11","r10","r9"]
   
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.imageView.image = UIImage(named: array[indexPath.row])
//        cell.CVview.layer.cornerRadius = 25.0
//        cell.CVview.clipsToBounds = true
        cell.imageView.layer.cornerRadius = 20.0
        cell.imageView.clipsToBounds = true
        cell.CVview.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SubCollectionViewController") as! SubCollectionViewController
        vc.image = UIImage(named: array[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }

}
