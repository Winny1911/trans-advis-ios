//
//  NewHOTableViewCell.swift
//  TA
//
//  Created by Dev on 09/12/21.
//

import UIKit

class NewHOTableViewCell: UITableViewCell {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgProject: UIImageView!
    @IBOutlet weak var descriptionHOLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProject.setRoundCorners(radius: 5.0)
        backGroundView.layer.masksToBounds = false
        backGroundView.layer.shadowColor = UIColor.lightGray.cgColor
        backGroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backGroundView.layer.shadowRadius = 5.0
        backGroundView.layer.shadowOpacity = 0.5
        backGroundView.layer.shadowOffset = CGSize.zero
        backGroundView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
