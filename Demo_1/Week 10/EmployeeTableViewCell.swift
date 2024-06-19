//
//  EmployeeTableViewCell.swift
//  Demo_1
//
//  Created by USER on 13/06/24.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {

    @IBOutlet var lblEmployeeName: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
