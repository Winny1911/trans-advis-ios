//
//  ViewBidsTableVwCell.swift
//  TA
//
//  Created by applify on 05/01/22.
//

import UIKit

class ViewBidsTableVwCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var bidAmountLbl: UILabel!
    @IBOutlet weak var viewBidsButtonAction: UIButton!
    @IBOutlet weak var bgVw: UIView!
    var viewBidsTapAction : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgVw.addCustomShadow()
        viewBidsButtonAction.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
    }
    
    // MARK: for clourse call
    @objc func btnTapped() {
        print("Tapped!")
        // use our "call back" action to tell the controller the button was tapped
        viewBidsTapAction?()
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
