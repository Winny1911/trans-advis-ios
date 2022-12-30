//
//  ProjectTypeTableViewCellHO.swift
//  TA
//
//  Created by Dev on 13/12/21.
//

import UIKit

class DisputeReasonsTblVwCell: UITableViewCell {

    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
