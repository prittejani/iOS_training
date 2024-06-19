//
//  CollectionViewTableViewCell.swift
//  test
//
//  Created by USER on 31/05/24.
//

import UIKit
class Week9DiscoveryCategoryCustomFlow : UICollectionViewFlowLayout{

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
class CollectionViewTableViewCell: UITableViewCell {

   
    
    @IBOutlet var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
       collectionView.collectionViewLayout = Week9DiscoveryCategoryCustomFlow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension CollectionViewTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TableviewCollectionViewCell
        cell.lblCellNo.text = "\(indexPath.row)"
        return cell
    }
}
