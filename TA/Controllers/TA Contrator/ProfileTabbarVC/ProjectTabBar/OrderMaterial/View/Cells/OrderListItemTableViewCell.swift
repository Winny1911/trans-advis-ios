//
//  OrderListItemTableViewCell.swift
//  TA
//
//  Created by Applify on 14/02/22.
//

import UIKit

class OrderListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var vwwQnty: UIView!
    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var itemImageview: UIImageView!
    @IBOutlet weak var itemTittleLbl: UILabel!
    @IBOutlet weak var itemQtyTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemQtyTextField.delegate = self
        self.vwwQnty.setRoundCorners(radius: 5.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
extension OrderListItemTableViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let dict = ["indx":self.tag, "quantityVal": itemQtyTextField.text ?? "1"] as [String : Any]
        NotificationCenter.default.post(name: Notification.Name("QuantityUpdated"), object: nil, userInfo: (dict as [AnyHashable : Any]))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == itemQtyTextField {
            if (textField.text?.isEmpty ?? true), string == "0" {
                return false
            } else if textField.text?.count ?? 0 > 9 && !string.isEmpty {
                return false
            }
        }
        
        return true
    }
}
