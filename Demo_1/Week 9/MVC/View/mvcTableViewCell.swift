//
//  mvcTableViewCell.swift
//  Demo_1
//
//  Created by USER on 05/06/24.
//

import UIKit

class mvcTableViewCell: UITableViewCell {

    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
