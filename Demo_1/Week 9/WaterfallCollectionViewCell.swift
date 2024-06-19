//
//  WaterfallCollectionViewCell.swift
//  test
//
//  Created by USER on 31/05/24.
//

import UIKit

class WaterfallCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 10.0
    }
}
