//
//  AddFilesTblVwCell.swift
//  TA
//
//  Created by Applify  on 03/01/22.
//

import UIKit

class AddFilesTblVwCell: UITableViewCell {
    
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imageFile: UIImageView!
    @IBOutlet weak var innerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        innerView.addCustomShadow()
        innerView.setRoundCorners(radius: 5.0)
        imageFile.setRoundCorners(radius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
