//
//  MaterialCollectionViewCell.swift
//  TA
//
//  Created by Applify on 21/01/22.
//

import UIKit

class MaterialCollectionViewCell: UICollectionViewCell {

    // MARK: Outlet
    @IBOutlet weak var stckVwHt: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var materialImageView: UIImageView!
    @IBOutlet weak var materialName: UILabel!
    @IBOutlet weak var materialPrice: UILabel!
    @IBOutlet weak var addedToOrderbutton: UIButton!
    
    var addOrder : (()->())?
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addedToOrderbutton.addTarget(self, action: #selector(addOrderList), for: .touchUpInside)
        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = UIColor.lightGray.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainView.layer.shadowRadius = 3.0
        mainView.layer.shadowOpacity = 0.5
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.cornerRadius = 5.0
    }
    
    @objc func addOrderList(){
        self.addOrder?()
    }
}
