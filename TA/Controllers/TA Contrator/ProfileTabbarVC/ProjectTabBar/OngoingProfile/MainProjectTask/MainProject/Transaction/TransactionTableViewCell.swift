//
//  TransactionTableViewCell.swift
//  TA
//
//  Created by Designer on 15/12/21.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var breakUpView: UIView!
    @IBOutlet weak var profitAmount: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        profitAmount.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .leftToRight ? .forceLeftToRight : .forceRightToLeft
        profitAmount.titleLabel?.font = UIFont(name: "Poppins", size: 14)
        
        breakUpView.layer.borderColor = UIColor(hex: "#FA9365")?.cgColor
        breakUpView.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
