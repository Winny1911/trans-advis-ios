//
//  RejectTableVwCell.swift
//  TA
//
//  Created by applify on 05/01/22.
//

import UIKit

class RejectTableVwCell: UITableViewCell {

    @IBOutlet weak var reasonLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    var checkRejectBidBtn : (()-> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkBtn.addTarget(self, action: #selector(checkBtnTap), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @objc func checkBtnTap(){
        checkRejectBidBtn?()
    }

    @IBAction func checkButtonAction(_ sender: Any) {
        
    }
}
