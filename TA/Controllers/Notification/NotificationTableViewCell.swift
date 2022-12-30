//
//  NotificationTableViewCell.swift
//  TA
//
//  Created by applify on 25/02/22.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLbl.setRoundCorners(radius: 12.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
