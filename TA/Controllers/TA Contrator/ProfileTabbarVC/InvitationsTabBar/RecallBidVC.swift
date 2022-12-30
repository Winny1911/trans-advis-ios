//
//  RecallBidVC.swift
//  TA
//
//  Created by Applify  on 05/01/22.
//

import UIKit

class RecallBidVC: BaseViewController {

    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnNotYet: UIButton!
    @IBOutlet weak var recallView: UIView!
    
    var bidId = 0
    let manageBidDetailViewModel: ManageBidDetailViewModel = ManageBidDetailViewModel()
    var completionHandlerManageBids: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionNotYet(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        let params = ["bidId": "\(self.bidId)"]
        manageBidDetailViewModel.confirmRecallBidApi(params) { model in
            showMessage(with: SucessMessage.bidRecalledSuccessfully, theme: .success)
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerManageBids?()
        }
    }
}
