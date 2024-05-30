//
//  ActivityTableViewCell.swift
//  Demo_1
//
//  Created by iMac on 23/05/24.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var lblLikedOrAdded: UILabel!
    @IBOutlet weak var likeIcon: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backview.layer.cornerRadius = 10.0
        
        likeIcon.layer.cornerRadius = lblLikedOrAdded.frame.size.height/2
        likeIcon.clipsToBounds = true
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.height/2
        userProfileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
