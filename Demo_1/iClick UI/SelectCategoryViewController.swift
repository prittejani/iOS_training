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
            
            itemSize = CGSize(width: collectionView.bounds.width / 2, height: collectionView.bounds.height / 3)
            minimumLineSpacing = 0
            minimumInteritemSpacing = 0
            scrollDirection = .vertical
        }
    }
}
class SelectCategoryViewController: UIViewController {

    @IBOutlet var lblShare_inspire_connect: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet var lblWhoareyou: UILabel!
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet var stackViewBottom: NSLayoutConstraint!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var ExploreButton: UIButton!
    var categoryImageArray = ["card1","card2","card3","card4"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CategoryCustomFlow()
        ExploreButton.layer.cornerRadius = ExploreButton.frame.size.height/2
        ExploreButton.clipsToBounds  = true
        
        let gradientImage = UIImage.gradientImageWithBounds(bounds: lblShare_inspire_connect.bounds, colors: [UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1).cgColor, UIColor(red: 81/255, green: 81/255, blue: 198/255, alpha: 1).cgColor])
        
        lblShare_inspire_connect.textColor = UIColor.init(patternImage: gradientImage)
    }
    
    @IBAction func onExploreClicked(_ sender: Any) {
        let vc  = iClick.instantiateViewController(withIdentifier: "smitViewController") as! NotchTabbarViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [self] _ in
            if UIDevice.current.orientation.isLandscape {
                
                print("landscape")
                NSLayoutConstraint.deactivate(self.view.constraints.filter { $0.firstItem === self.ExploreButton && $0.firstAttribute == .height })
                NSLayoutConstraint.activate([
                    self.collectionView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.686599),
                    self.lblWhoareyou.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.079323),
                    self.ExploreButton.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.0640845)
                ])
            
            } else {
                print("portrait")
                
                NSLayoutConstraint.deactivate(self.view.constraints.filter { $0.firstItem === self.ExploreButton && $0.firstAttribute == .height })
                NSLayoutConstraint.activate([
                    self.collectionView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.786599),
                    self.lblWhoareyou.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.059323),
                    self.ExploreButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.0705739)
                ])
             
            }

            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }

}
extension SelectCategoryViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2.12, height: collectionView.bounds.height/2.15)
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
