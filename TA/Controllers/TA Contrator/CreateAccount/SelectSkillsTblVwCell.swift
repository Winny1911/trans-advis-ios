//
//  SelectSkillsTblVwCell.swift
//  TA
//
//  Created by Applify  on 14/12/21.
//

import UIKit

class SelectSkillsTblVwCell: UITableViewCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblTile: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectBtn.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
