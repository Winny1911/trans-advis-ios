//
//  SubTaskOrderListCO.swift
//  TA
//
//  Created by Applify on 07/02/22.
//

import UIKit

class SubTaskOrderListCO: UITableViewCell {

    @IBOutlet weak var btnStack: UIStackView!
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
