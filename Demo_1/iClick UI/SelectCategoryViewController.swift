//
//  SelectCategoryViewController.swift
//  Demo_1
//
//  Created by iMac on 20/05/24.
//

import UIKit
class CategoryCustomFlow : UICollectionViewFlowLayout{

    override func prepare() {
        super.prepare()
        if let collectionView = collectionView {
            let itemWidth = collectionView.bounds.width
            _ = itemWidth
            
            itemSize = CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.width / 3)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .vertical
        }
    }
}
class SelectCategoryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var exploreButton: UIButton!
    var categoryImageArray = ["card1","card2","card3","card4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CategoryCustomFlow()
        exploreButton.layer.cornerRadius = exploreButton.frame.size.height/2
        exploreButton.clipsToBounds  = true
    }
    
}
extension SelectCategoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2.15, height: collectionView.bounds.height/2.3)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectCategoryCollectionViewCell
        cell.categoryImage.image = UIImage(named: categoryImageArray[indexPath.row])
        return cell
    }
}

extension UIViewController{
    func applyGradientToLabel(label: UILabel,firstColor:CGColor,secondColor:CGColor) {

        let gradientColors: [CGColor] = [firstColor,secondColor]
        
     
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = label.bounds
    
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        label.textColor = UIColor(patternImage: gradientImage!)
    }
}
