//
//  CustomTableViewCell.swift
//  Demo_1
//
//  Created by iMac on 05/03/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var lblTask: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
