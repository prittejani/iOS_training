//
//  GalleryViewViewController.swift
//  test
//
//  Created by USER on 31/05/24.
//

import UIKit
import Photos



class Week9CCustomFlow : UICollectionViewFlowLayout{
 
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
var week9imageArray = [UIImage]()
class GalleryViewViewController: UIViewController {
 
    var images = [PHAsset]()
    var currentBatchIndex = 0

    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = Week9CCustomFlow()
        populatePhotos()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        title = "Gallery View"
    }
    func populatePhotos(){
        PHPhotoLibrary.requestAuthorization { status in
            
            switch status{
            case .authorized:
                self.fetchPhotoes()
                print("access apporove")
            case .restricted,.denied,.limited,.notDetermined:
                print("not access")
            @unknown default:
                break
            }
            
        }
    }
    func fetchPhotoes(){
        week9imageArray = []
        
        DispatchQueue.global(qos: .background).async {
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            print(fetchResult.count)
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    self.currentBatchIndex += 1
                    imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFill, options: requestOptions) { (image, error) in
                        if let image = image {
                            week9imageArray.append(image)
                        }
                        if self.currentBatchIndex % 20 == 0 {
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            } else {
                print("You got no photos.")
            }
            
            print("imageArray count: \(week9imageArray.count)")
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    
}
extension GalleryViewViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return week9imageArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelectPhotoCell
    
        cell.imagePicture.image = week9imageArray[indexPath.row]

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = week9.instantiateViewController(withIdentifier: "ImageInViewController") as! ImageInViewController
        vc.imgIndex = indexPath.row
    
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


