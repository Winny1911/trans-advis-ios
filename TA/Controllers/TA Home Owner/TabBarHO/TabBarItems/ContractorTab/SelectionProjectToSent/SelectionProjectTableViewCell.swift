//
//  SelectionProjectTableViewCell.swift
//  TA
//
//  Created by Dev on 23/12/21.
//

import UIKit

class SelectionProjectTableViewCell: UITableViewCell {
    var ckeckBtn  : (()-> ())?

    @IBOutlet weak var tittleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        checkButton.addTarget(self, action: #selector(checkUncheckButton), for: .touchUpInside)
    }
    
    @objc func checkUncheckButton(){
        ckeckBtn?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
