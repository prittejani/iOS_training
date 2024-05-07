//
//  resizingTableViewCell2.swift
//  Demo_1
//
//  Created by iMac on 06/05/24.
//

import UIKit

class resizingTableViewCell2: UITableViewCell {

    @IBOutlet weak var photo2: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var lblq: UILabel!
    
    @IBOutlet weak var lbls: UILabel!
    @IBOutlet weak var lblr: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
