//
//  AutoresizingTableViewCell.swift
//  Demo_1
//
//  Created by iMac on 29/04/24.
//

import UIKit


class AutoresizingTableViewCell: UITableViewCell {

  @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var lblThree: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var lblOne: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
