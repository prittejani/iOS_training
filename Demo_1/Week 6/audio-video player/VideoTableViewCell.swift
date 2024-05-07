//
//  VideoTableViewCell.swift
//  Demo_1
//
//  Created by iMac on 23/04/24.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblVideoName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
