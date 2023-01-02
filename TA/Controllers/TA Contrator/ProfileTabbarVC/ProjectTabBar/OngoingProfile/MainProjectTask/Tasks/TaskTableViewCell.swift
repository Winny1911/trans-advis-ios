//
//  MainProjectTableViewCell.swift
//  TA
//
//  Created by Designer on 13/12/21.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var tastTitleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteTaskTapAction: (()->())?
    
    override func awakeFromNib() {
        deleteButton.addTarget(self, action: #selector(btnTap), for: .touchUpInside)
        super.awakeFromNib()
    }
    
    // MARK: for clourse call
    @objc func btnTap() {
        print("Tapped!")
        // use our "call back" action to tell the controller the button was tapped
        deleteTaskTapAction?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
