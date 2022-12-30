//
//  SettingTableViewCell.swift
//  TA
//
//  Created by Designer on 31/12/21.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    // MARK: Outlet
    
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingImageView: UIImageView!
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        settingButton.isHidden = true
        self.settingButton.tintColor = tintColor
        self.settingButton.imageView?.tintColor = tintColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
