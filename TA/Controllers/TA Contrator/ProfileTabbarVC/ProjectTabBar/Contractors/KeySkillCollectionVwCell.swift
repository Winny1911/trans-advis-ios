//
//  KeySkillCollectionVwCell.swift
//  TA
//
//  Created by applify on 21/01/22.
//

import UIKit

class KeySkillCollectionVwCell: UICollectionViewCell {

    @IBOutlet weak var bgVw: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgVw.setRoundCorners(radius: 4)
    }

}
