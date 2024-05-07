//
//  CustomTableViewCell.swift
//  sql
//
//  Created by iMac on 28/02/24.
//

import UIKit

class CustomSQLTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
