//
//  resizingTableViewCell.swift
//  Demo_1
//
//  Created by iMac on 29/04/24.
//

import UIKit

class resizingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var lblTwo: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var lblThree: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
