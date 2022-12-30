//
//  AddTaskTblVwCell.swift
//  TA
//
//  Created by Applify  on 07/02/22.
//

import UIKit

class AddTaskTblVwCell: UITableViewCell {
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var outerVw: UIView!
    @IBOutlet weak var deliverablesTextField: FloatingLabelInput!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deliverablesTextField.delegate = self
        outerVw.setRoundCorners(radius: 4.0)
        deliverablesTextField.setLeftPadding(14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension AddTaskTblVwCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == deliverablesTextField{
            let vc = Controllers.addNewTaskVC
            let fullStr = "\(self.deliverablesTextField.text!)" + "\(string)"
            vc?.arrDeliverablesValue[btnDelete.tag] = fullStr
            print("########\(vc?.arrDeliverablesValue as Any)")
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let vc = Controllers.addNewTaskVC
        let fullStr = "\(self.deliverablesTextField.text!)"
        vc?.arrDeliverablesValue[btnDelete.tag] = fullStr
    }
}
