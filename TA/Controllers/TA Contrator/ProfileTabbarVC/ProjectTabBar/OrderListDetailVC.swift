//
//  OrderListDetailVC.swift
//  TA
//
//  Created by Applify  on 21/02/22.
//

import UIKit

class OrderListDetailVC: BaseViewController {
    
    @IBOutlet weak var disputeLabel: UILabel!
    @IBOutlet weak var disputeView: UIView!
    @IBOutlet weak var refundAmountText: UILabel!
    @IBOutlet weak var refundAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var vendorStatusLabel: UILabel!
    @IBOutlet weak var vendorStatusView: UIView!
    @IBOutlet weak var tblVwHeight: NSLayoutConstraint!
    @IBOutlet weak var btnComplete: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnStckVw: UIStackView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblVendorname: UILabel!
    @IBOutlet weak var tblVwOrder: UITableView!
    @IBOutlet weak var lblTop: UILabel!

    var isFrom = ""
    var orderListItem : OrderListResponseModelDetails?
    var orderListItems : OrderListDetailsData?
    var ongoingProejctsCOViewModel:OngoingProejctsCOViewModel = OngoingProejctsCOViewModel()
    var projectId = 0
    var subTaskId = 0
    var cardId = 0
    var isNotification = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.disputeView.isHidden = true
        self.disputeLabel.isHidden = true
        self.vendorStatusView.isHidden = true
        self.btnStckVw.isHidden = true
        self.vwStatus.setRoundCorners(radius: self.vwStatus.frame.height / 2)
        self.vendorStatusView.setRoundCorners(radius: self.vendorStatusView.frame.height / 2)
        self.disputeView.setRoundCorners(radius: self.disputeView.frame.height / 2)
        self.tblVwOrder.separatorColor = UIColor.clear
        self.tblVwOrder.register(UINib.init(nibName: "OrderListItemDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderListItemDetailTableViewCell")
        self.tblVwOrder.delegate = self
        self.tblVwOrder.dataSource = self
        self.btnCancel.borderColor = UIColor.appBtnColorOrange
        self.btnCancel.border = 1.0
        self.btnCancel.setRoundCorners(radius: 10.0)
        self.btnCancel.backgroundColor = UIColor.white
        self.btnCancel.setTitleColor(UIColor.appBtnColorOrange, for: .normal)
//        setDetails()
        if isNotification == false {
            self.cardId = self.orderListItem?.id ?? 0
            self.projectId = self.orderListItem?.projectId ?? 0
        }
        self.getDetailsApi()
    }
    
    func getDetailsApi() {
        let param = ["projectId": projectId, "cartId": cardId]
        ongoingProejctsCOViewModel.getOrderListDetailsApiCall(param) { model in
            self.orderListItem = model?.data
            self.setDetails()
            self.tblVwOrder.reloadData()
        }
    }
    
    func setDetails() {
        self.tblVwHeight.constant = (Double(self.orderListItem?.Cart_Item?.count ?? 0) * Double(100.0))
        self.lblVendorname.text = "\(self.orderListItem?.vendor_detail?.firstName ?? "") \(self.orderListItem?.vendor_detail?.lastName ?? "")"
        self.lblCategory.text = self.orderListItem?.Cart_Item?[0].productsss?.category ?? ""
        self.lblAmount.text = "$\(self.orderListItem?.TotalPrice ?? Double(0.0))"
        self.totalAmountLabel.text = "$\(self.orderListItem?.TotalPrice ?? Double(0.0))"
        self.lblDate.text = DateHelper.convertDateString(dateString: "\(self.orderListItem?.createdAt ?? "2024-04-08T00:00:00.000Z")", fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormat: "dd MMM yyyy")
        self.lblTop.text = "Order Item List (\("\(self.orderListItem?.TotalItem ?? 0)"))"
        self.lblAddress.text = "\(self.orderListItem?.addressLine1 ?? "")"
        self.refundAmountText.isHidden = true
        self.refundAmountLabel.isHidden = true
        if self.orderListItem?.dispute == nil || self.orderListItem?.dispute?.count == 0 {
        } else {
            if self.orderListItem?.dispute?[0].isRefund ?? 0 == 0 {
            } else {
                if self.orderListItem?.dispute?[0].refundedAmount != nil {
                    self.refundAmountText.isHidden = false
                    self.refundAmountLabel.isHidden = false
                    self.refundAmountLabel.text = "$\(self.orderListItem?.dispute?[0].refundedAmount ?? "")"
                }
            }
        }
        
        if self.orderListItem?.vendorRaisedDispute ?? 0 == 0 && self.orderListItem?.vendorDisputeResolved ?? 0 == 0 {
            self.vendorStatusView.isHidden = true
        } else {
            if self.orderListItem?.vendorRaisedDispute ?? 0 == 1 {
                if self.orderListItem?.vendorDisputeResolved ?? 0 == 1 {
                    self.vendorStatusView.isHidden = false
                    self.vendorStatusLabel.text = "Vendor dispute resolved by admin"
                } else {
                    self.vendorStatusView.isHidden = false
                    self.vendorStatusLabel.text = "Dispute raised by vendor"
                }
            }
        }

        if self.orderListItem?.dispute?.count ?? 0 > 0 {
            if self.orderListItem?.dispute?[0].isAdminResolved == 0{
                if self.orderListItem?.isContractor == 1 {
//                    self.btnStckVw.isHidden = false
//                    self.btnCancel.isHidden = true
//                    self.btnComplete.setTitle("Mark As Received", for: .normal)
//                    self.lblStatus.text = "Disputed"
                    if isFrom == "AssignTask" {
                        self.btnStckVw.isHidden = false
                        self.btnCancel.isHidden = true
                        self.btnComplete.isHidden = true
                        if self.orderListItem?.status == 0 {
                            self.lblStatus.text = "Requested"
                        } else {
                            self.lblStatus.text = "Delivered"
                        }
                    } else {
                        setButtons()
                    }
                } else {
                    if isFrom == "AssignTask" {
                        self.btnStckVw.isHidden = false
                        self.btnCancel.isHidden = true
                        self.btnComplete.isHidden = true
                        if self.orderListItem?.status == 0 {
                            self.lblStatus.text = "Requested"
                        } else {
                            self.lblStatus.text = "Delivered"
                        }
                    } else {
                        setButtons()
                    }
                }
            } else {
                if isFrom == "AssignTask" {
                    self.btnStckVw.isHidden = false
                    self.btnCancel.isHidden = true
                    self.btnComplete.isHidden = true
                    if self.orderListItem?.status == 0 {
                        self.lblStatus.text = "Requested"
                    } else {
                        self.lblStatus.text = "Delivered"
                    }
                } else {
                    setButtons()
                }
            }
        } else {
            if isFrom == "AssignTask" {
                self.btnStckVw.isHidden = false
                self.btnCancel.isHidden = true
                self.btnComplete.isHidden = true
                if self.orderListItem?.status == 0 {
                    self.lblStatus.text = "Requested"
                } else {
                    self.lblStatus.text = "Delivered"
                }
            } else {
                setButtons()
            }
        }
    }
    
    func setButtons() {
        if self.orderListItem?.vendorRaisedDispute ?? 0 == 0 && self.orderListItem?.vendorDisputeResolved ?? 0 == 0 {
            self.vendorStatusView.isHidden = true
        } else {
            if self.orderListItem?.vendorRaisedDispute ?? 0 == 1 {
                if self.orderListItem?.vendorDisputeResolved ?? 0 == 1 {
                    self.vendorStatusView.isHidden = false
                    self.vendorStatusLabel.text = "Vendor dispute resolved by admin"
                } else {
                    self.vendorStatusView.isHidden = false
                    self.vendorStatusLabel.text = "Dispute raised by vendor"
                }
            }
        }
        self.vwStatus.backgroundColor = UIColor.appBtnColorOrange
        self.btnStckVw.isHidden = false
        if self.orderListItem?.dispute?.count ?? 0 > 0 {
        if self.orderListItem?.dispute?[0].isAdminResolved == 0 {
            
            if self.orderListItem?.contractorRaisedDispute == 1 {
                self.disputeView.isHidden = false
                self.disputeLabel.isHidden = false
                self.disputeLabel.text = "Dispute raised by you"
            } else {
                self.disputeView.isHidden = true
            }
            
            if self.orderListItem?.isContractor == 1 {
                if self.orderListItem?.status == 4 {
                    self.btnCancel.isHidden = true
                    self.btnComplete.isHidden = false
                    self.btnComplete.setTitle("Mark As Received", for: .normal)
                } else if self.orderListItem?.status ?? 0 <= 4 {
                    self.btnCancel.isHidden = false
                    self.btnComplete.isHidden = true
                    self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                } else {
                    self.btnCancel.isHidden = true
                    self.btnComplete.isHidden = true
                }
                if self.orderListItem?.status == 0 {
                    self.lblStatus.text = "Requested"
                } else if self.orderListItem?.status == 1 {
                    self.lblStatus.text = "Quote Received"
                } else if self.orderListItem?.status == 2 {
                    self.lblStatus.text = "Accepted"
                } else if self.orderListItem?.status == 3 {
                    self.lblStatus.text = "Rejected"
                } else if self.orderListItem?.status == 4 {
                    self.lblStatus.text = "Disputed"
                } else if self.orderListItem?.status == 5 {
                    self.lblStatus.text = "Delivered"
                }

//                if self.orderListItem?.status == 2 {
//                    self.lblStatus.text = "Accepted"
//                    self.btnComplete.isHidden = true
//                    self.btnCancel.isHidden = true
//                } else {
//                    self.lblStatus.text = "Disputed"
//                    self.btnComplete.isHidden = false
//                    self.btnCancel.isHidden = true
//                    self.btnComplete.setTitle("Mark As Received", for: .normal)
//                }

            } else {
                self.btnComplete.isHidden = false
                self.btnCancel.isHidden = false
                if self.orderListItem?.status == 0 {
                    self.btnComplete.isHidden = true
                    self.btnCancel.isHidden = false
                    self.btnCancel.setTitle("Cancel", for: .normal)
                    self.lblStatus.text = "Request Sent"
                } else if self.orderListItem?.status == 1 {
                    self.btnCancel.isHidden = false
                    self.btnComplete.isHidden = false
                    self.btnComplete.setTitle("Accept Order", for: .normal)
                    self.btnCancel.setTitle("Decline", for: .normal)
                    self.lblStatus.text = "Quote Received"
                } else if self.orderListItem?.status == 2 {
                    self.btnCancel.isHidden = false
                    self.btnComplete.isHidden = true
                    self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    self.lblStatus.text = "Accepted"
                } else if self.orderListItem?.status == 3 {
                    self.btnCancel.isHidden = true
                    self.btnComplete.isHidden = true
                    self.lblStatus.text = "Declined"
                } else if self.orderListItem?.status == 4 {
                    self.btnCancel.isHidden = false
                    self.btnComplete.isHidden = false
                    self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    self.btnComplete.setTitle("Mark As Received", for: .normal)
                    self.lblStatus.text = "Dispatch"
                } else if self.orderListItem?.status == 5 {
                    self.btnCancel.isHidden = false
                    self.btnComplete.isHidden = true
                    self.btnCancel.setTitle("Raise A Dispute", for: .normal)
        //            self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                    self.vwStatus.backgroundColor = UIColor.appColorGreen
                    self.lblStatus.text = "Delivered"
                }
            }
        } else {
            self.disputeView.isHidden = false
            self.disputeLabel.isHidden = false
            self.btnCancel.isHidden = true
            self.btnComplete.isHidden = true
            if self.orderListItem?.status == 0 {
                self.btnComplete.isHidden = true
                self.btnCancel.isHidden = false
                self.btnCancel.setTitle("Cancel", for: .normal)
                self.lblStatus.text = "Request Sent"
            } else if self.orderListItem?.status == 1 {
                self.btnCancel.isHidden = false
                self.btnComplete.isHidden = false
                self.btnComplete.setTitle("Accept Order", for: .normal)
                self.btnCancel.setTitle("Decline", for: .normal)
                self.lblStatus.text = "Quote Received"
            } else if self.orderListItem?.status == 2 {
                self.btnCancel.isHidden = true
                self.btnComplete.isHidden = true
                self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                self.lblStatus.text = "Accepted"
            } else if self.orderListItem?.status == 3 {
                self.btnCancel.isHidden = true
                self.btnComplete.isHidden = true
                self.lblStatus.text = "Declined"
            } else if self.orderListItem?.status == 4 {
                self.btnCancel.isHidden = true
                self.btnComplete.isHidden = false
                self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                self.btnComplete.setTitle("Mark As Received", for: .normal)
                self.lblStatus.text = "Dispatch"
            } else if self.orderListItem?.status == 5 {
                self.btnCancel.isHidden = true
                self.btnComplete.isHidden = true
                self.btnCancel.setTitle("Dispute resolved by admin", for: .normal)
                self.btnCancel.borderColor = .white
                self.btnCancel.isEnabled = false
    //            self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                self.vwStatus.backgroundColor = UIColor.appColorGreen
                self.lblStatus.text = "Delivered"
            }
        }
        } else {
            if self.orderListItem?.status == 0 {
                self.btnComplete.isHidden = true
                self.btnCancel.isHidden = false
                self.btnCancel.setTitle("Cancel", for: .normal)
                self.lblStatus.text = "Request Sent"
            } else if self.orderListItem?.status == 1 {
                self.btnCancel.isHidden = false
                self.btnComplete.isHidden = false
                self.btnComplete.setTitle("Accept Order", for: .normal)
                self.btnCancel.setTitle("Decline", for: .normal)
                self.lblStatus.text = "Quote Received"
            } else if self.orderListItem?.status == 2 {
                self.btnCancel.isHidden = true
                self.btnComplete.isHidden = true
           //     self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                self.lblStatus.text = "Accepted"
            } else if self.orderListItem?.status == 3 {
                self.btnCancel.isHidden = true
                self.btnComplete.isHidden = true
                self.lblStatus.text = "Declined"
            } else if self.orderListItem?.status == 4 {
                self.btnCancel.isHidden = false
                self.btnComplete.isHidden = false
                self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                self.btnComplete.setTitle("Mark As Received", for: .normal)
                self.lblStatus.text = "Dispatch"
            } else if self.orderListItem?.status == 5 {
                self.btnCancel.isHidden = false
                self.btnComplete.isHidden = true
                self.btnCancel.setTitle("Raise A Dispute", for: .normal)
//                self.btnCancel.borderColor = .white
//                self.btnCancel.isEnabled = false
    //            self.btnCancel.setTitle("Raise A Dispute", for: .normal)
                self.vwStatus.backgroundColor = UIColor.appColorGreen
                self.lblStatus.text = "Delivered"
            }
        }
//        if self.orderListItem?.status == 0 {
//            self.btnComplete.isHidden = true
//            self.btnCancel.isHidden = false
//            self.btnCancel.setTitle("Cancel", for: .normal)
//            self.lblStatus.text = "Request Sent"
//        } else if self.orderListItem?.status == 1 {
//            self.btnCancel.isHidden = false
//            self.btnComplete.isHidden = false
//            self.btnComplete.setTitle("Accept Order", for: .normal)
//            self.btnCancel.setTitle("Decline", for: .normal)
//            self.lblStatus.text = "Quote Received"
//        } else if self.orderListItem?.status == 2 {
//            self.btnCancel.isHidden = true
//            self.btnComplete.isHidden = true
//       //     self.btnCancel.setTitle("Raise A Dispute", for: .normal)
//            self.lblStatus.text = "Accepted"
//        } else if self.orderListItem?.status == 3 {
//            self.btnCancel.isHidden = true
//            self.btnComplete.isHidden = true
//            self.lblStatus.text = "Declined"
//        } else if self.orderListItem?.status == 4 {
//            self.btnCancel.isHidden = false
//            self.btnComplete.isHidden = false
//            self.btnCancel.setTitle("Raise A Dispute", for: .normal)
//            self.btnComplete.setTitle("Mark As Received", for: .normal)
//            self.lblStatus.text = "Dispatch"
//        } else if self.orderListItem?.status == 5 {
//            self.btnCancel.isHidden = false
//            self.btnComplete.isHidden = true
//            self.btnCancel.setTitle("Dispute Resolve by admin", for: .normal)
//            self.btnCancel.borderColor = .white
//            self.btnCancel.isEnabled = false
////            self.btnCancel.setTitle("Raise A Dispute", for: .normal)
//            self.vwStatus.backgroundColor = UIColor.appColorGreen
//            self.lblStatus.text = "Delivered"
//        }
    }
    
    func updateStatus(cardStatus:Int) {
        let params = ["cartId":"\(self.orderListItem?.id ?? 0)" , "cardStatus":"\(cardStatus)"]
//        showMessage(with: "Marked as received. \nCongratulations! You have successfully marked this order as received.", theme: .success)
        ongoingProejctsCOViewModel.updatecartStatusApi(params) { [self] model in
            if cardStatus == 6 {
                showMessage(with: "Order cancelled successfully")
            } else if cardStatus == 5 {
                showMessage(with: "Marked as received. \nCongratulations! You have successfully marked this order as received.", theme: .success)
            } else if cardStatus == 2 {
                if self.orderListItem?.status == 5 {
                    showMessage(with: "Marked as received. \nCongratulations! You have successfully marked this order as received.", theme: .success)
                } else {
                    showMessage(with: "Order accepted successfully.", theme: .success)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        if self.orderListItem?.status == 0 {
            self.updateStatus(cardStatus: 6)
        } else if self.orderListItem?.status == 1 {
            self.updateStatus(cardStatus: 3)
        } else if self.orderListItem?.status == 2 {
            self.goToRaiseDispute()
        } else if self.orderListItem?.status == 4 {
            self.goToRaiseDispute()
        } else if self.orderListItem?.status == 5 {
            self.goToRaiseDispute()
        }
    }
    
    func goToRaiseDispute() {
        let destinationViewController = Storyboard.orderMaterial.instantiateViewController(withIdentifier: "RaiseADisputeVC") as? RaiseADisputeVC
        destinationViewController?.projectId = self.projectId
        destinationViewController?.subTaskId = self.subTaskId
        destinationViewController?.price = self.orderListItem?.TotalPrice ?? Double(0.0)
        destinationViewController?.cartId = self.orderListItem?.id ?? 0
        destinationViewController?.completionHandlerGoToOrderListing = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        self.present(destinationViewController!, animated: true)
    }
    
    @IBAction func actyionComplete(_ sender: Any) {
        if self.orderListItem?.status == 1 {
            self.updateStatus(cardStatus: 2)
        } else if self.orderListItem?.status == 4 {
            self.updateStatus(cardStatus: 5)
        } else if self.orderListItem?.status == 5 {
            self.updateStatus(cardStatus: 2)
        }
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrderListDetailVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListItem?.Cart_Item?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListItemDetailTableViewCell", for: indexPath) as! OrderListItemDetailTableViewCell
        if self.orderListItem?.Cart_Item?[indexPath.row].productsss?.product_files?.count ?? 0 > 0 {
            cell.itemImageview.sd_setImage(with: URL(string: (self.orderListItem?.Cart_Item?[indexPath.row].productsss?.product_files?[0].file) ?? ""), placeholderImage: UIImage(named: "emptyImage"), completed: nil)
        }
        cell.lblQnty.text = "\(self.orderListItem?.Cart_Item?[indexPath.row].quantity ?? 0)" //"\(self.orderListItem?.TotalItem ?? 0)"
        cell.itemPriceLbl.text = "$\(self.orderListItem?.Cart_Item?[indexPath.row].price ?? Double(0.0))"
        cell.itemTittleLbl.text = "\(self.orderListItem?.Cart_Item?[indexPath.row].item  ?? "") "
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
