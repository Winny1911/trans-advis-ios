//
//  PastProjectHOTableViewCell.swift
//  TA
//
//  Created by Applify on 28/02/22.
//

import UIKit

class PastProjectHOTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var pastTitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = UIColor.lightGray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainView.layer.shadowRadius = 3.0
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize.zero
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
