//
//  HistoryTableViewCell.swift
//  TA
//
//  Created by Applify on 11/01/22.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var refundText: UILabel!
    @IBOutlet weak var refundAmountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var assignLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        statusLabel.setRoundCorners(radius: statusLabel.layer.frame.height / 2)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
