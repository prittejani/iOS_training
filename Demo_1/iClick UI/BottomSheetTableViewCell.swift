//
//  BottomSheetTableViewCell.swift
//  Demo_1
//
//  Created by iMac on 23/05/24.
//

import UIKit

class BottomSheetTableViewCell: UITableViewCell {

    @IBOutlet weak var settingSwitch: UISwitch!
    @IBOutlet weak var lblSettingName: UILabel!
    @IBOutlet weak var cellBackView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackView.layer.cornerRadius = 10.0
        cellBackView.clipsToBounds = true
        changeSwitch()
    }

    func changeSwitch(){
        if settingSwitch.isOn{
            settingSwitch.onTintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
            lblSettingName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            lblSettingName.textColor = .black
        }else{
            lblSettingName.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            lblSettingName.textColor = .systemGray2
        }
    }
    
    @IBAction func changeSwitchValue(_ sender: UISwitch) {
        if settingSwitch.isOn{
            settingSwitch.onTintColor = UIColor(red: 136/255, green: 139/255, blue: 244/255, alpha: 1)
            lblSettingName.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            lblSettingName.textColor = .black
        }else{
            lblSettingName.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            lblSettingName.textColor = .systemGray2
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
