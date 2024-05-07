//
//  CustomTableViewCell.swift
//  FileManager
//
//  Created by iMac on 01/03/24.
//

import UIKit

class CustomFileManagerTableViewCell: UITableViewCell {

    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
