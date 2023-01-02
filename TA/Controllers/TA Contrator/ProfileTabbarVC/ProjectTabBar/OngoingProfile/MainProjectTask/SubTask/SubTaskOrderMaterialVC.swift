//
//  SubTaskOrderMaterialVC.swift
//  TA
//
//  Created by applify on 02/02/22.
//

import UIKit

class SubTaskOrderMaterialVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var categoryTxtField: FloatingLabelInput!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTxtField.setRightPaddingIconLocation(icon: UIImage(named: "ic_down")!)
       // bgView.roundCorners(corners: [.topLeft, .topRight ] ,radius: 16.0)

       
    }
}
