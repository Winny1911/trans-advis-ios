//
//  OrderListTableviewCell.swift
//  TA
//
//  Created by Designer on 13/12/21.
//

import UIKit

class OrderListTableviewCell: UITableViewCell {

    @IBOutlet weak var declineButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var acceptOrder: UIButton!
    
    @IBOutlet weak var lineview: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        declineButton.layer.borderColor = (UIColor( red: 78/255, green: 199/255, blue:41/255, alpha: 1.0 )).cgColor
        declineButton.layer.borderWidth = 1.5
        cardView.addCustomShadow()
        
//        cardView.layer.masksToBounds = false
//        cardView.layer.shadowColor = UIColor.lightGray.cgColor
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        cardView.layer.shadowRadius = 5.0
//        cardView.layer.shadowOpacity = 0.5
//        cardView.layer.shadowOffset = CGSize.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
