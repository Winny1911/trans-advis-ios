//
//  InvitationsTableViewCell.swift
//  TA
//
//  Created by Applify  on 21/12/21.
//

import UIKit

class InvitationsTableViewCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var viewDesc: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgInvitation: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewDesc.setRoundCorners(radius: 5.0)
        imgInvitation.setRoundCorners(radius: 5.0)
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
