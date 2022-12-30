//
//  NewPortfoiloImageCollectionViewCell.swift
//  TA
//
//  Created by Applify on 18/01/22.
//

import UIKit

class NewPortfoiloImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var portfolioImageView: UIImageView!
    
    var removeImageTapAction : (()->())?
    var selectedImageTapAction :(()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func tapDidCrossButtonAction(_ sender: UIButton) {
        removeImageTapAction?()
    }
    
}
