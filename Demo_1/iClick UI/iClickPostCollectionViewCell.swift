//
//  iClickPostCollectionViewCell.swift
//  Demo_1
//
//  Created by iMac on 21/05/24.
//

import UIKit

class iClickPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var PostView: UIView!
    
    @IBOutlet weak var PostProfileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPost()
    }
    func setupPost(){
        PostProfileImage.layer.cornerRadius = PostProfileImage.frame.size.width/2
        PostProfileImage.clipsToBounds = true
        
        PostView.layer.cornerRadius = 10.0
        PostView.clipsToBounds = true
    }
}
