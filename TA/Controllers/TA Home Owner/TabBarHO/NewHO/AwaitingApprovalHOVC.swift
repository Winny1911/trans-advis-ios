//
//  AwaitingApprovalHOVC.swift
//  TA
//
//  Created by Roberto Veiga Junior on 26/04/23.
//

import UIKit

class AwaitingApprovalHOVC: BaseViewController {
    
    @IBOutlet weak var bodyMessageApproval: UILabel!
    @IBOutlet weak var btnEmailTA: UIButton!
    @IBOutlet weak var bodyMessageApprovalSeccond: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillUpMessageApproval()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func fillUpMessageApproval() {
        let message = "Your team at Transaction Advidor reviewing your project. You will be notified upon approval."
        let messageSeccond = "For any inquires please contact us at"
        self.bodyMessageApproval.text = message
        self.bodyMessageApprovalSeccond.text = messageSeccond
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
