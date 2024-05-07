//
//  VideoCollectionViewController.swift
//  Camera
//
//  Created by iMac on 11/03/24.
//

import UIKit


class VideoCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = CustomFlow()
        print(cvideoArray)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(cvideoArray)
    }
}
extension VideoCollectionViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PlayVideoViewController") as! PlayVideoViewController
        let videoUrl = cvideoArray[indexPath.row]
        vc.videourl = videoUrl
        vc.getCurrentIndex = indexPath.row
        print(videoUrl)
            //            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main){ [self]_ in
//                player.seek(to: CMTime.zero)
//            }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cvideoImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! VideoCollectionViewCell
        cell.imageView.transform = cell.imageView.transform.rotated(by: .pi/2)
        cell.imageView.image = UIImage(data: cvideoImage[indexPath.row])
        
        return cell
        
    }
}
