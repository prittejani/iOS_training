//
//  DiscoverTableViewCell.swift
//  Demo_1
//
//  Created by iMac on 21/05/24.
//

import UIKit
class DiscoveryCategoryCustomFlow : UICollectionViewFlowLayout{

    override func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            let itemWidth = collectionView.bounds.width
            _ = itemWidth
            
            itemSize = CGSize(width: collectionView.bounds.width / 2.1, height: collectionView.bounds.width/2.5)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .horizontal
        }
    }
}
class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = DiscoveryCategoryCustomFlow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DiscoverTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
        return discoverArray[section].image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DiscoverCollectionViewCell
        cell.images.image = discoverArray[collectionView.tag].image[indexPath.row]
        cell.lblInfo.text = discoverArray[collectionView.tag].info[indexPath.row]
        return cell
    }
    
    
}
