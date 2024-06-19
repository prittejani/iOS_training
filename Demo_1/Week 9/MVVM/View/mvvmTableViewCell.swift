//
//  mvvmTableViewCell.swift
//  Demo_1
//
//  Created by USER on 05/06/24.
//

import UIKit

class mvvmTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblStatus: UILabel!
    
    var todo:mvvmViewModel!{
        didSet{
            self.lblTitle.text = todo.title
            self.lblStatus.text = todo.status
            self.lblStatus.textColor = todo.backColor
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
