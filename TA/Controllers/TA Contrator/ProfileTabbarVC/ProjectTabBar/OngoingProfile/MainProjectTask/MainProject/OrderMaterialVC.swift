//
//  ViewMaterialVC.swift
//  TA
//
//  Created by Designer on 14/12/21.
//

import UIKit

class OrderMaterialVC: BaseViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var categoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTextField.setRightPaddingIcon(icon: UIImage(named: "ic_down")!)
        
        bottomView.layer.masksToBounds = false
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bottomView.layer.shadowRadius = 5.0
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowOffset = CGSize.zero
        bottomView.layer.cornerRadius = 5.0
    }
}
