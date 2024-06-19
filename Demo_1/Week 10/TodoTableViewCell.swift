//
//  TodoTableViewCell.swift
//  Demo_1
//
//  Created by USER on 14/06/24.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet var doneDate: UILabel!
    @IBOutlet var createDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var statusImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
