//
//  ExpandableTableViewCell.swift
//  test
//
//  Created by USER on 03/06/24.
//

import UIKit

class ExpandableTableViewCell: UITableViewCell {
    
    var expandedClick: (() -> (Void))!
    @IBOutlet var expandButton: UIButton!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var lblAnswer: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 

    @IBAction func onExpandedTapped(_ sender: UIButton) {
        expandedClick()
    }
}
