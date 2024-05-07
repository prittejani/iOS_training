//
//  CustomTableViewCell.swift
//  Webservices
//
//  Created by iMac on 01/04/24.
//

import UIKit
import AVFoundation

class ACustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lblPostDiscription: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var lblPostId: UILabel!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isVideoCell = false
   
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
