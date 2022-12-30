//
//  SubTaskOrderListCO.swift
//  TA
//
//  Created by Applify on 07/02/22.
//

import UIKit

class OrderListItemTbllVwCell: UITableViewCell {

    @IBOutlet weak var disputeAdminView: UIView!
    @IBOutlet weak var disputeStatusText: UILabel!
    @IBOutlet weak var disputeLabel: UILabel!
    @IBOutlet weak var vendorStatusLabel: UILabel!
    @IBOutlet weak var vendorView: UIView!
    @IBOutlet weak var disputesStackView: UIStackView!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnStckVw: UIStackView!
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var venderName: UILabel!
    @IBOutlet weak var itemLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var PriceLbl: UILabel!
    @IBOutlet weak var orderByLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnCancel.borderColor = UIColor.appBtnColorOrange
        self.btnCancel.border = 1.0
        self.btnCancel.setRoundCorners(radius: 10.0)
        self.btnCancel.backgroundColor = UIColor.white
        self.btnCancel.setTitleColor(UIColor.appBtnColorOrange, for: .normal)
        
        self.vwStatus.setRoundCorners(radius: self.vwStatus.frame.height / 2)
        vwStatus.setRoundCorners(radius: vwStatus.frame.height / 2)
        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = UIColor.lightGray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainView.layer.shadowRadius = 5.0
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize.zero
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
