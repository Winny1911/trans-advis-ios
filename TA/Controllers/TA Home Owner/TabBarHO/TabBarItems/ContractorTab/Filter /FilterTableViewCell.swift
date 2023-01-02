//
//  FilterTableViewCell.swift
//  TA
//
//  Created by Designer on 21/12/21.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    

    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblFilter: UILabel!
    
    var btnTapAction : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        fiterOptionLabel.textAlignment = .left
//        checkButton.addTarget(self, action: #selector(setFilter), for: .touchUpInside)
    }
    
    @objc func setFilter(){
        btnTapAction?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
