//
//  iClickWaterfallCollectionViewCell.swift
//  Demo_1
//
//  Created by iMac on 22/05/24.
//

import UIKit

class iClickWaterfallCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var CView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    static let identifier = "cell"
    
    override func awakeFromNib() {
        imageView.contentMode = .scaleAspectFill
        CView.layer.cornerRadius = 10.0
        CView.clipsToBounds = true
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CView.bounds
    }
    
    
}
