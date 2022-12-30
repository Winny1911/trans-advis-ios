//
//  RaiseADisputeVC.swift
//  TA
//
//  Created by Applify  on 22/02/22.
//

import UIKit
import GBFloatingTextField

class RaiseADisputeVC: BaseViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtVw: GBFloatingTextView!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var tblVwReasons: UITableView!
    
    var ongoingProejctsCOViewModel:OngoingProejctsCOViewModel = OngoingProejctsCOViewModel()
    var arrOfReasons = [String]()
    var selectedReson = ""
    var completionHandlerGoToOrderListing: (() -> Void)?
    var projectId = 0
    var subTaskId = 0
    var cartId = 0
    var price = Double(0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVwReasons.separatorColor = UIColor.clear
        self.tblVwReasons.register(UINib.init(nibName: "DisputeReasonsTblVwCell", bundle: nil), forCellReuseIdentifier: "DisputeReasonsTblVwCell")
        self.tblVwReasons.delegate = self
        self.tblVwReasons.dataSource = self
        fetchReasons()
    }
    
    func fetchReasons() {
        ongoingProejctsCOViewModel.getDisputeRasonsAPI(["userType":"CO"]) { [self] model in
            self.arrOfReasons.removeAll()
            self.arrOfReasons = model?.data?.allCarts ?? [String]()
            self.tblVwReasons.reloadData()
            self.tblVwReasons.layoutIfNeeded()
            self.tblVwHeight.constant = self.tblVwReasons.contentSize.height
        }
    }
    
    func submitDispute() {
        var params = [String:Any]()
        if self.subTaskId == 0 {
            params = [
                "projectId" : "\(self.projectId)",
                "cartId" : "\(self.cartId)",
                "amount" : "\(self.price)",
                "reason" : "\(self.selectedReson)",
                "Addcomment" : "\(self.txtVw.text ?? "")"
            ]
        } else {
            params = [
                "subtaskId" : "\(self.subTaskId)",
                "projectId" : "\(self.projectId)",
                "cartId" : "\(self.cartId)",
                "amount" : "\(self.price)",
                "reason" : "\(self.selectedReson)",
                "Addcomment" : "\(self.txtVw.text ?? "")"
            ]
        }
        ongoingProejctsCOViewModel.submitDisputeRasonsAPI(params) { [self] model in
            self.dismiss(animated: true, completion: nil)
            showMessage(with: "Raise a dispute: submitted successfully. \nThanks for submitting! Your dispute request has been successfully submitted. We’ll get back to you soon.", theme: .success)
            self.completionHandlerGoToOrderListing?()
        }
    }
    
    @IBAction func actionSubmit(_ sender: Any) {
        if self.selectedReson == "" {
            showMessage(with: "Please select reason", theme: .error)
        } else {
            submitDispute()
        }
    }
}

extension RaiseADisputeVC: UITableViewDelegate,UITableViewDataSource{

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.arrOfReasons.count
   }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisputeReasonsTblVwCell", for: indexPath) as! DisputeReasonsTblVwCell
        cell.lblTitle.text = self.arrOfReasons[indexPath.row]
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(actionCheck(sender:)), for: .touchUpInside)
        if self.selectedReson == self.arrOfReasons[indexPath.row] {
            cell.imgCheckBox.image = UIImage(named: "ic_checkbox_filled")
        } else {
            cell.imgCheckBox.image = UIImage(named: "ic_check_box")
        }
        return cell
    }
    
    @objc func actionCheck(sender: UIButton) {
        if self.selectedReson == self.arrOfReasons[sender.tag] {
            self.selectedReson = ""
        } else {
            self.selectedReson = ""
            self.selectedReson = self.arrOfReasons[sender.tag]
        }
        self.tblVwReasons.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
