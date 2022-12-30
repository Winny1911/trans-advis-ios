//
//  EmptyTableViewCell.swift
//  Business App
//
//  Created by Ankit Goyal on 19/07/20.
//  Copyright © 2020 Ankit Goyal. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
