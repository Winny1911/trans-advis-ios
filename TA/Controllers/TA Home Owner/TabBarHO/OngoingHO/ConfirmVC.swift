//
//  ConfirmVC.swift
//  TA
//
//  Created by Dev on 29/12/21.
//

import UIKit

class ConfirmVC: BaseViewController {

    @IBOutlet weak var btnreject: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var bagroundVw: UIView!
    
    var approveDeliveryVM: ApproveDeliveryVM = ApproveDeliveryVM()
    var projectId = 0
    var isFrom = ""
    var callBackToFeedBackScreen : (()->())?
    var callBackToReject: (() -> ())?
    var rejectBid = false

    var completionHandlerGoToOngoingProjectList: (() -> Void)?
    var completionHandlerGoToFeedbackScreen: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.bagroundVw.roundCorners(corners: [.topLeft, .topRight], radius: 18.0)
    }
    
    @IBAction func tapDidRejectButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
        self.callBackToReject?()
//        var param = [String: Any]()
//        param = ["status": "\(0)",
//                 "projectId": "\(projectId)"
//                ]
//        self.approveDeliveryVM.approveDeliveryApiCall(param) { modal in
//            self.rejectBid = true
//            self.handleNavugation()
//        }
    }
    
    @IBAction func tapDidConfirmButtonAction(_ sender: UIButton) {
        if self.isFrom == "OngoingDetail" {
            self.handleNavugation()
        } else {
            var param = [String: Any]()
            param = ["status": "\(1)",
                     "projectId": "\(projectId)"
                    ]
            approveDeliveryVM.approveDeliveryApiCall(param) { modal in
                self.handleNavugation()
            }
        }
    }
    
    func handleReject() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleNavugation() {
        if self.isFrom == "OngoingDetail" {
            self.dismiss(animated: true, completion: nil)
           // self.completionHandlerGoToOngoingProjectList?()
            if self.rejectBid == true {
                
            } else {
                self.callBackToFeedBackScreen?()
            }
        } else {
            self.dismiss(animated: true, completion: nil)
            //self.completionHandlerGoToOngoingProjectList?()
            self.callBackToFeedBackScreen?()
        }
    }
}
