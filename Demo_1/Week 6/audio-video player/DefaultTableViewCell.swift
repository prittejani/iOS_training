//
//  DefaultTableViewCell.swift
//  Demo_1
//
//  Created by iMac on 11/04/24.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblAudioName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
