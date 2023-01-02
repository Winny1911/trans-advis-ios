//
//  OrderListItemDetailTableViewCell.swift
//  TA
//
//  Created by Applify  on 21/02/22.
//

import UIKit

class OrderListItemDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var itemPriceLbl: UILabel!
    @IBOutlet weak var itemImageview: UIImageView!
    @IBOutlet weak var itemTittleLbl: UILabel!
    @IBOutlet weak var lblQnty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
