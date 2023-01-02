//
//  ImagesCollectionViewCell.swift
//  TA
//
//  Created by applify on 03/03/22.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var projectImage: UIImageView!
    var crossBtnClick: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteButtonAction(_ sender: UIButton) {
        self.crossBtnClick?()
    }
}
