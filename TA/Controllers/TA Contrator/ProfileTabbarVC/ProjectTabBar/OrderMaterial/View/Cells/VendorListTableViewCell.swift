//
//  VendorListTableViewCell.swift
//  TA
//
//  Created by Dev on 03/02/22.
//

import UIKit

class VendorListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnViewProfile: UIButton!
    @IBOutlet weak var btnViewProducts: UIButton!
    @IBOutlet weak var ccontainerView: UIView!
    @IBOutlet weak var lblProjectsCompleted: UILabel!
    @IBOutlet weak var vendorImage: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
   
    var viewProduct:((_ tapped: Bool)->())?
    var btnTapAction : (()->())?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        vendorImage.setRoundCorners(radius: vendorImage.frame.height / 2)
        ccontainerView.addCustomShadow()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
