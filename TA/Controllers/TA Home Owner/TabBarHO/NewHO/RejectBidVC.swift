//
//  rejectBidVC.swift
//  TA
//
//  Created by applify on 05/01/22.
//

import UIKit

class RejectBidVC: BaseViewController {

    @IBOutlet weak var reasonRejectLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmRejection: UIButton!
    
    var reasonArray = ["The bid is under/over budget","Manpower unavailability","The bid doesn’t follow the specifications","Supporting files not provided"]
    
    var reasonOngoingArray = ["The project was delayed by the Contractor","Incomplete project delivered by Contractor","Few items were broken at the time of delivery","Other"]
    
    var approveDeliveryVM: ApproveDeliveryVM = ApproveDeliveryVM()
    var viewModel : RejectBidVM = RejectBidVM()
    var projectId = Int()
    var bidId = Int()
    var rejectedBidValue = ""
    var rejectIndexValue = -1
    var completionHandlerGoToViewBids : (() -> Void)?
    var isFrom = ""
    var isOther = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFrom == "OngoingHo" {
            self.reasonRejectLabel.text = "Reason to Reject the Project?"
        } else {
            self.reasonRejectLabel.text = "Reason to Reject the Bid?"
        }
        self.otherTextField.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        confirmRejection.setRoundCorners(radius: 6.0)
        bgView.setRoundCorners(radius: 18.0)
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
         if let obj = object as? UITableView {
             if obj == self.tableView && keyPath == "contentSize" {
                 if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
                     //do stuff here
//                     self.ReviewDataReload?()
                     self.reloadData()
                 }
             }
         }
     }
    
    func reloadData() {
        self.tableView.layoutIfNeeded()
        self.tableViewHeight.constant = self.tableView.contentSize.height == 0 ? 30 : self.tableView.contentSize.height
    }
    
    func ongoingHoReject() {
        var param = [String: Any]()
        if isOther == true {
            param = ["status": "\(0)",
                     "projectId": "\(projectId)",
                     "rejectedDeliveryReason" : otherTextField.text as Any
            ]
        } else {
            param = ["status": "\(0)",
                     "projectId": "\(projectId)",
                     "rejectedDeliveryReason" : rejectedBidValue
            ]
        }
        if isOther == true {
            if otherTextField.text == "" {
                showMessage(with: "Please Enter Reason")
            } else {
                self.approveDeliveryVM.approveDeliveryApiCall(param) { modal in
                    self.dismiss(animated: true, completion: nil)
                    self.completionHandlerGoToViewBids?()
                }
            }
        } else {
            if rejectedBidValue == "" {
                showMessage(with: "Please Select Reason")
            } else {
                self.approveDeliveryVM.approveDeliveryApiCall(param) { modal in
                    self.dismiss(animated: true, completion: nil)
                    self.completionHandlerGoToViewBids?()
                }
            }
        }
        
    }
    
    func rejectBidApiHit(){
        let params = ["projectId":"\(self.projectId)","bidId": "\(self.bidId)", "status": "0", "reason": rejectedBidValue ] as [String : Any]
        print(params)
        self.viewModel.rejectOrAcceptBidApiCall(params){ model in
            showMessage(with: SucessMessage.bidRejectedSuccessfully, theme: .success)
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToViewBids?()
        }
    }
 
    func rejectBidInvitedApiHit(){
        let params = ["projectId":"\(self.projectId)","bidId": "\(self.bidId)", "status": "0", "reason": rejectedBidValue ] as [String : Any]
        self.viewModel.rejectOrAcceptInvitedBidApiCall(params){ model in
            showMessage(with: SucessMessage.bidRejectedSuccessfully, theme: .success)
            self.dismiss(animated: true, completion: nil)
            self.completionHandlerGoToViewBids?()
        }
    }
    
    @IBAction func confirmRejectionBtnAction(_ sender: Any) {
        if self.isFrom == "OngoingHo" {
            self.ongoingHoReject()
        } else if self.isFrom == "InvitedTaskCO" {
            rejectBidInvitedApiHit()
        } else {
            rejectBidApiHit()
        }
    }
}

extension RejectBidVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFrom == "OngoingHo" {
            return reasonOngoingArray.count
        } else {
            return reasonArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RejectTableVwCell", for: indexPath) as? RejectTableVwCell
        {
            if isFrom == "OngoingHo" {
                cell.reasonLbl.text = reasonOngoingArray[indexPath.row]
                cell.checkBtn.tag = indexPath.row
                
                cell.checkBtn.addTarget(self, action: #selector(rejectBidOngoing(sender:)), for: .touchUpInside)
                if self.rejectIndexValue == indexPath.row {
                    self.rejectedBidValue = reasonOngoingArray[indexPath.row]
                    cell.checkBtn.setImage(UIImage(named: "ic_checkbox_filled"), for: .normal)
                } else {
                    cell.checkBtn.setImage(UIImage(named: "ic_check_box"), for: .normal)
                }
            } else {
                cell.reasonLbl.text = reasonArray[indexPath.row]
                cell.checkBtn.tag = indexPath.row
                
                cell.checkBtn.addTarget(self, action: #selector(rejectBid(sender:)), for: .touchUpInside)
                if self.rejectIndexValue == indexPath.row {
                    self.rejectedBidValue = reasonArray[indexPath.row]
                    cell.checkBtn.setImage(UIImage(named: "ic_checkbox_filled"), for: .normal)
                } else {
                    cell.checkBtn.setImage(UIImage(named: "ic_check_box"), for: .normal)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func rejectBidOngoing(sender:UIButton) {
        if sender.tag == 3 {
            self.rejectIndexValue = sender.tag
            self.otherTextField.isHidden = false
            self.isOther = true
        } else {
            self.otherTextField.isHidden = true
            self.rejectIndexValue = sender.tag
            self.isOther = false
        }
        self.reloadData()
        self.tableView.reloadData()
    }
    
    @objc func rejectBid(sender:UIButton) {
        self.reloadData()
        self.rejectIndexValue = sender.tag
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


