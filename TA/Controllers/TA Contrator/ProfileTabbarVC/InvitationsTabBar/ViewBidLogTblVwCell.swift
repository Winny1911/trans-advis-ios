//
//  ViewBidLogTblVwCell.swift
//  TA
//
//  Created by Applify  on 05/01/22.
//

import UIKit

class ViewBidLogTblVwCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var innerVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
